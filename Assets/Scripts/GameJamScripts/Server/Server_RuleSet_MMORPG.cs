using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Server_RuleSet_MMORPG : MonoBehaviour
{
    private Server_NetworkManager _serverNetworkManager;

    public void Initialize(Server_NetworkManager nm)
    {
        _serverNetworkManager = nm;
    }
    
    private void OnEnable()
    {
        Server_NetworkManager.OnPlayerConnected += Server_NetworkManager_OnPlayerConnected;
        Server_NetworkManager.OnPlayerDisconnected += Server_NetworkManager_OnPlayerDisconnected;
    }
    
    private void Server_NetworkManager_OnPlayerConnected(Server_PlayerEntity player)
    {
        
    }

    private void Server_NetworkManager_OnPlayerDisconnected(Server_PlayerEntity player)
    {
        
    }

    private void OnDisable()
    {
        Server_NetworkManager.OnPlayerConnected -= Server_NetworkManager_OnPlayerConnected;
        Server_NetworkManager.OnPlayerDisconnected -= Server_NetworkManager_OnPlayerDisconnected;
    }
    
    
}
