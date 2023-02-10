using ENet;
using System;
using Networking.Shared.Packets;
using UnityEngine;
using System.Collections;
using System.Linq;
using Treeverse.Networking.Abilities;

public unsafe class Server_PlayerEntity : Server_CreatureEntity, IEquatable<Server_PlayerEntity>
{
    public Peer Peer;

    public SeedGameClassesEnum playerClass = SeedGameClassesEnum.NULL;
    public SeedersTeamStatus team = SeedersTeamStatus.NULL;
    public GameplayAbility throwSeedAbility;
    private float pickedUpTime;
    [Header("Abilities must be assigned in order")]
    public GameplayAbility[] abilityArray;

    private float[] abilityCoolDownArray = new float[6];

    private PlayerInputs Inputs;
    private PlayerInputsStates receivedInputState;
    private PlayerInputsStates localInputState;
    private PlayerInputsStates previousInputState;
    private double LastRemoteTimestamp;

    private Vector3 NormalizedAim;

    private ByteBuffer ReliableBuffer;

    private effectsEnum[] Inventory = new effectsEnum[10];

    public int Statistics_DamageDealt;
    public int Statistics_DamageMitigated;
    public int Statistics_Healed;
    public int Statistics_Death;
    public int Statistics_Killed;

    public float pressedButtonTimer = 0f;

    public string PlayerName = string.Empty;

    public void BeginReliablePacket()
    {
        if (!ReliableBuffer.IsValid)
        {
            ReliableBuffer = ByteBuffer.CreateWriter(PacketPool.Allocate());
        }
    }

    public void EndReliablePacket()
    {
        if (ReliableBuffer.IsFull)
        {
            FlushBuffers();
        }
    }

    public void SendRuleSetState(Server_RuleSet_GameOfSeed ruleSetManager)
    {
        BeginReliablePacket();
        Server_RuleSetDataPacketProcessor.WriteToRuleSetData(ref ReliableBuffer, ruleSetManager);
        EndReliablePacket();
    }

    public void SendSeedState(Server_PlayerEntity seedHolder, bool bSeedPlanted, int seedLife, int seedGrowth)
    {
        BeginReliablePacket();
        Server_RuleSetDataPacketProcessor.WriteToSetSeedHolder(ref ReliableBuffer, bSeedPlanted, seedHolder, seedLife, seedGrowth);
        EndReliablePacket();
    }
    
    public void SendTreeExplode()
    {
        BeginReliablePacket();
        Server_RuleSetDataPacketProcessor.WriteToTreeExplode(ref ReliableBuffer);
        EndReliablePacket();
    }

    public override void Initialize()
    {
        for (int i = 0; i < Inventory.Length; i++)
            Inventory[i] = effectsEnum.NULL;
        
        base.Initialize();

        BeginReliablePacket();
        
        Client_SetPlayerIdPacketProcessor.WriteTo(ref ReliableBuffer, this);

        EndReliablePacket();
    }

    public void FlushBuffers()
    {
        if (ReliableBuffer.IsValid)
        {
            NetworkManager.SendReliablePacket(ref ReliableBuffer, Peer);            
        }
    }

    public void Cast(GameplayAbility ability)
    {
        if (Time.time >= CanCastAt)
        {
            AnimationTime = 0.0f;

            transform.LookAt(transform.position + NormalizedAim, Vector3.up);

            mp -= ability.manaCost;

            Execution = ability.Cast(this);
            bReadInput = false;
            Execution.OnStart();
        }
    }

    public void AddEffect(effectsEnum effect)
    {
        for(int it = 1; it < Inventory.Length; ++it)
        {
            if (effect != effectsEnum.NULL && Inventory[it] == effect)
            {
                Debug.Log("Effect already in inventory!", gameObject);
                // Reset Effect?
                return;
            }

            if(Inventory[it] == effectsEnum.NULL)
            {
                Debug.Log("Effect : " + effect + " added to player " + NetworkId + " inventory");
                Inventory[it] = effect;
                NetworkManager.RuleSetManagerGameOfSeed.UseItem(effect, this);
                OnItemChanged(it, effect);

                return;
            }
        }

        Debug.Log("Inventory is full! on player with NetworkID : " + NetworkId);
    }

