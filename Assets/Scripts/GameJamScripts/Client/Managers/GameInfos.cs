using UnityEngine;
using System.Collections.Generic;

public class GameInfos : Singleton<GameInfos>
{
	protected GameInfos() {} // Prevents constructor from being called publicly, can only be singleton.

    [HideInInspector] public GameManager_MMORPG activeGameManagerMMORPG;
    [HideInInspector] public StaticGameDatas staticGameData;
    protected override void DoAwake()
    {
        staticGameData = GetComponent<StaticGameDatas>();
    }

    protected override void DoDestroy()
    {
    }

    public void FlushGameManager()
    {
        activeGameManagerMMORPG = null;
    }
}