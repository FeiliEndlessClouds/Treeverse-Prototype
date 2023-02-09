#define DEBUG

using System.Collections;
using UnityEngine;
using System.Collections.Generic;
using System;

public enum SeedGameStatesEnum
{
    MATCHMAKING,
    SELECT_CLASS,
    PREPARE_ARENA,
    GAME_A_ATK_B_DFS,
    GAME_B_ATK_A_DFS,
    GAME_RESULTS,
    GAME_END,
    NULL
}

public enum SeedGameClassesEnum
{
    BARBARIAN,
    RANGER,
    PALADIN,
    ASSASSIN,
    SORCERER,

    COUNT,
    NULL = 100
}

public enum SeedersTeamStatus
{
    NULL,
    TEAM_A,
    TEAM_B
}

// If the Seed turns into a tree, a special effect is applied next round.
public enum SeedGrownEffectEnum
{
    NONE
}

public unsafe class Server_RuleSet_GameOfSeed : MonoBehaviour
{
    public bool bActive = true;

    private bool goFight = false;
    public bool isReadyToFight = false;

    public SeedGameStatesEnum gameState = SeedGameStatesEnum.MATCHMAKING;
    public SeedGameStatesEnum previousGameState;

    private Server_NetworkManager _serverNetworkManager;
    private ByteBuffer ReliableBuffer;

    public int maxPlayersPerGame = 6;

    // Server side, Server_Entity won't destroy on time out, so I should be safe caching entities
    public List<Server_PlayerEntity> playerList = new List<Server_PlayerEntity>();
    public List<SeedersTeamStatus> playersTeamStatusList = new List<SeedersTeamStatus>();
    private List<effectsEnum[]> effectsList = new List<effectsEnum[]>();
    private Server_InventoryManager inventoryManager = new Server_InventoryManager();

    public Server_PlayerEntity[] teamAPlayers;
    public Server_PlayerEntity[] teamBPlayers;

    public AnimationCurve sCurve;

    // For Bot
    public int playerCount = 0;

    public Transform[] attackersSpawnLocatorArray;
    public Transform[] defendersSpawnLocatorArray;

    [Header("Seed")]
    public GameObject seedPrefab;
    public Server_PlayerEntity seedHolder;
    public Transform seedTr;
    public Server_SeedEntity seedScript;
    public Transform seedSpawnLocator;
    public int seedMaxLife = 500;
    private int seedLife = 500;
    public int seedArmor = 0;
    public int treeGrowth = 0;
    public SeedGrownEffectEnum seedEffect = SeedGrownEffectEnum.NONE;
    public bool bSeedPlanted = false;
    public float growerSqrDistance = 9;
    public float treeExplodeTimer = 6f;

    [Header("SCORING")]
    public int match;
    public SeedersTeamStatus[] matchesWonByTeam = new SeedersTeamStatus[4];
    public bool bMatchEnded;
    private SeedersTeamStatus winners = SeedersTeamStatus.NULL;
    private float matchTimerCountDown = 60f;
    private float matchTime = 60f;

    public Transform itemsRootTr;
    private Server_ItemSpawner[] allGameItems;

    [Header("BARBARIAN CLASS DATA")]
    public GameplayAbility[] barbarianAbilities = new GameplayAbility[4];
    [Header("RANGER CLASS DATA")]
    public GameplayAbility[] rangerAbilities = new GameplayAbility[4];
    [Header("PALADIN CLASS DATA")]
    public GameplayAbility[] paladinAbilities = new GameplayAbility[4];
    [Header("ASSASSIN CLASS ABILITIES")]
    public GameplayAbility[] assassinAbilities = new GameplayAbility[4];
    [Header("SORCERER CLASS ABILITIES")]
    public GameplayAbility[] sorcererAbilities = new GameplayAbility[4];

    [Header("All ClassAttributes in order")]
    public CharacterAttributes[] AllClassAttributes;

    // That's really for designers convenience.
    private GameplayAbility[][] allAbilities = new GameplayAbility[(int)SeedGameClassesEnum.COUNT][];

    private void GetTeamsCount(out int countOfTeamA, out int countOfTeamB)
    {
        countOfTeamA = 0;
        countOfTeamB = 0;
        foreach (SeedersTeamStatus s in playersTeamStatusList)
        {
            if (s == SeedersTeamStatus.TEAM_A)
                countOfTeamA++;
            else if (s == SeedersTeamStatus.TEAM_B)
                countOfTeamB++;
        }
    }

