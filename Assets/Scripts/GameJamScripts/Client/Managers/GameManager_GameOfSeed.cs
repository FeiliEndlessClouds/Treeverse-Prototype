// using System.Collections;
// using System.Collections.Generic;
// using System.Numerics;
// using TMPro;
// using UnityEngine;
// using UnityEngine.UI;
// using Quaternion = UnityEngine.Quaternion;
// using Vector3 = UnityEngine.Vector3;
//
// public enum GameStates
// {
// 	JUSTLOADED,
//     INMENUS,
// 	PLAYING,
//     CHANGINGSCENE
// }
//
// public class GameManager_GameOfSeed : MonoBehaviour
// {
//     public delegate void GameManagerReadyAction(GameManager_GameOfSeed gameManagerGameOfSeed);
//     public static event GameManagerReadyAction OnGameManagerInit;
//     public static event GameManagerReadyAction OnGameReady;
//
//     public delegate void GameManagerSeedAction(int networkID);
//     public static event GameManagerSeedAction OnSeedHolderChange;
//
//     public Client_NetworkManager client_NetworkManager;
//
//     // Client side only
//     //public string buildNumber = "0.1";
//     public GameStates gameState = GameStates.JUSTLOADED;
//
//     // Data Server sends to all Clients
//     public SeedGameStatesEnum gameOfSeedState = SeedGameStatesEnum.NULL;
//
//     public AnimationCurve sCurve;
//     public AnimationCurve uCurve;
//
//     public GameObject logTemplate;
//     public Transform logTextsRootTr;
//     private int logTxtCount = 0;
//
//     private bool bLogMuteX = false;
//
//     public AudioManager audioManager;
//     [HideInInspector] public PlayerInputManager playerInputManager;
//     [HideInInspector] public GUIManager guiManager;
//     [HideInInspector] public BotCommandManager botCommandManager;
//     [HideInInspector] public CamManager camManager;
//     private GameOfSeed_UIManager gameOfSeed_UIManager;
//
//     // Never assume the entities's existence. Query Entities via NetworkManager instead.
//     // Those data are updated by Client_NetworkManager only
//     public int playerCount;
//     public int localPlayerNetworkID;
//     public SeedersTeamStatus localPlayerTeam;
//     public int[] playerNetworkIDArray;
//     public string[] playersNameArray;
//     public SeedersTeamStatus[] playersTeamStatusArray;
//     private effectsEnum[][] effectsJaggedArray;
//     private Client_InventoryManager client_inventoryManager = new Client_InventoryManager();
//     private SeedGameClassesEnum[] playerClassesArray;
//
//     public Client_PlayerEntity localClient_PlayerEntity;
//     public SeedGameClassesEnum playerActiveClass = SeedGameClassesEnum.NULL;
//     public int seedHolderID;
//
//     public GameObject[] allVisualPrefabs;
//     public Sprite[] classIcons;
//
//     private Queue<string> messageQueue = new Queue<string>();
//
//     public Client_NetworkedEntity seedEntity;
//     public SkinnedMeshRenderer seedSkinnedMeshR;
//     private int maxSeedLife = 0;
//     public int seedLife = 100;
//     public float seedGrowth = 0f;
//     private float blendEnd = 0f;
//
//     private int prevTeamAScore;
//     public int teamAScore;
//     private int prevTeamBScore;
//     public int teamBScore;
//
//     public TMP_Text seedTreeHPTxt;
//     public Slider seedTreeHpSlider;
//     public Slider seedTreeGrowthSlider;
//
//     public float matchTimerCountDown;
//     public bool bTreePlanted;
//
//     private void Awake()
//     {
//         GameInfos.Instance.activeGameManagerGameOfSeed = this;
//         playerInputManager = GetComponent<PlayerInputManager>();
//         guiManager = GetComponent<GUIManager>();
//         botCommandManager = GetComponent<BotCommandManager>();
//         gameOfSeed_UIManager = GetComponent<GameOfSeed_UIManager>();
//         gameOfSeed_UIManager.Init(this);
//         camManager = GetComponent<CamManager>();
//
//         // PreInit All
//         playersTeamStatusArray = new SeedersTeamStatus[6];
//         for (int i = 0; i < playersTeamStatusArray.Length; i++)
//             playersTeamStatusArray[i] = SeedersTeamStatus.NULL;
//         effectsJaggedArray = new effectsEnum[6][];
//         for (int i = 0; i < effectsJaggedArray.Length; i++)
//             effectsJaggedArray[i] = new effectsEnum[10];
//         playerClassesArray = new SeedGameClassesEnum[6];
//     }
//
//     public SeedersTeamStatus GetTeamFromNetworkId(int playerNetworkId)
//     {
//         for (int i = 0; i < playerNetworkIDArray.Length; i++)
//         {
//             if (playerNetworkIDArray[i] == playerNetworkId)
//                 return playersTeamStatusArray[i];
//         }
//
//         return SeedersTeamStatus.NULL;
//     }
//
//     private void Update()
//     {
//         //if (Input.GetKeyUp(KeyCode.Return))
//             //SendChatInputToServer(string.Empty);
//         if (Input.GetKeyUp(KeyCode.Alpha0))
//         {
//             QualitySettings.vSyncCount = (QualitySettings.vSyncCount + 1) % 5;
//             DisplayLog("VSync changed value to : " + QualitySettings.vSyncCount);
//         }
//
//         if (seedSkinnedMeshR)
//         {
//             seedGrowth = Mathf.Lerp(seedGrowth, blendEnd, Time.deltaTime);
//             seedSkinnedMeshR.SetBlendShapeWeight(0, seedGrowth);
//             seedTreeGrowthSlider.value = seedGrowth;
//         }
//         else
//             seedTreeGrowthSlider.value = 0f;
//
//         if (!bTreePlanted)
//         {
//             matchTimerCountDown -= Time.deltaTime;
//         }
//     }
//
//     public void SetEffectAt(int networkId, int slotIdx, effectsEnum effect)
//     {
//         Debug.Log("<color=yellow>CLIENT : </color>Setting item : " + effect.ToString()+ " to networkID entity : " + networkId + " in slot : " + slotIdx);
//         for (int i = 0; i < playerNetworkIDArray.Length; i++)
//         {
//             if (networkId == playerNetworkIDArray[i])
//             {
//                 Client_CharacterEntity player = client_NetworkManager.GetCharacterEntityByNetworkID(networkId);
//                 if (player != null)
//                 {
//                     if (effect != effectsEnum.NULL)
//                         client_inventoryManager.SetEffectIsActive(effect, player, true);
//                     else
//                         client_inventoryManager.SetEffectIsActive(effectsJaggedArray[i][slotIdx], player, false);
//                 }
//                 effectsJaggedArray[i][slotIdx] = effect;
//                 
//                 if (networkId == localPlayerNetworkID)
//                 {
//                     // Display on HUD
//                     // if (effect == effectsEnum.NULL)
//                     //     guiManager.ClearIconAtIndex(slotIdx);
//                     // else
//                     //     guiManager.UpdateIconAtIndex(slotIdx, GameInfos.Instance.staticGameData.effectSprites[(int)effect]);
//                 }
//
//                 break;
//             }
//         }
//     }
//
//     void Start()
//     {
//         //DisplayLog("<color=red>Deployement number : " + buildNumber + "</color>");
//         StartCoroutine(InitializeGame());
//     }
//
//     public void TreeExplode()
//     {
//         SpawnVFX(VFXEnum.BigBoom, seedEntity.transform.position, Quaternion.identity);
//         audioManager.PlaySound(Sounds.TreeExplode);
//     }
//
//     private int match = 0;
//     private SeedersTeamStatus[] matchesWonByTeam = new SeedersTeamStatus[4];
//
//     private void RefreshScore()
//     {
//         audioManager.PlaySound(Sounds.MatchEnd);
//         guiManager.SetRound(match);
//         for (int i = 0; i < matchesWonByTeam.Length; i++)
//         {
//             Color color = Color.gray;
//             if (matchesWonByTeam[i] == SeedersTeamStatus.TEAM_A) color = Color.red;
//             if (matchesWonByTeam[i] == SeedersTeamStatus.TEAM_B) color = Color.blue;
//             guiManager.SetRoundColor(i, color);
//         }
//         
//         GameInfos.Instance.activeGameManagerGameOfSeed.guiManager.SetWinMessage(SeedersTeamStatus.NULL);
//     }
//     
//     public void RefreshData(SeedGameStatesEnum seedState, int entryCount, int[] playersIDs, 
//         SeedersTeamStatus[] playersTeamStatus, int round, SeedersTeamStatus[] matchesWonByTeamT)
//     {
//         match = round;
//         for (int i = 0; i < matchesWonByTeam.Length; i++)
//             matchesWonByTeam[i] = matchesWonByTeamT[i];
//
//         gameOfSeedState = seedState;
//         playerCount = entryCount;
//         playerNetworkIDArray = new int[playersIDs.Length];
//         for (int i = 0; i < playerNetworkIDArray.Length; i++)
//             playerNetworkIDArray[i] = playersIDs[i];
//
//         playersTeamStatusArray = new SeedersTeamStatus[playersTeamStatus.Length];
//         for (int i = 0; i < playersTeamStatusArray.Length; i++)
//             playersTeamStatusArray[i] = playersTeamStatus[i];
//
//         // Assign Local team
//         for (int i = 0; i < playerNetworkIDArray.Length; i++)
//         {
//             if (localPlayerNetworkID == playerNetworkIDArray[i])
//             {
//                 localPlayerTeam = playersTeamStatusArray[i];
//                 break;
//             }
//         }
//
//         // Can't join during game so should be safe
//         if (playerClassesArray == null || playerClassesArray.Length != playerCount)
//             playerClassesArray = new SeedGameClassesEnum[playerCount];
//
//         RefreshPlayerCount();
//     }
//
//     public bool IsPlayerSeedHolder()
//     {
//         return localClient_PlayerEntity.networkId == seedHolderID;
//     }
//
//     public void LocalClientPlayerInstantiated(Client_PlayerEntity playerEntity)
//     {
//         localClient_PlayerEntity = playerEntity;
//         localPlayerNetworkID = playerEntity.networkId;
//
//         // Game of Seed inactive
//         if (gameOfSeedState == SeedGameStatesEnum.NULL && playerNetworkIDArray.Length < 1)
//         {
//             playerNetworkIDArray = new int[6];
//             playerNetworkIDArray[0] = playerEntity.networkId;
//         }
//
//         RefreshPlayerCount();
//     }
//
//     public void ClientPlayerInstantiated(Client_CharacterEntity player)
//     {
//         if ((int)gameOfSeedState < (int)SeedGameStatesEnum.SELECT_CLASS)
//             return;
//
//         for (int i = 0; i < playerNetworkIDArray.Length; i++)
//         {
//             if (playerNetworkIDArray[i] == player.networkId)
//             {
//                 // Reassign data, in case of time out
//                 if ((int)gameOfSeedState > (int)SeedGameStatesEnum.PREPARE_ARENA)
//                 {
//                     //player.teamStatus = playersTeamStatusArray[i];
//                     for (int j = 0; j < effectsJaggedArray.Length; j++)
//                         SetEffectAt(player.networkId, j, effectsJaggedArray[i][j]);
//                     SetPlayerClass(player.networkId, playerClassesArray[i]);
//                 }
//                 break;
//             }
//         }
//     }
//
//     public void PropsInstantiated(Client_NetworkedEntity prop)
//     {
//         if (prop.VisualRef == VisualPrefabName.SeedVisual || prop.VisualRef == VisualPrefabName.TreeMorphableVisual)
//             seedEntity = prop;
//     }
//
//     private void RefreshPlayerCount()
//     {
//         gameOfSeed_UIManager.teamABlock.text = "Team A\n";
//         gameOfSeed_UIManager.teamBBlock.text = "Team B\n";
//
//         for (int i = 0; i < 6; i++)
//         {
//             if (i < playersTeamStatusArray.Length && playersTeamStatusArray[i] == SeedersTeamStatus.TEAM_A)
//             {
//                 string playenName = string.IsNullOrWhiteSpace(playersNameArray[i]) ? ("Player " + playerNetworkIDArray[i]) : playersNameArray[i].Trim();
//                 gameOfSeed_UIManager.teamABlock.text += (playerNetworkIDArray[i] == localPlayerNetworkID ? "*" : "") + playenName + "\n";
//             }
//             else if (i < playersTeamStatusArray.Length && playersTeamStatusArray[i] == SeedersTeamStatus.TEAM_B)
//             {
//                 string playenName = string.IsNullOrWhiteSpace(playersNameArray[i]) ? ("Player " + playerNetworkIDArray[i]) : playersNameArray[i].Trim();
//                 gameOfSeed_UIManager.teamBBlock.text += (playerNetworkIDArray[i] == localPlayerNetworkID ? "*" : "") + playenName + "\n";
//             }
//         }
//     }
//
//     public void SetPlayerClass(int networkID, SeedGameClassesEnum whichClass)
//     {
//         Debug.Log("<color=yellow>CLIENT : </color>Setting class : " + whichClass.ToString() + " to networkID entity : " + networkID);
//
//         if (networkID == localClient_PlayerEntity.networkId)
//         {
//             playerActiveClass = whichClass;
//             //guiManager.UpdateIconAtIndex(0, classIcons[(int)playerActiveClass]);
//             GameInfos.Instance.staticGameData.SetAbilitiesIconAndCoolDownTimers(whichClass);
//         }
//         
//         for (int i = 0; i < playerNetworkIDArray.Length; i++)
//         {
//             if (networkID == playerNetworkIDArray[i])
//             {
//                 playerClassesArray[i] = whichClass;
//                 Client_CharacterEntity player = client_NetworkManager.GetCharacterEntityByNetworkID(networkID);
//                 if (player != null)
//                 {
//                     int converter = (int)whichClass + 1;
//                     Debug.Log(whichClass.ToString() + " converted to enum number : " + converter +
//                         " which turns into VisualPrefabName : " + ((VisualPrefabName)converter).ToString());
//                     player.VisualRef = (VisualPrefabName)converter;
//                     player.UpdateVisual();
//                     
//                     player.ResetMaxStats();
//                     
//                     return;
//                 }
//                 break;
//             }
//         }
//         Debug.Log("<color=yellow>CLIENT : </color>Couldn't find PlayerEntity with to networkID : " + networkID + ". Possible Time out?");
//     }
//
//     public bool WeAreAttackers()
//     {
//         if (localPlayerTeam == SeedersTeamStatus.TEAM_A && gameOfSeedState == SeedGameStatesEnum.GAME_A_ATK_B_DFS)
//             return true;
//         if (localPlayerTeam == SeedersTeamStatus.TEAM_B && gameOfSeedState == SeedGameStatesEnum.GAME_B_ATK_A_DFS)
//             return true;
//
//         return false;
//     }
//
//     private bool bTreeScore = false;
//     public void UpdateSeedHolder(int networkID, int seedHP, int growth)
//     {
//         if (maxSeedLife < seedHP)
//         {
//             maxSeedLife = seedHP;
//             seedTreeHpSlider.maxValue = seedHP;
//         }
//
//         // Seed Planted!
//         if (networkID == -2)
//         {
//             bTreePlanted = true;
//             if (seedEntity && seedEntity.VisualRef != VisualPrefabName.TreeMorphableVisual)
//             {
//                 Vector3 pos = new Vector3(seedEntity.transform.position.x, 0f, seedEntity.transform.position.z);
//                 SpawnVFX(VFXEnum.BigBoom, pos, Quaternion.identity);
//                 audioManager.PlaySound(WeAreAttackers() ? Sounds.TreePlanted_Attackers : Sounds.TreePlanted_Defenders, 0.7f);
//
//                 seedEntity.VisualRef = VisualPrefabName.TreeMorphableVisual;
//                 seedEntity.UpdateVisual();
//             }
//
//             // TreeScore
//             if (!bTreeScore && growth >= 100)
//             {
//                 SpawnVFX(VFXEnum.BigBoom, seedEntity.transform.position, Quaternion.identity);
//                 audioManager.PlaySound(Sounds.TreeScore, 0.7f);
//                 camManager.ShakeCam(0.3f);
//                 bTreeScore = true;
//             }
//
//             if (growth > seedTreeGrowthSlider.maxValue)
//                 seedTreeGrowthSlider.maxValue = growth;
//             
//             blendEnd = growth;
//         }
//         else
//         {
//             bTreePlanted = false;
//             seedGrowth = 0f;
//             if (seedEntity && seedEntity.VisualRef != VisualPrefabName.SeedVisual)
//             {
//                 seedEntity.VisualRef = VisualPrefabName.SeedVisual;
//                 seedEntity.UpdateVisual();
//             }
//
//             if (!bTreeScore && seedLife <= 0)
//             {
//                 SpawnVFX(VFXEnum.BigBoom, seedEntity.transform.position, Quaternion.identity);
//                 audioManager.PlaySound(Sounds.TreeScore, 0.7f);
//                 camManager.ShakeCam(0.3f);
//                 bTreeScore = true;
//             }
//         }
//
//         if (seedLife != seedHP)
//         {
//             seedTreeHPTxt.text = seedHP.ToString() + " / " + maxSeedLife.ToString();
//             seedTreeHpSlider.value = seedHP;
//             
//             if (seedLife > seedHP)
//             {
//                 camManager.ShakeCam(0.2f);
//                 audioManager.PlaySound(Sounds.SeedHit, 1f, true);
//             }
//         }
//
//         seedLife = seedHP;
//
//         seedHolderID = networkID;
//         OnSeedHolderChange?.Invoke(networkID);
//     }
//
//     public void UpdateRuleSetData(SeedGameStatesEnum seedState, int entryCount, int[] playersIDs, string[] playerNames,
//         SeedersTeamStatus[] playersTeamStatus, int round, SeedersTeamStatus[] matchesWonByTeam, List<GameContributeModel> gameContributes)
//     {
//         bool bSeedStateChange = (seedState != gameOfSeedState);
//         playersNameArray = playerNames;
//         RefreshData(seedState, entryCount, playersIDs, playersTeamStatus, round, matchesWonByTeam);
//         
//         if (!bSeedStateChange)
//         {
//             Debug.Log("<color=yellow>CLIENT : </color>SeedGameState is already : " + gameOfSeedState.ToString());
//             return;
//         }
//
//         if (gameOfSeedState == SeedGameStatesEnum.MATCHMAKING)
//         {
//             audioManager.StartMusic(MusicNames.BGM_SkyRuin_ResultScreen, false, true);
//             playerInputManager.bIsActive = false;
//             gameOfSeed_UIManager.HideAllMenus();
//             RefreshScore();
//             StartCoroutine(gameOfSeed_UIManager.DisplayMenuC(SeedGameStatesEnum.MATCHMAKING));
//         }
//         else if (gameOfSeedState == SeedGameStatesEnum.SELECT_CLASS)
//         {
//             StartCoroutine(gameOfSeed_UIManager.SwitchMenuC(SeedGameStatesEnum.MATCHMAKING, SeedGameStatesEnum.SELECT_CLASS));
//
//             //guiManager.ClearInventoryGUI();
//         }
//         else if (gameOfSeedState == SeedGameStatesEnum.PREPARE_ARENA)
//         {
//             StartCoroutine(gameOfSeed_UIManager.SwitchMenuC(SeedGameStatesEnum.SELECT_CLASS, SeedGameStatesEnum.PREPARE_ARENA));
//             playerInputManager.bIsActive = false;
//         }
//         else if (gameOfSeedState == SeedGameStatesEnum.GAME_A_ATK_B_DFS)
//         {
//             bTreeScore = false;
//             RefreshScore();
//             audioManager.StartMusic(MusicNames.BGM_Boss_Skeleton, false, true);
//             audioManager.PlaySound(Sounds.SwitchSide, 0.7f);
//             playerInputManager.bIsActive = true;
//             gameOfSeed_UIManager.HideAllMenus();
//             camManager.SetCamState(CamStatesEnum.FOLLOWPLAYER);
//             camManager.SetCamSide(localPlayerTeam == SeedersTeamStatus.TEAM_A);
//             StartCoroutine(gameOfSeed_UIManager.DisplayMenuC((localPlayerTeam == SeedersTeamStatus.TEAM_A) ? SeedGameStatesEnum.GAME_A_ATK_B_DFS : SeedGameStatesEnum.GAME_B_ATK_A_DFS));
//             if (seedEntity)
//             {
//                 seedEntity.VisualRef = VisualPrefabName.SeedVisual;
//                 seedEntity.UpdateVisual();
//             }
//
//             SpawnVFX(VFXEnum.Emoji_GameStart, localClient_PlayerEntity.transform);
//             matchTimerCountDown = 60f;
//         }
//         else if (gameOfSeedState == SeedGameStatesEnum.GAME_B_ATK_A_DFS)
//         {
//             bTreeScore = false;
//             RefreshScore();
//             audioManager.StartMusic(MusicNames.BGM_Situation_Defense, false, true);
//             audioManager.PlaySound(Sounds.SwitchSide, 0.7f);
//             playerInputManager.bIsActive = true;
//             gameOfSeed_UIManager.HideAllMenus();
//             camManager.SetCamState(CamStatesEnum.FOLLOWPLAYER);
//             camManager.SetCamSide(localPlayerTeam == SeedersTeamStatus.TEAM_B);
//             StartCoroutine(gameOfSeed_UIManager.DisplayMenuC((localPlayerTeam == SeedersTeamStatus.TEAM_A) ? SeedGameStatesEnum.GAME_B_ATK_A_DFS : SeedGameStatesEnum.GAME_A_ATK_B_DFS));
//             if (seedEntity)
//             {
//                 seedEntity.VisualRef = VisualPrefabName.SeedVisual;
//                 seedEntity.UpdateVisual();
//             }
//             
//             SpawnVFX(VFXEnum.Emoji_GameStart, localClient_PlayerEntity.transform);
//             matchTimerCountDown = 60f;
//         }
//         else if (gameOfSeedState == SeedGameStatesEnum.GAME_RESULTS)
//         {
//             bool bWon = false;
//             int wonTime = 0;
//             for (int i = 0; i < matchesWonByTeam.Length; i++)
//             {
//                 if (matchesWonByTeam[i] == localPlayerTeam)
//                     wonTime++;
//             }
//             if (wonTime >= matchesWonByTeam.Length / 2)
//                 bWon = true;
//             guiManager.SetEndMatchImage(bWon);
//             camManager.SetCamState(CamStatesEnum.FOLLOWPLAYER);
//             audioManager.StartMusic(MusicNames.EndResultMusic, false, true);
//             gameOfSeed_UIManager.HideAllMenus();
//             gameOfSeed_UIManager.RefreshResultTxt(gameContributes);
//             StartCoroutine(gameOfSeed_UIManager.DisplayMenuC(SeedGameStatesEnum.GAME_RESULTS));
//         }
//         else if (gameOfSeedState == SeedGameStatesEnum.GAME_END)
//         {
//         }
//
//         DisplayLog("Game of Seed new phase : " + gameOfSeedState.ToString());
//     }
//
//     public void ClassChosen(int whichClass)
//     {
//         Debug.Log("<color=yellow>Client</color> UI button clicked on : " + playerActiveClass.ToString());
//         client_NetworkManager.BeginReliablePacket();
//         client_NetworkManager.ReliableBuffer.Put(PacketType.Client_SetPlayerClass);
//         client_NetworkManager.ReliableBuffer.Put((ushort)whichClass);
//         client_NetworkManager.FlushBuffers(ref client_NetworkManager.ReliableBuffer);
//
//         StartCoroutine(gameOfSeed_UIManager.HideMenuC(SeedGameStatesEnum.SELECT_CLASS));
//     }
//
//     public void DisplayLog(string logTxt)
//     {
//         audioManager.PlaySound(Sounds.NewLogEntry);
//         Debug.Log("<color=yellow>CLIENT : </color>New Log entry : " + logTxt);
//         StartCoroutine(LogFadeOut(logTxt));
//     }
//
//     IEnumerator LogFadeOut(string logTxt)
//     {
//         if (bLogMuteX)
//             yield return null;
//         bLogMuteX = true;
//         yield return null;
//         bLogMuteX = false;
//
//         GameObject go = ObjectPoolManager.CreatePooled(logTemplate, logTemplate.transform.position, logTemplate.transform.rotation);
//         go.transform.SetParent(logTextsRootTr);
//         go.SetActive(true);
//         go.transform.localPosition = new Vector3(0, 0, 0);
//         go.transform.localScale = Vector3.one;
//
//         Text txt = go.GetComponent<Text>();
//
//         logTxtCount++;
//         //Debug.Log(logTxt + logTxtCount.ToString());
//         int logTxtCountOrig = logTxtCount;
//         txt.text = logTxt;
//         txt.CrossFadeAlpha(1f, 0.1f, false);
//         float timer = 3f;
//         while (timer > 0f)
//         {
//             timer -= Time.deltaTime;
//             if (logTxtCountOrig < logTxtCount)
//             {
//                 txt.transform.localPosition -= new Vector3(0, 25, 0);
//                 logTxtCountOrig = logTxtCount;
//             }
//             yield return null;
//         }
//         txt.CrossFadeAlpha(0f, 1f, false);
//         while (txt.canvasRenderer.GetAlpha() > 0f)
//         {
//             if (logTxtCountOrig < logTxtCount)
//             {
//                 txt.transform.localPosition -= new Vector3(0, 25, 0);
//                 logTxtCountOrig = logTxtCount;
//             }
//             yield return null;
//         }
//         ObjectPoolManager.DestroyPooled(txt.gameObject);
//     }
//
//     public void SetGameState(GameStates value, string reason)
//     {
//         gameState = value;
//         Debug.Log("<color=yellow>CLIENT : </color>GameManager gameState is now : " + value.ToString() + ". Reason : " + reason);
//     }
//     
//     void OnEnable()
//     {
//         PlayerCollector.OnPlayerCollect += PlayerCollector_OnPlayerCollect;
//         PlayerCollector.OnPlayerCollectStart += PlayerCollector_OnPlayerCollectStart;
//     }
//     
//     void PlayerCollector_OnPlayerCollectStart(CollectibleGeneric collectibleScript, Transform objectTr)
//     {
//         //GameInfos.Instance.audioManager.PlaySound(Sounds.CollectImpact);
//     }
//
//
//     void PlayerCollector_OnPlayerCollect(CollectibleGeneric collectibleScript, Transform parentTr)
//     {
//         //GameInfos.Instance.audioManager.PlaySound(Sounds.Collect, true);
//         DisplayLog("Collected : " + collectibleScript.collectibleType);
//     }
//
//     void OnDisable()
//     {
//         PlayerCollector.OnPlayerCollect -= PlayerCollector_OnPlayerCollect;
//         PlayerCollector.OnPlayerCollectStart -= PlayerCollector_OnPlayerCollectStart;
//     }
//
//     IEnumerator InitializeGame()
//     {
//         SetGameState(GameStates.JUSTLOADED, "Initializing Game Manager.");
//
//         OnGameManagerInit?.Invoke(this);
//
//         // --- LOADING GAME FROM SAVE --- //
//
//         yield return null;
//
//         SetGameState(GameStates.INMENUS, "GameManager initialization complete");
//         if (OnGameReady != null)
// 			OnGameReady(this);
//     }
//
//     public GameObject SpawnVFX(VFXEnum vfxName, Transform parent)
//     {
//         GameObject go = ObjectPoolManager.CreatePooled(GameInfos.Instance.staticGameData.fxGoArray[(int)vfxName], parent.position, parent.rotation);
//         go.transform.SetParent(parent);
//
//         if (vfxName.ToString().Contains("Emoji"))
//             go.transform.position += Vector3.up * 1.5f + Camera.main.transform.right * 1.5f;
//         
//         return go;
//     }
//
//     public GameObject SpawnVFX(VFXEnum vfxName, Vector3 pos, Quaternion rot)
//     {
// 		return ObjectPoolManager.CreatePooled(GameInfos.Instance.staticGameData.fxGoArray[(int)vfxName], pos, rot);
//     }
//
//     public void SendChatInputToServer(string param)
//     {
//         if (string.IsNullOrEmpty(gameOfSeed_UIManager.chatInput.text))
//             return;
//
//         Debug.Log("<color=yellow>CLIENT : </color>Send Message to server : " + localPlayerNetworkID);
//
//         client_NetworkManager.BeginReliablePacket();
//         client_NetworkManager.ReliableBuffer.Put(PacketType.Client_SendMessage);
//         client_NetworkManager.ReliableBuffer.Put((ushort)localPlayerNetworkID);
//         client_NetworkManager.ReliableBuffer.Put(gameOfSeed_UIManager.chatInput.text);
//         client_NetworkManager.FlushBuffers(ref client_NetworkManager.ReliableBuffer);
//
//         gameOfSeed_UIManager.chatInput.text = string.Empty;
//     }
//
//     public void RefreshChatBoard(ref ByteBuffer buffer)
//     {
//         int networkID = buffer.GetUShort();
//         string message = buffer.GetString();
//
//         Debug.Log("<color=yellow>CLIENT : </color>Setting message : " + message + " from networkID entity : " + networkID + " to chat.");
//
//         string playerName = string.Empty;
//         for (int i = 0; i < playerNetworkIDArray.Length; i++)
//         {
//             if (playerNetworkIDArray[i] == networkID && !string.IsNullOrEmpty(playersNameArray[i]))
//             {
//                 playerName = playersNameArray[i].Trim();
//                 break;
//             }
//         }
//         if (string.IsNullOrEmpty(playerName))
//             playerName = networkID.ToString();
//
//         messageQueue.Enqueue($"[{playerName}]:{message}\n");
//         if (messageQueue.Count > 3)
//             messageQueue.Dequeue();
//
//         string chatMessages = string.Empty;
//         foreach (string s in messageQueue)
//         {
//             chatMessages += s;
//         }
//
//         gameOfSeed_UIManager.chatBoard.text = chatMessages;
//     }
//
//     public void SwitchTeam()
//     {
//         Debug.Log("Switch Team");
//
//         client_NetworkManager.BeginReliablePacket();
//         client_NetworkManager.ReliableBuffer.Put(PacketType.Client_SwitchTeam);
//         client_NetworkManager.ReliableBuffer.Put((ushort)localPlayerNetworkID);
//         client_NetworkManager.FlushBuffers(ref client_NetworkManager.ReliableBuffer);
//     }
//
//     public void Fight()
//     {
//         Debug.Log("Fight!");
//
//         client_NetworkManager.BeginReliablePacket();
//         client_NetworkManager.ReliableBuffer.Put(PacketType.Client_Fight);
//         client_NetworkManager.FlushBuffers(ref client_NetworkManager.ReliableBuffer);
//     }
//
//     public void HideFightBtn()
//     {
//         gameOfSeed_UIManager.HideFightBtn();
//     }
//
//     public void ShowFightBtn()
//     {
//         gameOfSeed_UIManager.ShowFightBtn();
//     }
//
//     public void PlayAgain()
//     {
//         client_NetworkManager.BeginReliablePacket();
//         client_NetworkManager.ReliableBuffer.Put(PacketType.Client_PlayAgain);
//         client_NetworkManager.FlushBuffers(ref client_NetworkManager.ReliableBuffer);
//     }
//
//     public void ExitGame()
//     {
//         Debug.Log("Quit Game");
//
//         #if UNITY_EDITOR
//         UnityEditor.EditorApplication.isPlaying = false;       
//         #else
//         Application.Quit();
//         #endif
//     }
// }