    public void RemoveItem(effectsEnum itemEffect)
    {
        for (int it = 1; it < Inventory.Length; ++it)
        {
            if (Inventory[it] != effectsEnum.NULL && Inventory[it] == itemEffect)
            {
                Inventory[it] = effectsEnum.NULL;
                OnItemChanged(it, effectsEnum.NULL);

                return;
            }
        }
    }

    public void ClearInventory()
    {
        for (int i = 0; i < Inventory.Length; i++)
            Inventory[i] = effectsEnum.NULL;
    }

    //public void ChangeScene(string sceneName, bool isAdditive, Vector3 position)
    //{
    //    BeginReliablePacket();
    //    ServerChangeScenePacketProcessor.WriteTo(ref ReliableBuffer, sceneName, isAdditive,position);
    //    EndReliablePacket();
    //}

    private void OnItemChanged(int slotId, effectsEnum effect)
    {
        BeginReliablePacket();
        Server_RuleSetDataPacketProcessor.WriteToSetEffect(ref ReliableBuffer, NetworkId, slotId, effect);
        EndReliablePacket();
        //FlushBuffers();
    }

    public void SetClass(SeedGameClassesEnum playerNewClass, GameplayAbility[] classAbilities, CharacterAttributes classAttributes)
    {
        playerClass = playerNewClass;
        int converter = (int)playerNewClass + 1;
        VisualId = (VisualPrefabName)converter;
        abilityArray = new GameplayAbility[classAbilities.Length];
        for (int i = 0; i < abilityArray.Length; i++)
            abilityArray[i] = classAbilities[i];
        
        // Inventory[0] = classItem;
        // OnItemChanged(0, classItem);

        // SetStats
        defaultAttributes = classAttributes;
        ResetAttributes();
    }

    public void ResetAttributes()
    {
        maxHp = hp = defaultAttributes.maxHp;
        maxMp = mp = defaultAttributes.maxMp;
        armor = defaultAttributes.armor;
        moveSpeed = defaultAttributes.moveSpeed;
        SpeedMultiplier = 1f;
        
        bInPlantingArea = false;
    }

    public override void UpdatePhysics(float deltaTime)
    {
        if (Controller.isGrounded && !IsDead)
        {
            if (!(receivedInputState == PlayerInputsStates.PRESS && localInputState == PlayerInputsStates.HOLD ||
                receivedInputState == PlayerInputsStates.RELEASE && localInputState == PlayerInputsStates.NULL))
            {
                localInputState = receivedInputState;
            }
            
            int inputIdx = DumbFlagEnumConverter();
            if (Execution != null)
            {
                /* Try interrupt if we have movement input */
                if (NormalizedMovementInput.sqrMagnitude > 0)
                    Execution.TryInterrupt();

                // OnKeyDown/Up
                if (localInputState == PlayerInputsStates.PRESS)
                {
                    Execution.OnKeyDown();
                }
                else if (localInputState == PlayerInputsStates.RELEASE)
                {
                    Execution.OnKeyUp();
                }
            }
            else
            {
                if (localInputState == PlayerInputsStates.HOLD) pressedButtonTimer += Time.deltaTime;
                else if (localInputState == PlayerInputsStates.NULL) pressedButtonTimer = 0f;

                // Pick up Seed --- Pick up Distance hardcoded
                // if (!NetworkManager.RuleSetManager.bSeedPlanted && NetworkManager.RuleSetManager.IsPlayerAttacker(this) && NetworkManager.RuleSetManager.seedTr != null &&
                //     NetworkManager.RuleSetManager.GetSeedHolderID() == -1 && inputIdx == 1 &&
                //     Vector3.Distance(NetworkManager.RuleSetManager.seedTr.position, transform.position) < 2)
                // {
                //     NetworkManager.RuleSetManager.SetSeedHolder(this);
                //     pickedUpTime = Time.time + 1.5f;
                // }
                // else
                if (receivedInputState == PlayerInputsStates.RELEASE)
                {
                    // Throw / Plant the seed if SeedHolder
                    if (NetworkId == NetworkManager.RuleSetManagerGameOfSeed.GetSeedHolderNetworkID() && inputIdx == 1 && Time.time > pickedUpTime)
                    {
                        NetworkManager.RuleSetManagerGameOfSeed.SeedHolderThrow(this);
                        //Cast(throwSeedAbility);
                    }
                    else if (inputIdx == 5)
                    {
                        CastMock();
                    }
                    else if (inputIdx != 0
                             && abilityArray[inputIdx - 1].manaCost <= mp
                             && Time.time >= abilityCoolDownArray[inputIdx - 1]
                             && Time.time > pickedUpTime)
                    {
                        abilityCoolDownArray[inputIdx - 1] = Time.time + abilityArray[inputIdx - 1].cooldown;
                        Cast(abilityArray[inputIdx - 1]);
                    }
                }
            }

            if (previousInputState != localInputState)
            {
                if (localInputState == PlayerInputsStates.PRESS)
                    localInputState = PlayerInputsStates.HOLD;
                else if (localInputState == PlayerInputsStates.RELEASE)
                    localInputState = PlayerInputsStates.NULL;
                previousInputState = localInputState;
            }
        }

        base.UpdatePhysics(deltaTime);
    }