    void OnValidate()
    {
        if (barbarianAbilities.Length != 4 || rangerAbilities.Length != 4 || paladinAbilities.Length != 4 ||
            assassinAbilities.Length != 4 || sorcererAbilities.Length != 4)
        {
            Debug.LogWarning("Don't change the class abilities array size!");

            if (barbarianAbilities.Length != 4) Array.Resize(ref barbarianAbilities, 4);
            if (rangerAbilities.Length != 4) Array.Resize(ref rangerAbilities, 4);
            if (paladinAbilities.Length != 4) Array.Resize(ref paladinAbilities, 4);
            if (assassinAbilities.Length != 4) Array.Resize(ref assassinAbilities, 4);
            if (sorcererAbilities.Length != 4) Array.Resize(ref sorcererAbilities, 4);
        }
    }

    private void OnEnable()
    {
        Server_NetworkManager.OnPlayerConnected += Server_NetworkManager_OnPlayerConnected;
        Server_NetworkManager.OnPlayerDisconnected += Server_NetworkManager_OnPlayerDisconnected;
    }

    private void CheckIsReadyToFight()
    {
        int countOfTeamA, countOfTeamB;
        GetTeamsCount(out countOfTeamA, out countOfTeamB);
        if (countOfTeamA > 0 && countOfTeamA <= (maxPlayersPerGame / 2) && countOfTeamA == countOfTeamB)
            isReadyToFight = true;
        else
            isReadyToFight = false;
    }

    public void GameContribute(int networkID, int damageDealt, int damageMitigated, int healed, int death, int killed)
    {
        for (int i = 0; i < playerList.Count; i++)
        {
            if (playerList[i].NetworkId == networkID)
            {
                playerList[i].Statistics_DamageDealt += damageDealt;
                playerList[i].Statistics_DamageMitigated += damageMitigated;
                playerList[i].Statistics_Healed += healed;
                playerList[i].Statistics_Death += death;
                playerList[i].Statistics_Killed += killed;
                break;
            }
        }
    }

    private void Server_NetworkManager_OnPlayerConnected(Server_PlayerEntity player)
    {
        SeedersTeamStatus assignedTeam = SeedersTeamStatus.NULL;
        int countOfTeamA, countOfTeamB;
        GetTeamsCount(out countOfTeamA, out countOfTeamB);
        if (countOfTeamA <= countOfTeamB)
            assignedTeam = SeedersTeamStatus.TEAM_A;
        else
            assignedTeam = SeedersTeamStatus.TEAM_B;

        playerCount++;
        // Might be useless, unless using pool to instantiate
        player.team = assignedTeam;
        player.GameContributeEvent += new GameContributeEventHandler(GameContribute);
        playerList.Add(player);
        playersTeamStatusList.Add(assignedTeam);
        effectsList.Add(new effectsEnum[10]);

        if (bActive)
        {
            player.ClearInventory();
            CheckIsReadyToFight();
            SendGameState();
        }
        else
            player.SetClass(SeedGameClassesEnum.BARBARIAN, barbarianAbilities, AllClassAttributes[(int)SeedGameClassesEnum.BARBARIAN]);
    }

    private void Server_NetworkManager_OnPlayerDisconnected(Server_PlayerEntity player)
    {
        playerCount--;
        for (int i = 0; i < playerList.Count; i++)
        {
            if (player.NetworkId == playerList[i].NetworkId)
            {
                playersTeamStatusList.RemoveAt(i);
                playersTeamStatusList.TrimExcess();
                effectsList.RemoveAt(i);
                effectsList.TrimExcess();
                playerList.RemoveAt(i);
                playerList.TrimExcess();
                CheckIsReadyToFight();
                SendGameState();
                break;
            }
        }
    }

    private void OnDisable()
    {
        Server_NetworkManager.OnPlayerConnected -= Server_NetworkManager_OnPlayerConnected;
        Server_NetworkManager.OnPlayerDisconnected -= Server_NetworkManager_OnPlayerDisconnected;
    }

    public void SeedTakeDamage(int damage)
    {
        if (seedScript.bHeld)
            return;

        int dealtDamage = damage - seedArmor;
        dealtDamage = Mathf.Clamp(dealtDamage, 0, 99999);
        seedLife -= dealtDamage;
        if (seedLife < 0)
            seedLife = 0;
        SendSeedState();
    }

    public void UseItem(effectsEnum whichEffect, Server_PlayerEntity player)
    {
        inventoryManager.UseItem(whichEffect, player, this);
    }

