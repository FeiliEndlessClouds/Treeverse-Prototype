using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// Workaround volatile nature of Client entity
public class ClientPlayerSpawnNotifier : MonoBehaviour
{
    private void Start()
    {
        GameInfos.Instance.activeGameManagerMMORPG.camManager.Init(transform);
    }
}
