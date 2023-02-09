namespace Networking.Server.Packets
{
	public static class Server_JoinDungeonPacketProcessor
	{
		public static void WriteTo(ref ByteBuffer buffer, int matchId)
		{
			buffer.Put(PacketType.Server_JoinDungeon);
			buffer.Put((ushort)matchId);
		}

		public static ushort Process(ref ByteBuffer buffer)
		{
			ushort matchId = buffer.GetUShort();
			return matchId;
		}
	}
}