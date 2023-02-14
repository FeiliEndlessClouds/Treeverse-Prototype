using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum GameStatesEnum
{
    ROAMING,
    MINIGAME,
    DIALOG,
    COUNT,
    NULL
}

public class Server_RuleSet_MMORPG : MonoBehaviour
{
    public bool bActive;
    public bool bAutoGathering;

    public GameStatesEnum gameState;
    private GameStatesEnum previousGameState;
    
    public Server_NetworkManager serverNetworkManager;
    private List<Server_PlayerEntity> playerList = new List<Server_PlayerEntity>();
    private int playerCount;

    public GameObject actorPrefab;        // Corresponds with ActorTypesEnum
    public Server_ActorSpawner actorSpawner;
    private List<int[]> actorsCount;

    public void Initialize(Server_NetworkManager nm)
    {
        actorSpawner = new Server_ActorSpawner();
        actorSpawner.Init(this);
        actorsCount = new List<int[]>();
        serverNetworkManager = nm;
        StartCoroutine(FSM());
    }
    
    private void OnEnable()
    {
        Server_NetworkManager.OnPlayerConnected += Server_NetworkManager_OnPlayerConnected;
        Server_NetworkManager.OnPlayerDisconnected += Server_NetworkManager_OnPlayerDisconnected;
    }
    
    private void Server_NetworkManager_OnPlayerConnected(Server_PlayerEntity player)
    {
        playerCount++;
        player.bAutoGathering = bAutoGathering;
        playerList.Add(player);
        actorsCount.Add(new int[(int)CollectiblesEnum.COUNT]);
    }

    private void Server_NetworkManager_OnPlayerDisconnected(Server_PlayerEntity player)
    {
        playerCount--;
        for (int i = 0; i < playerList.Count; i++)
        {
            if (playerList[i].NetworkId == player.NetworkId)
            {
                playerList.RemoveAt(i);
                playerList.TrimExcess();
                actorsCount.RemoveAt(i);
                actorsCount.TrimExcess();
            }
        }
    }

    private void OnDisable()
    {
        Server_NetworkManager.OnPlayerConnected -= Server_NetworkManager_OnPlayerConnected;
        Server_NetworkManager.OnPlayerDisconnected -= Server_NetworkManager_OnPlayerDisconnected;
    }
    
    IEnumerator FSM()
    {
        SetGameState(GameStatesEnum.ROAMING, "Init RuleSet");

        while (bActive)
            yield return StartCoroutine(gameState.ToString());
    }
    
    private void SetGameState(GameStatesEnum newState, string reason)
    {
        previousGameState = gameState;
        gameState = newState;
        Debug.Log("<color=Lime>SERVER : </color>Leaving " + previousGameState.ToString() + ", going to  " + gameState.ToString() + ". Reason : " + reason);

        // All players receives the StateChange.
        SendGameState();
    }
    
    public void SendGameState()
    {
        if (playerList.Count == 0)
            return;
     
        for (int i = 0; i < playerList.Count; i++)
            playerList[i].SendGameState(this);
    }

    private IEnumerator ROAMING()
    {
        while (gameState == GameStatesEnum.ROAMING)
        {
            // Stream actors (collectible ground objects) with "structured randomness" around exploring players.
            for (int i = 0; i < playerList.Count; i++)
            {
                actorSpawner.PopulateAroundPlayer(playerList[i].transform, actorsCount[i], actorPrefab);
            }
            
            yield return null;
        }
    }
}
