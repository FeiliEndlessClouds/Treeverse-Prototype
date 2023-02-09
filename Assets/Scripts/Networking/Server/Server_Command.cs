using ENet;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public struct Server_Command
{
    public CommandKind Kind;
    public Peer PeerPayload;
    public Packet PacketPayload;
    public Server_Chunk ChunkPayload;
}
