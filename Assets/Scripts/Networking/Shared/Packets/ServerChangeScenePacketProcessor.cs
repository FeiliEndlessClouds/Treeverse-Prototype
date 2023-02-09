using System;
using UnityEngine;

namespace Networking.Shared.Packets
{
	public static class ServerChangeScenePacketProcessor
	{
		public static void WriteTo(ref ByteBuffer buffer, string sceneName, bool additive, Vector3 position)
		{
			buffer.Put(PacketType.Server_ChangeScene);
			buffer.Put(sceneName);
			buffer.Put(additive);
			buffer.PutVar(Mathf.RoundToInt(position.x));
			buffer.PutVar(Mathf.RoundToInt(position.y));
			buffer.PutVar(Mathf.RoundToInt(position.z));
		}

		public static ValueTuple<string, bool, Vector3> Process(ref ByteBuffer buffer)
		{
			string sceneName = buffer.GetString();
			bool additive = buffer.GetBool();
			Vector3 position = new Vector3(buffer.GetVarInt(), buffer.GetVarInt(), buffer.GetVarInt());

			return new ValueTuple<string, bool, Vector3>(sceneName, additive, position);
		}
	}
}