    public void StartItemCoroutine(IEnumerator coroutineMethod)
    {
        StartCoroutine(coroutineMethod);
    }

    public void Initialize(Server_NetworkManager serverNetworkManager)
	{
		_serverNetworkManager = serverNetworkManager;
        inventoryManager.GameContributeEvent += new GameContributeEventHandler(GameContribute);

        // That's really for designers convenience.
        allAbilities[(int)SeedGameClassesEnum.BARBARIAN] = barbarianAbilities;
        allAbilities[(int)SeedGameClassesEnum.RANGER] = rangerAbilities;
        allAbilities[(int)SeedGameClassesEnum.PALADIN] = paladinAbilities;
        allAbilities[(int)SeedGameClassesEnum.ASSASSIN] = assassinAbilities;
        allAbilities[(int)SeedGameClassesEnum.SORCERER] = sorcererAbilities;

        if (bActive)
        {
            StartCoroutine(FSM());
        }
    }

    public int GetGrowersCount()
    {
        int growersCount = 0;
        Server_PlayerEntity[] attackersTeam = (gameState == SeedGameStatesEnum.GAME_A_ATK_B_DFS) ? 
                teamAPlayers : teamBPlayers;

        for (int i = 0; i < attackersTeam.Length; i++)
        {
            if ((attackersTeam[i].transform.position - seedTr.position).sqrMagnitude < growerSqrDistance)
                growersCount++;
        }
        return growersCount;
    }

    public int GetSeedHolderNetworkID()
    {
        if (!seedHolder)
            return -1;
        else
            return seedHolder.NetworkId;
    }

    public bool IsPlayerAttacker(Server_PlayerEntity player)
    {
        if ((gameState == SeedGameStatesEnum.GAME_A_ATK_B_DFS && player.team == SeedersTeamStatus.TEAM_A) ||
            (gameState == SeedGameStatesEnum.GAME_B_ATK_A_DFS && player.team == SeedersTeamStatus.TEAM_B))
            return true;
        else
            return false;
    }

    public void SetSeedHolder(Server_PlayerEntity player)
    {
        Debug.Log("<color=lime>SERVER : </color> Seed holder is now player with networkID : " + player.NetworkId, player.gameObject);
        seedHolder = player;
        seedHolder.SpeedMultiplier = 0.75f;
        
        seedScript.SetHeld(true);
        seedTr.SetParent(seedHolder.transform);
        StartCoroutine(PickUpSeed(GetSeedHeight(seedHolder.playerClass)));
        SendSeedState();
    }

    private float GetSeedHeight(SeedGameClassesEnum whichClass)
    {
        if (whichClass == SeedGameClassesEnum.ASSASSIN)
            return 1.5f;
        else if (whichClass == SeedGameClassesEnum.BARBARIAN)
            return 1.75f;
        else if (whichClass == SeedGameClassesEnum.PALADIN)
            return 2f;
        else if (whichClass == SeedGameClassesEnum.RANGER)
            return 1.8f;
        else
            return 1.5f;
    }

    IEnumerator PickUpSeed(float seedHeight)
    {
        float timer = 0f;
        Vector3 startPos = seedTr.localPosition;
        Vector3 endPos = Vector3.up * seedHeight;
        while (timer < 1f)
        {
            timer += Time.deltaTime * 10f;
            seedTr.localPosition = Vector3.Lerp(startPos, endPos, sCurve.Evaluate(timer));
            yield return null;
        }
        seedTr.localPosition = endPos;
    }
    
    public void SeedHolderThrow(Server_PlayerEntity player)
    {
        Debug.Log("<color=lime>SERVER : </color> Seed holder threw the Seed!");
        seedHolder.SpeedMultiplier = 1f;
        seedHolder = null;
        seedTr.SetParent(null);
        seedScript.SetHeld(false);
        if (player.bInPlantingArea)
        {
            seedScript.AddForce(player.transform.forward, 1f);
            // SEED HAS BEEN PLANTED!
            seedScript.SetPlanted();
            bSeedPlanted = true;
        }
        else
        {
            StartCoroutine(seedScript.SetGoLayerForASecC());

            // Throw to closest teammate
            // List<Server_PlayerEntity> sortedTeamMates = new();
            // foreach (Server_PlayerEntity p in playerList)
            // {
            //     if (p.NetworkId != player.NetworkId && p.team == player.team && !p.IsDead)
            //         sortedTeamMates.Add(p);
            // }
            // sortedTeamMates = sortedTeamMates.OrderBy(x => Vector3.Distance(player.transform.position, x.transform.position)).ToList();
            // Vector3 throwDir = player.transform.forward;
            // if (sortedTeamMates.Count > 0 && Vector3.Distance(sortedTeamMates[0].transform.position, player.transform.position) < 10)
            //     throwDir = (sortedTeamMates[0].transform.position - player.transform.position).normalized;

            //seedScript.AddForce(throwDir, 20f);
            seedScript.AddForce(player.transform.forward, 17.5f);
        }

        SendSeedState();
    }

