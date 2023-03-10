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

    protected Client_CharacterEntity client_CharacterEntity
    {
        get { return Owner as Client_CharacterEntity; }
    }

    public override void Initialize()
    {
        base.Initialize();

        anim.Play("Idle");
        GameInfos.Instance.activeGameManagerMMORPG.playerInputManager.SetJoystickTr(transform.Find("JoystickDir"));
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
            //GameInfos.Instance.activeGameManagerMMORPG.SpawnVFX(VFXEnum.BigBoom, transform.position + Vector3.up, Quaternion.identity);
            GameInfos.Instance.activeGameManagerMMORPG.audioManager.PlaySound(Sounds.PlayerDeath, 0.7f, false);
            GameInfos.Instance.activeGameManagerMMORPG.camManager.ShakeCam(0.3f);
        }

        if ((int)activeAnimationId > 10 && (int)activeAnimationId < 100)
            PlayTaiwaneseVoice();

        // Abilities CD timer, only if I am local player
        if (Owner.networkId == GameInfos.Instance.activeGameManagerMMORPG.localClient_PlayerEntity.networkId)
        {
            int abilityIdx = -1;
            switch (activeAnimationId)
            {
                case (AnimatorNodeNamesEnum.BarAbility3): abilityIdx = 0; break;
                case (AnimatorNodeNamesEnum.BarAbility1): abilityIdx = 1; break;
                case (AnimatorNodeNamesEnum.BarAbility2): abilityIdx = 2; break;
            }

            if (abilityIdx != -1)
                GameInfos.Instance.activeGameManagerMMORPG.guiManager.SetCDTimer(abilityIdx);
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
        }
        
        if (sound != Sounds.NULL)
            GameInfos.Instance.activeGameManagerMMORPG.audioManager.PlaySound(sound);
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
        if (Owner.networkId == GameInfos.Instance.activeGameManagerMMORPG.localClient_PlayerEntity.networkId)
            throwArrow.SetActive(GameInfos.Instance.activeGameManagerMMORPG.playerInputManager.pressedTimer > 0.3f);
        
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
        }
        // if ((int)from >= (int)AnimatorNodeNamesEnum.BrbnAttack1 && (int)to <= (int)AnimatorNodeNamesEnum.BrbnAttack3)
        //     t = 0.2f;
        // else if (from == AnimatorNodeNamesEnum.PalAbility1)
        //     t = 0f;
        return t;
    }
}
