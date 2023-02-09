
using System.Collections.Generic;

public static class Server_RuleSetDataPacketProcessor
{
    // Seed rules data
    public static void WriteToRuleSetData(ref ByteBuffer buffer, Server_RuleSet_GameOfSeed ruleSetManager)
    {
        buffer.Put(PacketType.Server_RuleSetData);

        // Order : isReadyToFight, GameOfSeedState, number of player, idArray, teamArray
        buffer.Put(ruleSetManager.isReadyToFight);
        buffer.Put((byte)ruleSetManager.gameState);
        buffer.Put((ushort)ruleSetManager.playerList.Count);
        for (int i = 0; i < ruleSetManager.playerList.Count; i++)
        {
            buffer.Put((ushort)ruleSetManager.playerList[i].NetworkId);
            buffer.Put((string)ruleSetManager.playerList[i].PlayerName);
            buffer.Put((int)ruleSetManager.playerList[i].Statistics_DamageDealt);
            buffer.Put((int)ruleSetManager.playerList[i].Statistics_DamageMitigated);
            buffer.Put((int)ruleSetManager.playerList[i].Statistics_Healed);
            buffer.Put((ushort)ruleSetManager.playerList[i].Statistics_Death);
            buffer.Put((ushort)ruleSetManager.playerList[i].Statistics_Killed);
        }
        for (int i = 0; i < ruleSetManager.playersTeamStatusList.Count; i++)
            buffer.Put((ushort)ruleSetManager.playersTeamStatusList[i]);
        
        buffer.Put((byte)ruleSetManager.match);
        for (int i = 0; i < ruleSetManager.matchesWonByTeam.Length; i++)
            buffer.Put((byte)ruleSetManager.matchesWonByTeam[i]);
    }

    public static void ProcessRuleSetData(ref ByteBuffer buffer, int networkPlayerId)
    {
        // Order : isReadyToFight, GameOfSeedState, number of player, idArray, teamArray
        bool isReadyToFight = buffer.GetBool();
        SeedGameStatesEnum seedGameState = (SeedGameStatesEnum)buffer.GetByte();
        int playerCount = buffer.GetUShort();

        int[] idArray = new int[playerCount];
        string[] playerNameArray = new string[playerCount];
        List<GameContributeModel> gameContributes = new List<GameContributeModel>();

        for (int i = 0; i < idArray.Length; i++)
        {
            idArray[i] = buffer.GetUShort();
            playerNameArray[i] = buffer.GetString();

            GameContributeModel gameContribute = new GameContributeModel()
            {
                NetworkId = idArray[i],
                PlayerName = playerNameArray[i],
                DamageDealt = buffer.GetInt(),
                DamageMitigated = buffer.GetInt(),
                Healed = buffer.GetInt(),
                Death = buffer.GetUShort(),
                Killed = buffer.GetUShort()
            };
            gameContributes.Add(gameContribute);
        }

        SeedersTeamStatus[] teamStatusArray = new SeedersTeamStatus[playerCount];
        for (int i = 0; i < teamStatusArray.Length; i++)
        {
            teamStatusArray[i] = (SeedersTeamStatus)buffer.GetUShort();
        }
        int round = buffer.GetByte();
        SeedersTeamStatus[] matchesWonByTeam = new SeedersTeamStatus[4];
        for (int i = 0; i < matchesWonByTeam.Length; i++)
            matchesWonByTeam[i] = (SeedersTeamStatus)buffer.GetByte();
        
        GameInfos.Instance.activeGameManager.UpdateRuleSetData(seedGameState, playerCount, idArray, playerNameArray, teamStatusArray, round, matchesWonByTeam, gameContributes);

        if (isReadyToFight)
            GameInfos.Instance.activeGameManager.ShowFightBtn();
        else
            GameInfos.Instance.activeGameManager.HideFightBtn();
    }

    // Set player class
    public static void WriteToSetClass(ref ByteBuffer buffer, int networkId, SeedGameClassesEnum whichClass)
    {
        buffer.Put(PacketType.Server_SetPlayerClass);

        buffer.Put((ushort)networkId);
        buffer.Put((byte)whichClass);
    }

    public static void ProcessSetClass(ref ByteBuffer buffer)
    {
        int networkId = buffer.GetUShort();
        SeedGameClassesEnum whichClass = (SeedGameClassesEnum)buffer.GetByte();

        GameInfos.Instance.activeGameManager.SetPlayerClass(networkId, whichClass);
    }

    // Set Effect on Player
    public static void WriteToSetEffect(ref ByteBuffer buffer, int networkId, int slotId, effectsEnum effect)
    {
        buffer.Put(PacketType.Client_SetItemAt);
        buffer.Put((ushort)networkId);
        buffer.Put((ushort)slotId);
        buffer.Put((byte)effect);
    }

    public static void ProcessSetEffect(ref ByteBuffer buffer)
    {
        int networkID = buffer.GetUShort();
        int slotId = buffer.GetUShort();
        effectsEnum effect = (effectsEnum)buffer.GetByte();

        GameInfos.Instance.activeGameManager.SetEffectAt(networkID, slotId, effect);
    }

    // Set Seed Holder
    public static void WriteToSetSeedHolder(ref ByteBuffer buffer, bool bSeedPlanted, Server_PlayerEntity seedHolder, int seedLife, int seedGrowth)
    {
        buffer.Put(PacketType.Server_SetSeedHolder);
        if (bSeedPlanted)
            buffer.Put((short)-2);
        else
        {
            if (!seedHolder)
                buffer.Put((short)-1);
            else
                buffer.Put((short)seedHolder.NetworkId);
        }

        buffer.Put((ushort)seedLife);
        buffer.Put((ushort)seedGrowth);
    }

    public static void ProcessSetSeedHolder(ref ByteBuffer buffer)
    {
        GameInfos.Instance.activeGameManager.UpdateSeedHolder(buffer.GetShort(), buffer.GetUShort(), buffer.GetUShort());
    }
    
    public static void WriteToTreeExplode(ref ByteBuffer buffer)
    {
        buffer.Put(PacketType.Server_TreeExplode);
    }
    
    public static void ProcessTreeExplode(ref ByteBuffer buffer)
    {
        GameInfos.Instance.activeGameManager.TreeExplode();
    }
}
