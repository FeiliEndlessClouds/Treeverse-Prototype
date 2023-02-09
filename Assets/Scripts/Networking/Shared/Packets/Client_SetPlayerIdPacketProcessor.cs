using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//Naming convention : Client_ is about who is receiving it. Or we can do Client_ means Client_ is the sender.
public static class Client_SetPlayerIdPacketProcessor
{
    public static void WriteTo(ref ByteBuffer buffer, Server_PlayerEntity player)
    {
        buffer.Put(PacketType.Client_SetPlayerId);
        buffer.Put((ushort)(player.NetworkId));
    }

    public static void Process(ref ByteBuffer buffer, Client_NetworkManager manager)
    {
        manager.NetworkPlayerId = buffer.GetUShort();
    }
}
