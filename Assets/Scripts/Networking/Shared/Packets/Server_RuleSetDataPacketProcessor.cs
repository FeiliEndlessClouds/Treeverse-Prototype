
using System.Collections.Generic;

public static class Server_RuleSetDataPacketProcessor
{
    // Seed rules data
    public static void WriteToRuleSetData(ref ByteBuffer buffer, Server_RuleSet_MMORPG ruleSetManager)
    {
        buffer.Put(PacketType.Server_RuleSetData);

        // Order : isReadyToFight, GameOfSeedState, number of player, idArray, teamArray
        // buffer.Put(ruleSetManager.isReadyToFight);
        // buffer.Put((byte)ruleSetManager.gameState);
        // buffer.Put((ushort)ruleSetManager.playerList.Count);
        // for (int i = 0; i < ruleSetManager.playerList.Count; i++)
        // {
        //     buffer.Put((ushort)ruleSetManager.playerList[i].NetworkId);
        //     buffer.Put((string)ruleSetManager.playerList[i].PlayerName);
        //     buffer.Put((int)ruleSetManager.playerList[i].Statistics_DamageDealt);
        //     buffer.Put((int)ruleSetManager.playerList[i].Statistics_DamageMitigated);
        //     buffer.Put((int)ruleSetManager.playerList[i].Statistics_Healed);
        //     buffer.Put((ushort)ruleSetManager.playerList[i].Statistics_Death);
        //     buffer.Put((ushort)ruleSetManager.playerList[i].Statistics_Killed);
        // }
        // for (int i = 0; i < ruleSetManager.playersTeamStatusList.Count; i++)
        //     buffer.Put((ushort)ruleSetManager.playersTeamStatusList[i]);
        //
        // buffer.Put((byte)ruleSetManager.match);
        // for (int i = 0; i < ruleSetManager.matchesWonByTeam.Length; i++)
        //     buffer.Put((byte)ruleSetManager.matchesWonByTeam[i]);
    }

    public static void ProcessRuleSetData(ref ByteBuffer buffer, int networkPlayerId)
    {
        // Order : isReadyToFight, GameOfSeedState, number of player, idArray, teamArray
        // bool isReadyToFight = buffer.GetBool();
        // SeedGameStatesEnum seedGameState = (SeedGameStatesEnum)buffer.GetByte();
        // int playerCount = buffer.GetUShort();
        //
        // int[] idArray = new int[playerCount];
        // string[] playerNameArray = new string[playerCount];
        // List<GameContributeModel> gameContributes = new List<GameContributeModel>();
        //
        // for (int i = 0; i < idArray.Length; i++)
        // {
        //     idArray[i] = buffer.GetUShort();
        //     playerNameArray[i] = buffer.GetString();
        //
        //     GameContributeModel gameContribute = new GameContributeModel()
        //     {
        //         NetworkId = idArray[i],
        //         PlayerName = playerNameArray[i],
        //         DamageDealt = buffer.GetInt(),
        //         DamageMitigated = buffer.GetInt(),
        //         Healed = buffer.GetInt(),
        //         Death = buffer.GetUShort(),
        //         Killed = buffer.GetUShort()
        //     };
        //     gameContributes.Add(gameContribute);
        // }
        //
        // SeedersTeamStatus[] teamStatusArray = new SeedersTeamStatus[playerCount];
        // for (int i = 0; i < teamStatusArray.Length; i++)
        // {
        //     teamStatusArray[i] = (SeedersTeamStatus)buffer.GetUShort();
        // }
        // int round = buffer.GetByte();
        // SeedersTeamStatus[] matchesWonByTeam = new SeedersTeamStatus[4];
        // for (int i = 0; i < matchesWonByTeam.Length; i++)
        //     matchesWonByTeam[i] = (SeedersTeamStatus)buffer.GetByte();
        //
        // GameInfos.Instance.activeGameManagerGameOfSeed.UpdateRuleSetData(seedGameState, playerCount, idArray, playerNameArray, teamStatusArray, round, matchesWonByTeam, gameContributes);
        //
        // if (isReadyToFight)
        //     GameInfos.Instance.activeGameManagerGameOfSeed.ShowFightBtn();
        // else
        //     GameInfos.Instance.activeGameManagerGameOfSeed.HideFightBtn();
    }
}