    public void DropSeed(Server_PlayerEntity player)
    {
        Debug.Log("<color=lime>SERVER : </color> Seed holder dropped the Seed!");
        seedHolder.SpeedMultiplier = 1f;
        seedHolder = null;
        seedTr.SetParent(null);
        seedScript.SetHeld(false);
        StartCoroutine(seedScript.SetGoLayerForASecC());
        seedScript.AddForce(player.transform.forward, -12f);
        
        seedScript.SetCannotBePickedTimer(3f);
        SendSeedState();
    }

    public void SpawnAllGroundItem()    // Maybe buffer if the stutter doesn't feel good
    {
        for (int i = 0; i < allGameItems.Length; i++)
            Server_GroundItemEntity.Spawn(allGameItems[i].transform, _serverNetworkManager, allGameItems[i].visualId, allGameItems[i].effect, i);
    }

    public void SetRespawnGroundItem(int idx)
    {
        StartCoroutine(SpawnOneGroundItemC(idx));
    }
    
    IEnumerator SpawnOneGroundItemC(int index)
    {
        yield return new WaitForSeconds(6f);
        Server_GroundItemEntity.Spawn(allGameItems[index].transform, _serverNetworkManager, allGameItems[index].visualId, allGameItems[index].effect, index);
    }

    private void SpawnBot()
    {
        Debug.Log("<color=lime>SERVER : </color>Spawning Bot...");
        playerCount++;
        _serverNetworkManager.SpawnBot();
    }

    public void SendGameState()
    {
        if (playerList.Count == 0)
            return;
     
        for (int i = 0; i < playerList.Count; i++)
            playerList[i].SendRuleSetState(this);
    }

    // Send player.NetworkId to all players to notify who holds the Seed.
    private void SendSeedState()
    {       
        for (int i = 0; i < playerList.Count; i++)
            playerList[i].SendSeedState(seedHolder, bSeedPlanted, seedLife, treeGrowth);
    }

    private void SendTreeExplode()
    {
        for (int i = 0; i < playerList.Count; i++)
            playerList[i].SendTreeExplode();
    }

    public void TreeScored()
    {
        // TREE SCORED
        treeGrowth = 100;
        SendSeedState();
    }

    private void Awake()
    {
        allGameItems = new Server_ItemSpawner[itemsRootTr.childCount];
        for (int i = 0; i < allGameItems.Length; i++)
            allGameItems[i] = itemsRootTr.GetChild(i).GetComponent<Server_ItemSpawner>();
    }

    private void SpawnSeed()
    {
        if (seedScript)
        {
            Debug.Log("Seed was already spawned, spawn seed cancelled");
            seedScript.SetHeld(false);
            return;
        }

        seedTr = ObjectPoolManager.CreatePooled(seedPrefab, seedSpawnLocator.position, Quaternion.identity).transform;
        seedScript = seedTr.GetComponent<Server_SeedEntity>();
        seedScript.NetworkManager = _serverNetworkManager;
        seedScript.SetHeld(false);
    }

#if DEBUG
    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.F1))
            SetClass(playerList[0], SeedGameClassesEnum.BARBARIAN);
        else if (Input.GetKeyDown(KeyCode.F2))
            SetClass(playerList[0], SeedGameClassesEnum.RANGER);
        else if (Input.GetKeyDown(KeyCode.F3))
        {
            foreach (var player in playerList)
                SetClass(player, SeedGameClassesEnum.PALADIN);
        }
        else if (Input.GetKeyDown(KeyCode.F4))
            SetClass(playerList[0], SeedGameClassesEnum.ASSASSIN);
        else if (Input.GetKeyDown(KeyCode.F5))
            SetClass(playerList[0], SeedGameClassesEnum.SORCERER);
        else if (Input.GetKeyDown(KeyCode.F5))
            SetClass(playerList[0], SeedGameClassesEnum.SORCERER);
        
        if (Input.GetKeyUp(KeyCode.U))
        {
            foreach (var p in playerList)
            {
                StartCoroutine(RandomSimulAttackC(p));
            }
        }
    }

    IEnumerator RandomSimulAttackC(Server_PlayerEntity p)
    {
        yield return new WaitForSeconds(UnityEngine.Random.Range(0f, 0.3f));
        p.Cast(p.abilityArray[1]);
    }

