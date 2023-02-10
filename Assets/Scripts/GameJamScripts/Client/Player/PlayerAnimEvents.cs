using System.Collections;
using System.Collections.Generic;
using System.Xml.Linq;
using UnityEngine;
using System;

public class PlayerAnimEvents : MonoBehaviour
{
    public Client_CharacterEntityVisual entityVisual;
    
	public void StepSound(AnimationEvent evt)
    {
        if (evt.animatorClipInfo.weight > 0.5f)
            GameInfos.Instance.activeGameManagerMMORPG.audioManager.PlaySound(Sounds.PlayerFootStep, 0.1f, true);
    }
}
