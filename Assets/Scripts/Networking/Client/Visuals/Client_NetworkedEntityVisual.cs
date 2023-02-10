using UnityEngine;
using System;

public class Client_NetworkedEntityVisual : PoolableGameObject
{
    [NonSerialized]
    public Client_NetworkedEntity Owner;
    public VFXEnum vfxToSpawnOnDisable = VFXEnum.NULL;
    public Sounds sfxToSpanwOnDisable = Sounds.NULL;

    private void OnDisable()
    {
        if (GameInfos.Instance == null || GameInfos.Instance.activeGameManagerGameOfSeed == null || GameInfos.Instance.activeGameManagerGameOfSeed.audioManager == null)
            return;
        
        if (vfxToSpawnOnDisable != VFXEnum.NULL)
            GameInfos.Instance.activeGameManagerGameOfSeed.SpawnVFX(vfxToSpawnOnDisable, transform.position, Quaternion.identity);
        if (sfxToSpanwOnDisable != Sounds.NULL)
            GameInfos.Instance.activeGameManagerGameOfSeed.audioManager.PlaySound(sfxToSpanwOnDisable, 0.3f);
    }
}
