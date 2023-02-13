using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum PacketType: int
{
    None,

    /* Client Packets */
    Client_SetPlayerId,
    Server_RuleSetData,
    Server_CollectResources,
}
