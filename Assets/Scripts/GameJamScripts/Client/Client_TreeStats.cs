using UnityEngine;
using TMPro;

public class Client_TreeStats : MonoBehaviour
{
    public TMP_Text txt;
    private int maxLife = 100;

    private void OnEnable()
    {
        GameManager_GameOfSeed.OnSeedHolderChange += GameManager_OnSeedHolderChange;
    }

    private void GameManager_OnSeedHolderChange(int networkId)
    {
        int seedLife = GameInfos.Instance.activeGameManagerGameOfSeed.seedLife;
        float growth = GameInfos.Instance.activeGameManagerGameOfSeed.seedGrowth;
        if (maxLife < seedLife)
            maxLife = seedLife;
        txt.text = seedLife.ToString() + " / " + maxLife.ToString();
        if (growth > 0f)
            txt.text += "\n" + Mathf.Round(growth).ToString();
    }

    private void OnDisable()
    {
        GameManager_GameOfSeed.OnSeedHolderChange -= GameManager_OnSeedHolderChange;
    }
}
