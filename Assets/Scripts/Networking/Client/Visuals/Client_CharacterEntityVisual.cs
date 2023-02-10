using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class Client_CharacterEntityVisual : Client_NetworkedEntityVisual
{
    public Animator anim;
    public Renderer circleR;
    private Material circleMat;

    public Renderer[] r;

    private AnimatorNodeNamesEnum activeAnimationId;
    private bool bHasSeed = false;
    private float animLayerBlender = 0f;

    private float moveMagnitude = 0f;

    public float emissiveValue;
    public GameObject throwArrow;

    private void OnEnable()
    {
        GameManager_GameOfSeed.OnSeedHolderChange += GameManager_OnSeedHolderChange;
    }

    private void GameManager_OnSeedHolderChange(int networkID)
    {
        if (networkID == Owner.networkId)
            SetHasSeed(true);
        else
            SetHasSeed(false);
    }

    public AnimatorNodeNamesEnum GetAnimId()
    {
        return activeAnimationId;
    }

    private void OnDisable()
    {
        GameManager_GameOfSeed.OnSeedHolderChange -= GameManager_OnSeedHolderChange;
    }

    protected Client_CharacterEntity client_CharacterEntity
    {
        get { return Owner as Client_CharacterEntity; }
    }

    public override void Initialize()
    {
        base.Initialize();

        anim.Play("Idle");
        GameInfos.Instance.activeGameManagerGameOfSeed.playerInputManager.SetJoystickTr(transform.Find("JoystickDir"));

        circleMat = circleR.material;

        circleMat.SetColor("_Color", whichTeamAmI() == SeedersTeamStatus.TEAM_A ? Color.red : Color.cyan);
        for (int i = 0; i < r.Length; i++)
        {
            Material[] tMat = new Material[r[i].materials.Length];

            for (int j = 0; j < r[i].materials.Length; j++)
            {
                if (r[i].materials[j].name.Contains("Team"))
                    tMat[j] = GameInfos.Instance.staticGameData.TeamColors[(int)whichTeamAmI()];
                else
                    tMat[j] = r[i].materials[j];
            }
            r[i].materials = tMat;
        }
    }

    public SeedersTeamStatus whichTeamAmI()
    {
        SeedersTeamStatus team = GameInfos.Instance.activeGameManagerGameOfSeed.GetTeamFromNetworkId(Owner.networkId);
        return team;
    }

    public override void Recycle()
    {
        base.Recycle();
    }

    public void SetHasSeed(bool bYes)
    {
        if (bHasSeed && !bYes)
            GameInfos.Instance.activeGameManagerGameOfSeed.audioManager.PlaySound(Sounds.ThrowSeed, 0.3f, true);

        bHasSeed = bYes;
    }
    
    

    private void AnimationBasedEvents()
    {
        if (activeAnimationId == AnimatorNodeNamesEnum.Ouch)
        {
            //GameInfos.Instance.activeGameManager.SpawnVFX(VFXEnum.Hit, transform.position + Vector3.up, Quaternion.identity);
            //GameInfos.Instance.activeGameManager.audioManager.PlaySound(Sounds.PlayerOuch, 0.3f, false);
            //GameInfos.Instance.activeGameManager.camManager.ShakeCam(0.2f);
            //emissiveValue = 10f;
        }
        else if (activeAnimationId == AnimatorNodeNamesEnum.Death)
        {
            GameInfos.Instance.activeGameManagerGameOfSeed.SpawnVFX(VFXEnum.BigBoom, transform.position + Vector3.up, Quaternion.identity);
            GameInfos.Instance.activeGameManagerGameOfSeed.audioManager.PlaySound(Sounds.PlayerDeath, 0.7f, false);
            GameInfos.Instance.activeGameManagerGameOfSeed.camManager.ShakeCam(0.3f);
        }
        else if (activeAnimationId == AnimatorNodeNamesEnum.Celebrate)
        {
            if (Owner.networkId == GameInfos.Instance.activeGameManagerGameOfSeed.localPlayerNetworkID)
            {
                GameInfos.Instance.activeGameManagerGameOfSeed.camManager.SetCamState(CamStatesEnum.LOOKATLOCALPLAYER);
                GameInfos.Instance.activeGameManagerGameOfSeed.SpawnVFX(VFXEnum.Emoji_Happy, transform);
                GameInfos.Instance.activeGameManagerGameOfSeed.guiManager.SetWinMessage(whichTeamAmI());
                GameInfos.Instance.activeGameManagerGameOfSeed.audioManager.PlaySound(Sounds.Win);
            }
        }
        else if (activeAnimationId == AnimatorNodeNamesEnum.Mourn)
        {
            if (Owner.networkId == GameInfos.Instance.activeGameManagerGameOfSeed.localPlayerNetworkID)
            {
                GameInfos.Instance.activeGameManagerGameOfSeed.camManager.SetCamState(CamStatesEnum.LOOKATLOCALPLAYER);
                GameInfos.Instance.activeGameManagerGameOfSeed.SpawnVFX(VFXEnum.Emoji_Lose, transform);
                SeedersTeamStatus oppositeTeam = whichTeamAmI();
                if (oppositeTeam == SeedersTeamStatus.TEAM_A) oppositeTeam = SeedersTeamStatus.TEAM_B;
                else oppositeTeam = SeedersTeamStatus.TEAM_A;
                GameInfos.Instance.activeGameManagerGameOfSeed.guiManager.SetWinMessage(oppositeTeam);
                GameInfos.Instance.activeGameManagerGameOfSeed.audioManager.PlaySound(Sounds.Lose);
            }
        }
        else if (activeAnimationId == AnimatorNodeNamesEnum.Mock)
        {
            GameInfos.Instance.activeGameManagerGameOfSeed.SpawnVFX(VFXEnum.Emoji_Mock, transform);
            GameInfos.Instance.activeGameManagerGameOfSeed.audioManager.PlaySound(Sounds.Taunt);
        }

        if ((int)activeAnimationId > 10 && (int)activeAnimationId < 100)
            PlayTaiwaneseVoice();

        // Abilities CD timer, only if I am local player
        if (Owner.networkId == GameInfos.Instance.activeGameManagerGameOfSeed.localPlayerNetworkID)
        {
            int abilityIdx = -1;
            switch (activeAnimationId)
            {
                case (AnimatorNodeNamesEnum.BarAbility3): abilityIdx = 0; break;
                case (AnimatorNodeNamesEnum.BarAbility1): abilityIdx = 1; break;
                case (AnimatorNodeNamesEnum.BarAbility2): abilityIdx = 2; break;
                case (AnimatorNodeNamesEnum.RgrAbility1): abilityIdx = 0; break;
                case (AnimatorNodeNamesEnum.RgrAbility2): abilityIdx = 1; break;
                case (AnimatorNodeNamesEnum.RgrAbility3): abilityIdx = 2; break;
                case (AnimatorNodeNamesEnum.PalAbility2): abilityIdx = 0; break;
                case (AnimatorNodeNamesEnum.PalAbility3): abilityIdx = 1; break;
                case (AnimatorNodeNamesEnum.PalAbility1): abilityIdx = 2; break;
                case (AnimatorNodeNamesEnum.AssAbility3): abilityIdx = 0; break;
                case (AnimatorNodeNamesEnum.AssAbility2): abilityIdx = 1; break;
                case (AnimatorNodeNamesEnum.AssAbility1): abilityIdx = 2; break;
            }

            if (abilityIdx != -1)
                GameInfos.Instance.activeGameManagerGameOfSeed.guiManager.SetCDTimer(abilityIdx);
        }
    }

    private void PlayTaiwaneseVoice()
    {
        Sounds sound = Sounds.NULL;
        
        switch (activeAnimationId)
        {
            case (AnimatorNodeNamesEnum.BarAbility3): sound = Sounds.Bar1; break;
            case (AnimatorNodeNamesEnum.BarAbility1): sound = Sounds.Bar2; break;
            case (AnimatorNodeNamesEnum.BarAbility2): sound = Sounds.Bar3; break;
            case (AnimatorNodeNamesEnum.RgrAbility1): sound = Sounds.Ran1; break;
            case (AnimatorNodeNamesEnum.RgrAbility2): sound = Sounds.Ran2; break;
            case (AnimatorNodeNamesEnum.RgrAbility3): sound = Sounds.Ran3; break;
            case (AnimatorNodeNamesEnum.PalAbility2): sound = Sounds.Pal1; break;
            case (AnimatorNodeNamesEnum.PalAbility3): sound = Sounds.Pal2; break;
            case (AnimatorNodeNamesEnum.PalAbility1): sound = Sounds.Pal3; break;
            case (AnimatorNodeNamesEnum.AssAbility3): sound = Sounds.Ass1; break;
            case (AnimatorNodeNamesEnum.AssAbility2): sound = Sounds.Ass2; break;
            case (AnimatorNodeNamesEnum.AssAbility1): sound = Sounds.Ass3; break;
        }
        
        if (sound != Sounds.NULL)
            GameInfos.Instance.activeGameManagerGameOfSeed.audioManager.PlaySound(sound);
    }

    private void Update()
    {
        if (client_CharacterEntity == null)
            return;
        
        // Ouch arcade Emissive
        if (emissiveValue > 0f)
        {
            emissiveValue -= Time.deltaTime * 15f;
            
            for (int i = 0; i < r.Length; i++)
                 r[i].material.SetColor("_EmissionColor", new Color(1f,1f,1f) * emissiveValue);
        }
        else
        {
            if (emissiveValue != 0f)
            {
                for (int i = 0; i < r.Length; i++)
                    r[i].material.SetColor("_EmissionColor", Color.black);
                emissiveValue = 0f;
            }
        }
        
        // ThrowArrow
        if (Owner.networkId == GameInfos.Instance.activeGameManagerGameOfSeed.localPlayerNetworkID)
            throwArrow.SetActive(GameInfos.Instance.activeGameManagerGameOfSeed.playerInputManager.pressedTimer > 0.3f);
        
        animLayerBlender = Mathf.Lerp(animLayerBlender, bHasSeed ? 1f : 0f, Time.deltaTime * 10f);
        anim.SetLayerWeight(1, animLayerBlender);

        if ((client_CharacterEntity.Flags & SnapshotFlags.IsMoving) == SnapshotFlags.IsMoving)
            moveMagnitude += Time.deltaTime * 30f;
        else
            moveMagnitude -= Time.deltaTime * 30f;
        moveMagnitude = Mathf.Clamp01(moveMagnitude);
        anim.SetFloat("MoveSpeed", moveMagnitude);

        if (client_CharacterEntity.AnimationId != activeAnimationId)
        {
            float transitionTime = GetTransitionTime(activeAnimationId, client_CharacterEntity.AnimationId);
            activeAnimationId = client_CharacterEntity.AnimationId;

            if (activeAnimationId != AnimatorNodeNamesEnum.Locomotion)
            {
                //Debug.Log("Playing anim : " + activeAnimationId, gameObject);
                anim.Play(activeAnimationId.ToString(), 0, transitionTime);

                anim.SetLayerWeight(1, 0f); // Deactivate HOLD Layer during abilities

                AnimationBasedEvents();
            }
            else
            {
                if ((client_CharacterEntity.Flags & SnapshotFlags.IsMoving) == SnapshotFlags.IsMoving)
                    anim.Play("Run", 0, 0.3f);
                else
                    anim.Play("Idle", 0, 0.3f);
            }
        }

        anim.speed = client_CharacterEntity.AnimationSpeed;
    }

    private float GetTransitionTime(AnimatorNodeNamesEnum from, AnimatorNodeNamesEnum to)
    {
        float t = 0.1f;

        switch (to)
        {
            case AnimatorNodeNamesEnum.AssAbility1:
                t = 0.3f;
                break;
            case AnimatorNodeNamesEnum.AssAbility2:
                t = 0.25f;
                break;
            case AnimatorNodeNamesEnum.AssAbility3:
                t = 0.1f;
                break;
            case AnimatorNodeNamesEnum.AssAttack:
                t = 0.2f;
                break;
            case AnimatorNodeNamesEnum.BarAbility1:
                t = 0.35f;
                break;
            case AnimatorNodeNamesEnum.BarAbility2:
                t = 0.3f;
                break;
            case AnimatorNodeNamesEnum.BarAbility3:
                t = 0.15f;
                break;
            case AnimatorNodeNamesEnum.BarAttack:
                t = 0.2f;
                break;
            case AnimatorNodeNamesEnum.PalAbility1:
                t = 0.3f;
                break;
            case AnimatorNodeNamesEnum.PalAbility2:
                t = 0.05f;
                break;
            case AnimatorNodeNamesEnum.PalAbility3:
                t = 0.15f;
                break;
            case AnimatorNodeNamesEnum.PalAttack:
                t = 0.1f;
                break;
            case AnimatorNodeNamesEnum.RgrAbility1:
                t = 0.1f;
                break;
            case AnimatorNodeNamesEnum.RgrAbility2:
                t = 0.1f;
                break;
            case AnimatorNodeNamesEnum.RgrAbility3:
                t = 0.1f;
                break;
            case AnimatorNodeNamesEnum.RgrAttack:
                t = 0.1f;
                break;
        }
        // if ((int)from >= (int)AnimatorNodeNamesEnum.BrbnAttack1 && (int)to <= (int)AnimatorNodeNamesEnum.BrbnAttack3)
        //     t = 0.2f;
        // else if (from == AnimatorNodeNamesEnum.PalAbility1)
        //     t = 0f;
        return t;
    }
}
