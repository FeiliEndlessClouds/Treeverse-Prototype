
using System.Collections.Generic;

public static class Server_RuleSetDataPacketProcessor
{
    // Seed rules data
    public static void WriteToRuleSetData(ref ByteBuffer buffer, Server_RuleSet_MMORPG ruleSetManager)
    {
        buffer.Put(PacketType.Server_RuleSetData);
        // Game state etc...
    }

    public static void ProcessRuleSetData(ref ByteBuffer buffer, int networkPlayerId)
    {
        // Order : isReadyToFight, GameOfSeedState, number of player, idArray, teamArray
        // bool isReadyToFight = buffer.GetBool();
        // SeedGameStatesEnum seedGameState = (SeedGameStatesEnum)buffer.GetByte();
        // int playerCount = buffer.GetUShort();
    }
    
    public static void WriteToCollectResources(ref ByteBuffer buffer, Server_RuleSet_MMORPG ruleSetManager, CollectiblesEnum resource, int howMany)
    {
        buffer.Put(PacketType.Server_CollectResources);
        
        buffer.Put((byte)resource);
        buffer.Put((byte)howMany);      // Don't exceed 255.
    }
    
    public static void ProcessCollectResources(ref ByteBuffer buffer, int networkPlayerId)
    {
        CollectiblesEnum resource = (CollectiblesEnum)buffer.GetByte();
        int howMany = (int)buffer.GetByte();
    }
}
