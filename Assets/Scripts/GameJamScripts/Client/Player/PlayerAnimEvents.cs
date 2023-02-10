using System.Collections;
using System.Collections.Generic;
using System.Xml.Linq;
using UnityEngine;
using System;

public class PlayerAnimEvents : MonoBehaviour
{
    public Client_CharacterEntityVisual entityVisual;

    public void BowShot()
    {
        GameInfos.Instance.activeGameManagerGameOfSeed.audioManager.PlaySound(Sounds.BowShot, 0.3f, true);
        GameInfos.Instance.activeGameManagerGameOfSeed.SpawnVFX(entityVisual.whichTeamAmI() == SeedersTeamStatus.TEAM_A ? VFXEnum.ClassicAttack_Red : VFXEnum.ClassicAttack_Blue,
            transform.position, transform.rotation);
    }

    public void BladeSwing()
    {
        GameInfos.Instance.activeGameManagerGameOfSeed.audioManager.PlaySound(Sounds.BladeSwing, 0.3f, true);
        GameInfos.Instance.activeGameManagerGameOfSeed.SpawnVFX(entityVisual.whichTeamAmI() == SeedersTeamStatus.TEAM_A ? VFXEnum.ClassicAttack_Red : VFXEnum.ClassicAttack_Blue, 
            transform.position, transform.rotation);
    }

    public void TurnInvisible()
    {
        GameInfos.Instance.activeGameManagerGameOfSeed.audioManager.PlaySound(Sounds.TurnInvisible, 0.3f, false);
        GameInfos.Instance.activeGameManagerGameOfSeed.SpawnVFX(VFXEnum.ClassicAttack_Blue, transform.position, transform.rotation);
    }

    public void SpawnArmorFX()
    {
        GameInfos.Instance.activeGameManagerGameOfSeed.audioManager.PlaySound(Sounds.ArmorUp, 0.3f, false);
    }

    public void SpawnHealFX()
    {
        GameInfos.Instance.activeGameManagerGameOfSeed.audioManager.PlaySound(Sounds.Heal, 0.3f, false);
        GameInfos.Instance.activeGameManagerGameOfSeed.SpawnVFX(VFXEnum.Heal, transform.position + Vector3.up, Quaternion.identity);
		GameInfos.Instance.activeGameManagerGameOfSeed.SpawnVFX(VFXEnum.IndiSelf_G_30, transform.position + Vector3.up, Quaternion.identity);
	}

	public void ShowAOEIndicator(string indicator)
    {
		//GameInfos.Instance.activeGameManager.SpawnVFX((VFXEnum)Enum.Parse(typeof(VFXEnum), indicator), transform.position, transform.rotation);
    }

    public void IndiFront15() 
    {
        GameInfos.Instance.activeGameManagerGameOfSeed.SpawnVFX(entityVisual.whichTeamAmI() == SeedersTeamStatus.TEAM_A ? VFXEnum.Indi_R_15 : VFXEnum.Indi_B_15,
			transform.position, transform.rotation);
	}

	public void IndiFront18() {
		GameInfos.Instance.activeGameManagerGameOfSeed.SpawnVFX(entityVisual.whichTeamAmI() == SeedersTeamStatus.TEAM_A ? VFXEnum.Indi_R_18 : VFXEnum.Indi_B_18,
			transform.position, transform.rotation);
	}

	public void IndiFront21() {
		GameInfos.Instance.activeGameManagerGameOfSeed.SpawnVFX(entityVisual.whichTeamAmI() == SeedersTeamStatus.TEAM_A ? VFXEnum.Indi_R_21 : VFXEnum.Indi_B_21,
			transform.position, transform.rotation);
	}

	public void IndiFront24() {
		GameInfos.Instance.activeGameManagerGameOfSeed.SpawnVFX(entityVisual.whichTeamAmI() == SeedersTeamStatus.TEAM_A ? VFXEnum.Indi_R_24 : VFXEnum.Indi_B_24,
			transform.position, transform.rotation);
	}

	public void IndiSelf24() {
		GameInfos.Instance.activeGameManagerGameOfSeed.SpawnVFX(entityVisual.whichTeamAmI() == SeedersTeamStatus.TEAM_A ? VFXEnum.IndiSelf_R_24 : VFXEnum.IndiSelf_B_24,
			transform.position, transform.rotation);
	}

	public void IndiJump18() {
		GameInfos.Instance.activeGameManagerGameOfSeed.SpawnVFX(entityVisual.whichTeamAmI() == SeedersTeamStatus.TEAM_A ? VFXEnum.Indi_R_18 : VFXEnum.Indi_B_18,
			transform.position, transform.rotation);
	}

	public void SpawnShieldBashVfx()
    {
        GameInfos.Instance.activeGameManagerGameOfSeed.audioManager.PlaySound(Sounds.ShieldBash, 0.3f, false);
		GameInfos.Instance.activeGameManagerGameOfSeed.SpawnVFX(entityVisual.whichTeamAmI() == SeedersTeamStatus.TEAM_A ? VFXEnum.ClassicAttack_Red : VFXEnum.ClassicAttack_Blue,
	        transform.position, transform.rotation);
	}

	public void StepSound(AnimationEvent evt)
    {
        if (evt.animatorClipInfo.weight > 0.5f)
            GameInfos.Instance.activeGameManagerGameOfSeed.audioManager.PlaySound(Sounds.PlayerFootStep, 0.1f, true);
    }
}
