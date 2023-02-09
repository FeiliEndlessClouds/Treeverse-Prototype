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

    public Transform inventoryItemsRootTr;
    private Image[] itemsImgArray;
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

        itemsImgArray = new Image[inventoryItemsRootTr.childCount];
        for (int i = 0; i < itemsImgArray.Length; i++)
            itemsImgArray[i] = inventoryItemsRootTr.GetChild(i).GetComponent<Image>();

        StartCoroutine(LogoFadeC());
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

    public void UpdateIconAtIndex(int idx, Sprite sprite)
    {
        //Sprite sprite = Sprite.Create(tex, new Rect(0, 0, tex.width, tex.height), new Vector2(tex.width / 2, tex.height / 2));
        
        itemsImgArray[idx].sprite = sprite;
        itemsImgArray[idx].enabled = true;
    }
    
    public void ClearIconAtIndex(int idx)
    {
        itemsImgArray[idx].enabled = false;
        itemsImgArray[idx].sprite = null;
    }

    public void ClearInventoryGUI()
    {
        for (int i = 1; i < itemsImgArray.Length; i++)
        {
            itemsImgArray[i].sprite = null;
            itemsImgArray[i].enabled = false;
        }
        itemsImgArray[0].sprite = deathSprite;
    }

	public void SetHP(float value)
    {
	    hpSlider.value = value;
    }

    public void SetSP(float value)
    {
	    spSlider.value = value;
    }

    public void SetAbilityIcons(Sprite[] icons)
    {
        for (int i = 0; i < abilityImg.Length; i++)
            abilityImg[i].sprite = icons[i];
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

    public void SetRoundColor(int whichRound, Color color)
    {
        roundWonArray[whichRound].color = color;
    }

    public void SetRound(int roundNumber)
    {
        roundTxt.text = "Round " + roundNumber.ToString();
    }

    public void SetWinMessage(SeedersTeamStatus whichTeam)
    {
        if (whichTeam == SeedersTeamStatus.TEAM_A) winMessage[0].SetActive(true);
        else if (whichTeam == SeedersTeamStatus.TEAM_B) winMessage[1].SetActive(true);
        else
        {
            winMessage[0].SetActive(false);
            winMessage[1].SetActive(false);
        }
    }

    public void SetEndMatchImage(bool bWon)
    {
        EndImage[0].SetActive(false);
        EndImage[1].SetActive(false);

        if (bWon)
            EndImage[0].SetActive(true);
        else
            EndImage[1].SetActive(true);
    }
}
