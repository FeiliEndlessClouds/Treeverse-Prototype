using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager_MMORPG : MonoBehaviour
{
    public AudioManager audioManager;
    [HideInInspector] public PlayerInputManager playerInputManager;
    [HideInInspector] public GUIManager guiManager;
    [HideInInspector] public CamManager camManager;
    
    private void Awake()
    {
        GameInfos.Instance.activeGameManagerMMORPG = this;
        playerInputManager = GetComponent<PlayerInputManager>();
        guiManager = GetComponent<GUIManager>();
        camManager = GetComponent<CamManager>();
    }
}
