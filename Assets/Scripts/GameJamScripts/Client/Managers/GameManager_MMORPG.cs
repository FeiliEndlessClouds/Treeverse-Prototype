using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager_MMORPG : MonoBehaviour
{
    public AudioManager audioManager;
    [HideInInspector] public PlayerInputManager playerInputManager;
    [HideInInspector] public GUIManager guiManager;
    [HideInInspector] public CamManager camManager;
    
    public Client_NetworkManager client_NetworkManager;
    public Client_PlayerEntity localClient_PlayerEntity;
    
    private void Awake()
    {
        GameInfos.Instance.activeGameManagerMMORPG = this;
        playerInputManager = GetComponent<PlayerInputManager>();
        guiManager = GetComponent<GUIManager>();
        camManager = GetComponent<CamManager>();
    }
    
    public void LocalClientPlayerInstantiated(Client_PlayerEntity playerEntity)
    {
        localClient_PlayerEntity = playerEntity;
    }
    
    public void ClientPlayerInstantiated(Client_CharacterEntity player)
    {
        // for (int i = 0; i < playerNetworkIDArray.Length; i++)
        // {
        //     if (playerNetworkIDArray[i] == player.networkId)
        //     {
        //         // Reassign data, in case of time out
        //         if ((int)gameOfSeedState > (int)SeedGameStatesEnum.PREPARE_ARENA)
        //         {
        //             for (int j = 0; j < effectsJaggedArray.Length; j++)
        //                 SetEffectAt(player.networkId, j, effectsJaggedArray[i][j]);
        //             SetPlayerClass(player.networkId, playerClassesArray[i]);
        //         }
        //         break;
        //     }
        // }
    }

    public void UpdateVisual(VisualPrefabName visual, int networkId, float delay)
    {
        StartCoroutine(UpdateVisualC(visual, networkId, delay));
    }

    private IEnumerator UpdateVisualC(VisualPrefabName visual, int networkId, float delay)
    {
        yield return new WaitForSeconds(delay);
        Client_NetworkedEntity player = client_NetworkManager.GetEntityByNetworkID(networkId);
        SpawnVFX(VFXEnum.PixelHit, player.transform.position, Quaternion.identity);
        player.UpdateVisual(visual);
    }
    
    public GameObject SpawnVFX(VFXEnum vfxName, Vector3 pos, Quaternion rot)
    {
        return ObjectPoolManager.CreatePooled(GameInfos.Instance.staticGameData.fxGoArray[(int)vfxName], pos, rot);
    }
}
