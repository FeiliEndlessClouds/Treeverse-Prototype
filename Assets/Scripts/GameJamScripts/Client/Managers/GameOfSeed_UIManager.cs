using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class GameOfSeed_UIManager : MonoBehaviour
{
    private GameManager_GameOfSeed _gameManagerGameOfSeed;

    public CanvasGroup[] gameOfSeedCGArray = new CanvasGroup[(int)SeedGameStatesEnum.GAME_END];

    public TMP_Text teamABlock;

    public TMP_Text teamBBlock;

    public TMP_Text chatBoard;

    public TMP_InputField chatInput;

    public Button teamSwitch;

    public Button fightBtn;

    public Button playAgainBtn;

    public Button exitBtn;

    public TMP_Text resultTxt;

    public void Init(GameManager_GameOfSeed gm)
    {
        _gameManagerGameOfSeed = gm;
        HideAllMenus();
        HideFightBtn();
        AddBtnsListener();
    }

    public void HideAllMenus()
    {
        for (int i = 0; i < gameOfSeedCGArray.Length; i++)
        {
            gameOfSeedCGArray[i].alpha = 0f;
            gameOfSeedCGArray[i].gameObject.SetActive(false);
        }
    }

    public IEnumerator SwitchMenuC(SeedGameStatesEnum hideMenu, SeedGameStatesEnum displayMenu)
    {
        yield return StartCoroutine(HideMenuC(hideMenu));
        yield return new WaitForSeconds(0.5f);
        yield return StartCoroutine(DisplayMenuC(displayMenu));
    }

    public IEnumerator DisplayMenuC(SeedGameStatesEnum whichMenu)
    {
        gameOfSeedCGArray[(int)whichMenu].gameObject.SetActive(true);
        float timer = 0f;
        while (timer < 1f)
        {
            timer += Time.deltaTime * 5f;
            gameOfSeedCGArray[(int)whichMenu].alpha = timer;
            yield return null;
        }
        gameOfSeedCGArray[(int)whichMenu].alpha = 1f;
    }

    public IEnumerator HideMenuC(SeedGameStatesEnum whichMenu)
    {
        float timer = 1f;
        while (timer > 0f)
        {
            timer -= Time.deltaTime * 5f;
            gameOfSeedCGArray[(int)whichMenu].alpha = timer;
            yield return null;
        }
        gameOfSeedCGArray[(int)whichMenu].alpha = 0f;
        gameOfSeedCGArray[(int)whichMenu].gameObject.SetActive(false);
    }

    private void AddBtnsListener()
    {
        teamSwitch.onClick.AddListener(_gameManagerGameOfSeed.SwitchTeam);
        fightBtn.onClick.AddListener(_gameManagerGameOfSeed.Fight);
        playAgainBtn.onClick.AddListener(_gameManagerGameOfSeed.PlayAgain);
        exitBtn.onClick.AddListener(_gameManagerGameOfSeed.ExitGame);
        chatInput.onSubmit.AddListener(_gameManagerGameOfSeed.SendChatInputToServer);
    }

    public void HideFightBtn()
    {
        fightBtn.enabled = false;
        fightBtn.gameObject.SetActive(false);
    }

    public void ShowFightBtn()
    {
        fightBtn.enabled = true;
        fightBtn.gameObject.SetActive(true);
    }

    public void RefreshResultTxt(List<GameContributeModel> gameContributes)
    {
        resultTxt.text = "\t\t\tDamage\tHealed\tDeath\t\tKilled\n";
        foreach (var gc in gameContributes)
        {
            string playerName = string.IsNullOrWhiteSpace(gc.PlayerName) ?
                ((gc.NetworkId == _gameManagerGameOfSeed.localPlayerNetworkID) ? $"*Player{gc.NetworkId}\t" : $"Player{gc.NetworkId}\t") :
                ((gc.NetworkId == _gameManagerGameOfSeed.localPlayerNetworkID) ? $"*{gc.PlayerName}" : $"{gc.PlayerName}");
            resultTxt.text += $"{playerName}\t{gc.DamageDealt}\t\t{gc.Healed}\t\t{gc.Death}\t\t{gc.Killed}\n";
        }
    }
}
