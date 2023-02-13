using ENet;
using System;
using UnityEngine;
using System.Collections;
using System.Linq;
using Treeverse.Networking.Abilities;

public unsafe class Server_PlayerEntity : Server_CreatureEntity, IEquatable<Server_PlayerEntity>
{
    public Peer Peer;

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

    public float pressedButtonTimer = 0f;

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

    public void SendGameState(Server_RuleSet_MMORPG ruleSetManager)
    {
        BeginReliablePacket();
        Server_RuleSetDataPacketProcessor.WriteToRuleSetData(ref ReliableBuffer, ruleSetManager);
        EndReliablePacket();
    }
    
    public void SendCollectResource(Server_RuleSet_MMORPG ruleSetManager, CollectiblesEnum resource, int howMany, int networkId)
    {
        Debug.Log("Send collect Resource");
        
        BeginReliablePacket();
        Server_RuleSetDataPacketProcessor.WriteToCollectResources(ref ReliableBuffer, ruleSetManager, resource, howMany, networkId);
        EndReliablePacket();
    }

    public override void Initialize()
    {
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

                if (inputIdx != 0 && receivedInputState == PlayerInputsStates.RELEASE)
                {
                    Server_ActorEntity serverActorEntity = GetClosestInteractibleActor();

                    bool bCastPriorityAbility = false;

                    if (inputIdx == 5)
                    {
                        CastMock();
                        bCastPriorityAbility = true;
                    }
                    else if (inputIdx == 1 && serverActorEntity != null)
                    {
                        if (serverActorEntity.actorType == ActorTypesEnum.Tree && serverActorEntity.VisualId == VisualPrefabName.SmallTree)
                        {
                            // Chop tree
                            Cast(abilityArray[0]);
                            serverActorEntity.VisualId = VisualPrefabName.SmallTreeStump;
                            SendCollectResource(NetworkManager.RuleSetManagerMMorpg, CollectiblesEnum.Wood, 3, serverActorEntity.NetworkId);
                            bCastPriorityAbility = true;
                        }
                        else if (serverActorEntity.actorType == ActorTypesEnum.Ore && serverActorEntity.VisualId == VisualPrefabName.Ore)
                        {
                            Cast(abilityArray[0]);
                            serverActorEntity.VisualId = VisualPrefabName.OreMined;
                            SendCollectResource(NetworkManager.RuleSetManagerMMorpg, CollectiblesEnum.Ore, 3, serverActorEntity.NetworkId);
                            bCastPriorityAbility = true;
                        }
                    }
                    
                    if (!bCastPriorityAbility && abilityArray[inputIdx - 1].manaCost <= mp
                                             && Time.time >= abilityCoolDownArray[inputIdx - 1])
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

    private Server_ActorEntity GetClosestInteractibleActor()
    {
        return NetworkManager.RuleSetManagerMMorpg.actorSpawner.GetClosestInteractibleActorToPos(transform.position);
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
}
