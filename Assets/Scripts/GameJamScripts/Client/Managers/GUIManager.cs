using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class GUIManager : MonoBehaviour
{
    public Image redScreen;
    public Slider hpSlider;
    public Slider spSlider;

    public Sprite deathSprite;

    public Image[] abilityImg;
    public TMP_Text[] abilityCDText;
    private float[] abilityCdTimerArray = new float[3];
    private float[] abilityCdMaxTimerArray = new float[3];
    public Image[] abilityCDRadialImgArray;

    public CanvasGroup logoCG;

    public Image[] roundWonArray;
    public TMP_Text roundTxt;
    public GameObject[] winMessage;

    public GameObject[] EndImage;

    private void Awake()
    {
        redScreen.enabled = true;

        //StartCoroutine(LogoFadeC());
    }

    IEnumerator LogoFadeC()
    {
        logoCG.alpha = 1f;
        logoCG.enabled = true;
        yield return new WaitForSeconds(2f);
        float timer = 1f;
        while (timer > 0f)
        {
            timer -= Time.deltaTime;
            logoCG.alpha = timer;
            yield return null;
        }
        logoCG.alpha = 0f;
        logoCG.gameObject.SetActive(false);
    }

    public void SetHP(float value)
    {
	    hpSlider.value = value;
    }

    public void SetSP(float value)
    {
	    spSlider.value = value;
    }

    public void SetCDTimer(int whichAbility)
    {
        abilityCdTimerArray[whichAbility] = GameInfos.Instance.staticGameData.abilityCDTimers[whichAbility];
        abilityCdMaxTimerArray[whichAbility] = GameInfos.Instance.staticGameData.abilityCDTimers[whichAbility];
        abilityCDRadialImgArray[whichAbility].fillAmount = 1f;
    }

    private void Update()
    {
        for (int i = 0; i < abilityCdTimerArray.Length; i++)
        {
            if (abilityCdTimerArray[i] > 0f)
            {
                abilityCdTimerArray[i] -= Time.deltaTime;
                abilityCDText[i].text = abilityCdTimerArray[i].ToString("F1");
                abilityCDRadialImgArray[i].fillAmount =
                    Mathf.InverseLerp(abilityCdMaxTimerArray[i], 0f, abilityCdTimerArray[i]);
            }
            else
            {
                abilityCDText[i].text = "0.0";
            }
        }
    }
}
