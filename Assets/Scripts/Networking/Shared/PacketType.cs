using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum PacketType: int
{
    None,

    /* Client Packets */
    Client_SetPlayerId,
    Server_JoinDungeon,
    Client_SetItemAt,
    Server_ChangeScene,

    Server_RuleSetData,
    Client_SetPlayerClass,
    Server_SetSeedHolder,
    Server_SetPlayerClass,

    Client_SendMessage,
    Server_SendMessage,

    Client_SwitchTeam,
    Client_Fight,
    Client_PlayAgain,
    
    Server_TreeExplode,
}