    protected override void abilityInterruptByOuch()
    {
        //Debug.Log("Ability interrupt by ouch!");
        for (int i = 0; i < abilityArray.Length; i++)
        {
            if (abilityArray[i] == Execution.GetAbility())
            {
                //Debug.Log("Ability " + abilityArray[i].name + " is being interrupted");
                ClassicAttackAbility attackAbility = abilityArray[i] as ClassicAttackAbility;
                if (attackAbility != null)
                {
                    float attackTime = attackAbility.detectPlayersAtThisTime;
                    if (AnimationTime > attackTime)
                        abilityCoolDownArray[i] = 0f;
                }
                break;
            }
        }
    }

    public void SetSeedHolder()
    {
        NetworkManager.RuleSetManagerGameOfSeed.SetSeedHolder(this);
        pickedUpTime = Time.time + 1.5f;
    }

    private int DumbFlagEnumConverter()
    {
        if ((Inputs & PlayerInputs.Action1) == PlayerInputs.Action1)
            return 1;
        if ((Inputs & PlayerInputs.Action2) == PlayerInputs.Action2)
            return 2;
        if ((Inputs & PlayerInputs.Action3) == PlayerInputs.Action3)
            return 3;
        if ((Inputs & PlayerInputs.Action4) == PlayerInputs.Action4)
            return 4;
        if ((Inputs & PlayerInputs.Action5) == PlayerInputs.Action5)
            return 5;
        return 0;
    }

    public override void OnDestroy()
    {
        base.OnDestroy();

        NetworkManager.NetworkedEntities.Return(NetworkId);

        NetworkManager.RemovePeer(Peer);
    }

    public void ProcessSnapshot(ref SnapshotSerializer serializer)
    {
        float inputX = serializer.Buffer.GetShort() / 1000.0f;
        float inputZ = serializer.Buffer.GetShort() / 1000.0f;

        float aimX = serializer.Buffer.GetShort() / 1000.0f;
        float aimZ = serializer.Buffer.GetShort() / 1000.0f;

        PlayerInputs inputs = (PlayerInputs)(serializer.Buffer.GetUInt());
        PlayerInputsStates inputState = (PlayerInputsStates)(serializer.Buffer.GetUInt());

        if (serializer.Timestamp >= LastRemoteTimestamp)
        {
            LastRemoteTimestamp = serializer.Timestamp;

            if (bReadInput)
                NormalizedMovementInput = new Vector3(inputX, 0.0f, inputZ);
            else
                NormalizedMovementInput = Vector3.zero;
            NormalizedMovementInput.Normalize();

            NormalizedAim = new Vector3(aimX, 0.0f, aimZ);
            NormalizedAim.Normalize();

            Inputs = inputs;
            receivedInputState = inputState;
        }
    }

    protected override void OnAddTo(Server_Chunk chunk)
    {
        chunk.AddPlayer(this);
    }

    protected override void OnRemoveFrom(Server_Chunk chunk)
    {
        chunk.RemovePlayer(this);
    }

    public bool Equals(Server_PlayerEntity other)
    {
        return this == other;
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.layer == LayerMask.NameToLayer("PlantingArea"))
        {
            bInPlantingArea = true;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.layer == LayerMask.NameToLayer("PlantingArea"))
        {
            bInPlantingArea = false;
        }
    }

    public void ResetGameContribute()
    {
        Statistics_DamageDealt = 0;
        Statistics_DamageMitigated = 0;
        Statistics_Healed = 0;
        Statistics_Death = 0;
        Statistics_Killed = 0;
    }
}
