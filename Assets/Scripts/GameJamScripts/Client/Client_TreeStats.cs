using UnityEngine;
using TMPro;

public class Client_TreeStats : MonoBehaviour
{
    public TMP_Text txt;
    private int maxLife = 100;

    private void OnEnable()
    {
        GameManager.OnSeedHolderChange += GameManager_OnSeedHolderChange;
    }

    private void GameManager_OnSeedHolderChange(int networkId)
    {
        int seedLife = GameInfos.Instance.activeGameManager.seedLife;
        float growth = GameInfos.Instance.activeGameManager.seedGrowth;
        if (maxLife < seedLife)
            maxLife = seedLife;
        txt.text = seedLife.ToString() + " / " + maxLife.ToString();
        if (growth > 0f)
            txt.text += "\n" + Mathf.Round(growth).ToString();
    }

    private void OnDisable()
    {
        GameManager.OnSeedHolderChange -= GameManager_OnSeedHolderChange;
    }
}