#endif

    IEnumerator FSM()
    {
        SetGameState(SeedGameStatesEnum.MATCHMAKING, "Init Game of Seed Rule Set");

        while (bActive)
            yield return StartCoroutine(gameState.ToString());
    }

    private void SetGameState(SeedGameStatesEnum newState, string reason)
    {
        previousGameState = gameState;
        gameState = newState;
        Debug.Log("<color=Lime>SERVER : </color>Leaving " + previousGameState.ToString() + ", going to  " + gameState.ToString() + ". Reason : " + reason);

        // All players receives the StateChange.
        SendGameState();
    }

    public void Fight()
    {
        goFight = true;
    }

    IEnumerator MATCHMAKING()
    {
        while (playerList.Count == 0)
            yield return null;

        SendGameState();

        if (maxPlayersPerGame % 2 != 0)
            Debug.LogError("maxPlayersPerGame needs to be divisible by 2");

        goFight = false;
        
        while (gameState == SeedGameStatesEnum.MATCHMAKING)
        {
            if (isReadyToFight && goFight)
            {
                int countOfTeamA, countOfTeamB;
                GetTeamsCount(out countOfTeamA, out countOfTeamB);

                teamAPlayers = new Server_PlayerEntity[countOfTeamA];
                teamBPlayers = new Server_PlayerEntity[countOfTeamB];

                int teamAIdx = 0;
                int teamBIdx = 0;
                for (int i = 0; i < playerList.Count; i++)
                {
                    if (i > teamAPlayers.Length + teamBPlayers.Length)
                        break;

                    if (playerList[i].team == SeedersTeamStatus.TEAM_A)
                    {
                        teamAPlayers[teamAIdx] = playerList[i]; ;
                        playersTeamStatusList[i] = SeedersTeamStatus.TEAM_A;
                        teamAIdx++;
                    }
                    else if (playerList[i].team == SeedersTeamStatus.TEAM_B)
                    {
                        teamBPlayers[teamBIdx] = playerList[i]; ;
                        playersTeamStatusList[i] = SeedersTeamStatus.TEAM_B;
                        teamBIdx++;
                    }
                }

                SetGameState(SeedGameStatesEnum.SELECT_CLASS, "Matchmaking and Team Selection done.");
            }

            yield return null;
        }
    }

    public void SwitchTeam(int networkID)
    {
        for (int i = 0; i < playerList.Count; i++)
        {
            if (playerList[i].NetworkId == networkID)
            {
                if (playerList[i].team == SeedersTeamStatus.TEAM_A)
                {
                    playerList[i].team = SeedersTeamStatus.TEAM_B;
                    playersTeamStatusList[i] = SeedersTeamStatus.TEAM_B;
                    break;
                }
                else if (playerList[i].team == SeedersTeamStatus.TEAM_B)
                {
                    playerList[i].team = SeedersTeamStatus.TEAM_A;
                    playersTeamStatusList[i] = SeedersTeamStatus.TEAM_A;
                    break;
                }
            }
        }

        CheckIsReadyToFight();
        SendGameState();
    }

    private void SetClass(Server_PlayerEntity player, SeedGameClassesEnum whichClass)
    {
        player.SetClass(whichClass, allAbilities[(int)whichClass], AllClassAttributes[(int)whichClass]);

        // -- Tell all players this player changed class -- //
      
        for (int i = 0; i < playerList.Count; i++)
        {
            // Begin ReliablePacket (Always gets new buffer)
            ReliableBuffer = ByteBuffer.CreateWriter(PacketPool.Allocate());

            // Insert data
            Server_RuleSetDataPacketProcessor.WriteToSetClass(ref ReliableBuffer, player.NetworkId, whichClass);

            // Send packet.
            if (!ReliableBuffer.IsValid)
                Debug.LogWarning("ReliableBuffer has an empty Data (ByteBuffer.IsValid)");

            if (ReliableBuffer.IsFull)
                Debug.LogError("SetClass buffer is full");

            _serverNetworkManager.SendReliablePacket(ref ReliableBuffer, playerList[i].Peer);
        }
    }

    IEnumerator SELECT_CLASS()
    {
        // No timer, no countdown, select character, no cancelling
        foreach (Server_PlayerEntity player in teamAPlayers)
        {
            if (player != null)
            {
                player.playerClass = SeedGameClassesEnum.NULL;
                player.ClearInventory();
            }
        }
        foreach (Server_PlayerEntity player in teamBPlayers)
        {
            if (player != null)
            {
                player.playerClass = SeedGameClassesEnum.NULL;
                player.ClearInventory();
            }
        }

        bool[] teamAReady = new bool[teamAPlayers.Length];
        bool[] teamBReady = new bool[teamBPlayers.Length];
        int readyCount = 0;
        while (gameState == SeedGameStatesEnum.SELECT_CLASS)
        {
            for (int i = 0; i < teamAPlayers.Length; i++)
            {
                if (!teamAReady[i])
                {
                    if (teamAPlayers[i].playerClass != SeedGameClassesEnum.NULL)
                    {
                        SetClass(teamAPlayers[i], teamAPlayers[i].playerClass);
                        teamAPlayers[i].SetPositionAndRotation(attackersSpawnLocatorArray[i].position, attackersSpawnLocatorArray[i].rotation);
                        teamAReady[i] = true;
                        readyCount++;
                    }
                }
            }

            for (int i = 0; i < teamBPlayers.Length; i++)
            {
                if (!teamBReady[i])
                {
                    if (teamBPlayers[i].playerClass != SeedGameClassesEnum.NULL)
                    {
                        SetClass(teamBPlayers[i], teamBPlayers[i].playerClass);
                        teamBPlayers[i].SetPositionAndRotation(defendersSpawnLocatorArray[i].position, defendersSpawnLocatorArray[i].rotation);
                        teamBReady[i] = true;
                        readyCount++;
                    }
                }
            }

            if (readyCount == teamAReady.Length + teamBReady.Length)
                SetGameState(SeedGameStatesEnum.PREPARE_ARENA, "All player classes selected!");

            yield return null;
        }
    }
    IEnumerator PREPARE_ARENA()
    {
        seedLife = seedMaxLife;
        for (int i = 0; i < matchesWonByTeam.Length; i++)
            matchesWonByTeam[i] = SeedersTeamStatus.NULL;
        SpawnAllGroundItem();
        yield return new WaitForSeconds(1.5f);

        SpawnSeed();

        if (previousGameState != SeedGameStatesEnum.SELECT_CLASS)
        {
            for (int i = 0; i < playerList.Count; i++)
                playerList[i].bReadInput = false;
            ResetMatch();
            yield return null;
            for (int i = 0; i < playerList.Count; i++)
                playerList[i].bReadInput = true;
        }
        yield return StartCoroutine(seedScript.SetPositionC(seedSpawnLocator.position));

        yield return null;yield return null;
        SetGameState(SeedGameStatesEnum.GAME_A_ATK_B_DFS, "Arena ready! Let's fight!");
    }
    IEnumerator GAME_A_ATK_B_DFS()
    {
        if (previousGameState == SeedGameStatesEnum.GAME_B_ATK_A_DFS)
        {
            for (int i = 0; i < playerList.Count; i++)
                playerList[i].bReadInput = false;
            yield return StartCoroutine(seedScript.SetPositionC(seedSpawnLocator.position));
            ResetMatch();
            yield return null;
            for (int i = 0; i < playerList.Count; i++)
                playerList[i].bReadInput = true;
        }

        int enteredPlayerCount = playerCount;
        int teamPlayerCount = playerCount / 2;

        bool[] bIsDeadTeamA = new bool[teamAPlayers.Length];
        bool[] bIsDeadTeamB = new bool[teamBPlayers.Length];

        while (gameState == SeedGameStatesEnum.GAME_A_ATK_B_DFS)
        {
            if (playerCount < enteredPlayerCount)
                SetGameState(SeedGameStatesEnum.MATCHMAKING, "Go back to MATCHMAKING!");

            // Death revives
            for (int i = 0; i < teamPlayerCount; i++)
            {
                if (!bIsDeadTeamA[i])
                {
                    if (teamAPlayers[i].hp <= 0)
                    {
                        StartCoroutine(DeathTimer(teamAPlayers[i], attackersSpawnLocatorArray[i]));
                        bIsDeadTeamA[i] = true;
                    }
                }
                else if (teamAPlayers[i].hp > 0)
                    bIsDeadTeamA[i] = false;

                if (!bIsDeadTeamB[i])
                {
                    if (teamBPlayers[i].hp <= 0)
                    {
                        StartCoroutine(DeathTimer(teamBPlayers[i], defendersSpawnLocatorArray[i]));
                        bIsDeadTeamB[i] = true;
                    }
                }
                else if (teamBPlayers[i].hp > 0)
                    bIsDeadTeamB[i] = false;
            }

            GameUpdater();

            if (bMatchEnded)
                yield return StartCoroutine(CelebrationC());

            yield return null;
        }
    }
    IEnumerator GAME_B_ATK_A_DFS()
    {
        if (previousGameState == SeedGameStatesEnum.GAME_A_ATK_B_DFS)
        {
            for (int i = 0; i < playerList.Count; i++)
                playerList[i].bReadInput = false;
            yield return StartCoroutine(seedScript.SetPositionC(seedSpawnLocator.position));
            ResetMatch();
            yield return null;
            for (int i = 0; i < playerList.Count; i++)
                playerList[i].bReadInput = true;
        }

        int enteredPlayerCount = playerCount;
        int teamPlayerCount = playerCount / 2;

        bool[] bIsDeadTeamA = new bool[teamAPlayers.Length];
        bool[] bIsDeadTeamB = new bool[teamBPlayers.Length];

        while (gameState == SeedGameStatesEnum.GAME_B_ATK_A_DFS)
        {
            if (playerCount < enteredPlayerCount)
                SetGameState(SeedGameStatesEnum.MATCHMAKING, "Go back to MATCHMAKING!");

            // Death revives
            for (int i = 0; i < teamPlayerCount; i++)
            {
                if (!bIsDeadTeamA[i])
                {
                    if (teamAPlayers[i].hp <= 0)
                    {
                        StartCoroutine(DeathTimer(teamAPlayers[i], defendersSpawnLocatorArray[i]));
                        bIsDeadTeamA[i] = true;
                    }
                }
                else if (teamAPlayers[i].hp > 0)
                    bIsDeadTeamA[i] = false;

                if (!bIsDeadTeamB[i])
                {
                    if (teamBPlayers[i].hp <= 0)
                    {
                        StartCoroutine(DeathTimer(teamBPlayers[i], attackersSpawnLocatorArray[i]));
                        bIsDeadTeamB[i] = true;
                    }
                }
                else if (teamBPlayers[i].hp > 0)
                    bIsDeadTeamB[i] = false;
            }

            GameUpdater();
            
            if (bMatchEnded)
                yield return StartCoroutine(CelebrationC());

            yield return null;
        }
    }

    private IEnumerator CelebrationC()
    {
        // Celebrate!
        foreach (var player in (winners == SeedersTeamStatus.TEAM_A) ? teamAPlayers : teamBPlayers)
        {
            player.bReadInput = false;
            player.CastCelebrate();
        }

        // Stun!
        foreach (var player in (winners == SeedersTeamStatus.TEAM_A) ? teamBPlayers : teamAPlayers)
        {
            player.bReadInput = false;
            player.CastMourn();
        }

        yield return new WaitForSeconds(6f);

        foreach (var player in playerList)
            player.bReadInput = true;

        if (match >= 4)
        {
            match = 0;
            SetGameState(SeedGameStatesEnum.GAME_RESULTS, "4 matches played. End game.");
        }
        else
            SetGameState(gameState == SeedGameStatesEnum.GAME_A_ATK_B_DFS ? SeedGameStatesEnum.GAME_B_ATK_A_DFS : SeedGameStatesEnum.GAME_A_ATK_B_DFS, "Switching side!");
    }

    IEnumerator DeathTimer(Server_PlayerEntity player, Transform spawnLoc)
    {
        float timer = 3f;
        while(timer > 0f)
        {
            timer -= Time.deltaTime;
            if (seedLife <= 0 || treeGrowth >= 100)
                yield break;

            yield return null;
        }

        // Revive
        player.SetIsDead(false);
        player.SetPositionAndRotation(spawnLoc.position, spawnLoc.rotation);
        player.ResetAttributes();
    }

    // Not the best design, but no time to waste.
    private float growthQueryTimer = 0f;
    private void GameUpdater()
    {
        if (seedLife <= 0)
        {
            EndMatch(GetDefenderTeam());
        }
        
        if (bSeedPlanted)
        {
            // Explosion!
            if (treeExplodeTimer > 0f)
                treeExplodeTimer -= Time.deltaTime;
            else
            {
                Server_PlayerEntity[] defenderTeam;
                if (GetDefenderTeam() == SeedersTeamStatus.TEAM_A)
                    defenderTeam = teamAPlayers;
                else
                    defenderTeam = teamBPlayers;
                foreach (Server_PlayerEntity p in defenderTeam)
                {
                     if (!p.IsDead && Vector3.Distance(p.transform.position, seedTr.position) < 2.5f)
                         p.TakeNeutralDamage((seedTr.position - p.transform.position).normalized, 180);
                }

                SendTreeExplode();
                
                treeExplodeTimer = 4f;
            }
            
            if (Time.time > growthQueryTimer)
            {
                treeGrowth = Mathf.RoundToInt(seedScript.growth);
                SendSeedState();
                growthQueryTimer = Time.time + 2f;
            }

            if (treeGrowth >= 100)
            {
                EndMatch(GetAttackerTeam());
            }
        }
        else
            matchTimerCountDown -= Time.deltaTime;
        
        if (matchTimerCountDown <= 0f)
        {
            EndMatch(GetDefenderTeam());
        }
    }

    private void ResetMatch()
    {
        winners = SeedersTeamStatus.NULL;
        bMatchEnded = false;
        seedLife = seedMaxLife;
        seedArmor = 0;
        treeGrowth = 0;
        seedEffect = SeedGrownEffectEnum.NONE;
        bSeedPlanted = false;
        seedTr.SetParent(null);
        seedScript.SetHeld(false);
        seedScript.Reset();
        matchTimerCountDown = matchTime;

        SendSeedState();

        for (int i = 0; i < teamAPlayers.Length; i++)
        {
            teamAPlayers[i].SetIsDead(false);
            if (gameState == SeedGameStatesEnum.GAME_A_ATK_B_DFS)
                teamAPlayers[i].SetPositionAndRotation(attackersSpawnLocatorArray[i].position, attackersSpawnLocatorArray[i].rotation);
            else
                teamAPlayers[i].SetPositionAndRotation(defendersSpawnLocatorArray[i].position, defendersSpawnLocatorArray[i].rotation);
            teamAPlayers[i].ResetAttributes();
        }
        for (int i = 0; i < teamBPlayers.Length; i++)
        {
            teamBPlayers[i].SetIsDead(false);
            if (gameState == SeedGameStatesEnum.GAME_A_ATK_B_DFS)
                teamBPlayers[i].SetPositionAndRotation(defendersSpawnLocatorArray[i].position, defendersSpawnLocatorArray[i].rotation);
            else
                teamBPlayers[i].SetPositionAndRotation(attackersSpawnLocatorArray[i].position, attackersSpawnLocatorArray[i].rotation);
            teamBPlayers[i].ResetAttributes();
        }
    }

    public SeedersTeamStatus GetAttackerTeam()
    {
        return (gameState == SeedGameStatesEnum.GAME_A_ATK_B_DFS) ? SeedersTeamStatus.TEAM_A : SeedersTeamStatus.TEAM_B;
    }
    public SeedersTeamStatus GetDefenderTeam()
    {
        return (gameState == SeedGameStatesEnum.GAME_B_ATK_A_DFS) ? SeedersTeamStatus.TEAM_A : SeedersTeamStatus.TEAM_B;
    }

    private void EndMatch(SeedersTeamStatus whoWon)
    {
        bMatchEnded = true;
        winners = whoWon;
        if (winners == GetAttackerTeam())
        {
            // TREE SCORE!
        }
        matchesWonByTeam[match] = whoWon;
        SendSeedState();

        match++;
    }

    private void ResetGameContribute()
    {
        for (int i = 0; i < playerList.Count; i++)
        {
            playerList[i].ResetGameContribute();
        }
    }

    private void ResetGame()
    {
        ResetMatch();
        ResetGameContribute();
    }

    IEnumerator GAME_RESULTS()
    {
        ResetGame();
        //bool bReplay = false;

        while (gameState == SeedGameStatesEnum.GAME_RESULTS)
        {
            yield return null;
        }
        /*
        if (bReplay)
        {

        }
        else
        {
            SetGameState(SeedGameStatesEnum.GAME_END, "Match ended");
        }
        */
    }

    IEnumerator GAME_END()
    {
        yield return null;
    }   

    public void PlayAgain()
    {
        SetGameState(SeedGameStatesEnum.MATCHMAKING, "Play again!");
    }
}
