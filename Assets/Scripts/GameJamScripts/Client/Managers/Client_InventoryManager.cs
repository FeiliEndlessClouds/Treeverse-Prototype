using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// For our GameJam game, inventory is used to set Class, and run effects.
public class Client_InventoryManager
{
    private bool[] activeEffects = new bool[(int)effectsEnum.COUNT];
    
    public void SetEffectIsActive(effectsEnum whichEffect, Client_CharacterEntity player, bool bEffectActive)
    {
        if (player)
        {
            if (bEffectActive)
                StartEffectVFX(player, whichEffect);
            else
                StopEffectVfxLoop(player, whichEffect);
        }
    }

    private void StartEffectVFX(Client_CharacterEntity player, effectsEnum effect)
    {
        switch (effect)
        {
            case effectsEnum.DAMAGE:
                GameInfos.Instance.activeGameManagerGameOfSeed.SpawnVFX(VFXEnum.Hit, player.transform);
                break;
            case effectsEnum.CONTINUOUSDAMAGE:
                GameInfos.Instance.activeGameManagerGameOfSeed.SpawnVFX(VFXEnum.Hit, player.transform)
                    .transform.localPosition = new Vector3(0f, 1.7f, 0f);
                break;
            case effectsEnum.HEAL:
                GameInfos.Instance.activeGameManagerGameOfSeed.SpawnVFX(VFXEnum.Heal, player.transform);
                break;
            case effectsEnum.CONTINUOUSHEAL:
                GameInfos.Instance.activeGameManagerGameOfSeed.SpawnVFX(VFXEnum.HealLoop, player.transform)
                    .transform.localPosition = new Vector3(0f, 1.7f, 0f);
                break;
            case effectsEnum.ARMORUP:
                GameInfos.Instance.activeGameManagerGameOfSeed.SpawnVFX(VFXEnum.ArmorUpLoop, player.transform);
                break;
            case effectsEnum.STUN:
                GameInfos.Instance.activeGameManagerGameOfSeed.SpawnVFX(VFXEnum.StunLoop, player.transform)
                    .transform.localPosition = new Vector3(0f, 1.7f, 0f);
                break;
            case effectsEnum.MANABURN:
                GameInfos.Instance.activeGameManagerGameOfSeed.SpawnVFX(VFXEnum.Hit, player.transform);
                break;
            case effectsEnum.FREEZE:
                GameInfos.Instance.activeGameManagerGameOfSeed.SpawnVFX(VFXEnum.Hit, player.transform);
                GameInfos.Instance.activeGameManagerGameOfSeed.SpawnVFX(VFXEnum.Emoji_Freeze, player.transform);
                GameInfos.Instance.activeGameManagerGameOfSeed.SpawnVFX(VFXEnum.VFX_Ice, player.transform);
                break;
            case effectsEnum.DANCE:
                GameInfos.Instance.activeGameManagerGameOfSeed.SpawnVFX(VFXEnum.Hit, player.transform);
                break;
            case effectsEnum.SILENT:
                GameInfos.Instance.activeGameManagerGameOfSeed.SpawnVFX(VFXEnum.Hit, player.transform);
                break;
            case effectsEnum.INVISIBLE:
                GameInfos.Instance.activeGameManagerGameOfSeed.SpawnVFX(VFXEnum.Hit, player.transform);
                break;
            case effectsEnum.SLOW:
                GameInfos.Instance.activeGameManagerGameOfSeed.SpawnVFX(VFXEnum.Hit, player.transform);
                break;
            case effectsEnum.DASH:
                GameInfos.Instance.activeGameManagerGameOfSeed.SpawnVFX(VFXEnum.Hit, player.transform);
                break;
            case effectsEnum.INVINCIBLE:
                GameInfos.Instance.activeGameManagerGameOfSeed.SpawnVFX(VFXEnum.Hit, player.transform);
                break;
            case effectsEnum.SEEDDROP:
                GameInfos.Instance.activeGameManagerGameOfSeed.SpawnVFX(VFXEnum.Hit, player.transform);
                break;
            case effectsEnum.KNOCKBACK:
                GameInfos.Instance.activeGameManagerGameOfSeed.SpawnVFX(VFXEnum.Hit, player.transform);
                break;
            case effectsEnum.MESSUP:
                GameInfos.Instance.activeGameManagerGameOfSeed.playerInputManager.isMessedUp = true;
                GameInfos.Instance.activeGameManagerGameOfSeed.SpawnVFX(VFXEnum.Emoji_Confused, player.transform);
                break;
        }
    }

    private void StopEffectVfxLoop(Client_CharacterEntity player, effectsEnum effect)
    {
        Debug.Log("StopEffect : " + effect);

        if (effect == effectsEnum.MESSUP)
            GameInfos.Instance.activeGameManagerGameOfSeed.playerInputManager.isMessedUp = false;

        // Only VFX without autoPool
        if (effect != effectsEnum.CONTINUOUSHEAL && effect != effectsEnum.CONTINUOUSDAMAGE &&
            effect != effectsEnum.STUN && effect != effectsEnum.FREEZE && effect != effectsEnum.ARMORUP)
            return;
        
        for (int i = 0; i < player.transform.childCount; i++)
        {
            Transform objTr = player.transform.GetChild(i);

            VFXEnum nameToCheck = VFXEnum.NULL;
            if (effect == effectsEnum.STUN)
                nameToCheck = VFXEnum.StunLoop;
            else if (effect == effectsEnum.CONTINUOUSHEAL)
                nameToCheck = VFXEnum.HealLoop;
            else if (effect == effectsEnum.ARMORUP)
                nameToCheck = VFXEnum.ArmorUpLoop;

            if (objTr.name.Contains(nameToCheck.ToString()))
            {
                Debug.Log("Stopped Effect : " + effect);
                ObjectPoolManager.DestroyPooled(objTr.gameObject);
            }
        }
    }
}
