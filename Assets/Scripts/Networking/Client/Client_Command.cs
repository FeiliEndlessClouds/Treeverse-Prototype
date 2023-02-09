using ENet;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public struct Client_Command
{
    public CommandKind Kind;
    public Peer PeerPayload;
    public Packet PacketPayload;
}
