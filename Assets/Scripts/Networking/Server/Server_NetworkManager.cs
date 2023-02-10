using DisruptorUnity3d;
using ENet;
using System;
using System.Threading;
using UnityEngine;
using Event = ENet.Event;
using EventType = ENet.EventType;
using System.Collections;

[DefaultExecutionOrder(-10000)]
public unsafe class Server_NetworkManager : MonoBehaviour
{
	public delegate void Server_NetworkManagerAction(Server_PlayerEntity player);
	public static event Server_NetworkManagerAction OnPlayerConnected;
	public static event Server_NetworkManagerAction OnPlayerDisconnected;

	private Thread NetworkThread;

	public Server_RuleSet_MMORPG RuleSetManagerMMorpg;

	/* Ring buffer is a disruptor queue https://lmax-exchange.github.io/disruptor/disruptor.html */
	private RingBuffer<Server_Command> NetworkThreadCommands = new RingBuffer<Server_Command> (short.MaxValue);
	private RingBuffer<Server_Command> MainThreadCommands = new RingBuffer<Server_Command>(short.MaxValue);
	private Server_PlayerEntity[] PlayersByPeerID = new Server_PlayerEntity[4096]; /* 4096 is max number of peers on ENet */


	public ushort Port = 8080;
	public IdentityPool<Server_NetworkedEntity> NetworkedEntities = new IdentityPool<Server_NetworkedEntity>();
	public Server_ChunkManager ChunkManager;
	public GameObject Server_PlayerEntityPrefab;
	public GameObject Server_BotEntityPrefab;

	public int playerCount;
	public int botCount;

	private bool bServerRunning = false;

	public void SpawnBot()
    {
		Vector3 spawnPos = new Vector3(-1f * botCount, 0f, 0f);
		GameObject go = Instantiate(Server_BotEntityPrefab, spawnPos, Quaternion.identity);
		Server_CreatureEntity server_CreatureEntity = go.GetComponent<Server_CreatureEntity>();

		server_CreatureEntity.NetworkManager = this;
		server_CreatureEntity.NetworkId = NetworkedEntities.Allocate(server_CreatureEntity);

		botCount++;
	}

	public Server_PlayerEntity GetPlayerByID(int id)
	{
		Server_PlayerEntity player = NetworkedEntities[id] as Server_PlayerEntity;
		if (player != null)
			return player;
		else
		{
			Debug.LogWarning("Server_NetworkManager couldn't get player " + id + ", was a disconnect event missed?");
			return null;
		}
	}

	private unsafe void NetworkLoop()
	{
		Library.Initialize();

		try
		{
			using (Host server = new Host())
			{
				Address address = new Address();

				address.Port = Port;
				server.Create(address, 1024, 3);

				server.SetChecksumCallback(ENet.Library.CRC64);

				Event netEvent;

				bServerRunning = true;

				while (bServerRunning)
				{
					ProcessNetworkThreadCommands(server);

					bool polled = false;

					while (!polled && bServerRunning)
					{
						if (server.CheckEvents(out netEvent) <= 0)
						{
							if (server.Service(1, out netEvent) <= 0)
								break;

							polled = true;
						}

						switch (netEvent.Type)
						{
							case EventType.None:
								break;

							case EventType.Connect:
								MainThreadCommands.Enqueue(new Server_Command()
								{
									Kind = CommandKind.Connect,
									PeerPayload = netEvent.Peer
								});
								break;
							case EventType.Disconnect:
							case EventType.Timeout:
								MainThreadCommands.Enqueue(new Server_Command()
								{
									Kind = CommandKind.Disconnect,
									PeerPayload = netEvent.Peer
								});
								break;

							case EventType.Receive:
                                if(netEvent.ChannelID == 0) // Unreliable Channel
                                {
									MainThreadCommands.Enqueue(new Server_Command()
									{
										Kind = CommandKind.UnreliablePacket,
										PeerPayload = netEvent.Peer,
										PacketPayload = netEvent.Packet
									});
								}
								else
                                {
									MainThreadCommands.Enqueue(new Server_Command()
									{
										Kind = CommandKind.ReliablePacket,
										PeerPayload = netEvent.Peer,
										PacketPayload = netEvent.Packet
									});
								}
								break;
						}
					}

					server.Flush();
				}

			}
		}
		catch (Exception ex)
		{
			Debug.Log(ex);
		}
		finally
		{
			Library.Deinitialize();
		}
	}

	private void Start()
	{
		NetworkThread = new Thread(NetworkLoop)
		{
			IsBackground = true
		};

		NetworkThread.Start();
		RuleSetManagerMMorpg.Initialize(this);

#if UNITY_SERVER
		Application.targetFrameRate = Mathf.CeilToInt(1.0f / Time.fixedDeltaTime);
#endif

		Application.targetFrameRate = 30;

		Debug.Log("Server Started!");
	}

	private void ProcessNetworkThreadCommands(Host server)
	{
		while (NetworkThreadCommands.TryDequeue(out Server_Command command))
		{
			switch (command.Kind)
			{
				case CommandKind.ReliablePacket:
					command.PacketPayload.SetFreeCallback(PacketPool.FreeCallback);

					command.PeerPayload.Send(1, ref command.PacketPayload);

					command.PacketPayload.Dispose();
					break;
				case CommandKind.UnreliablePacket:
					command.PacketPayload.SetFreeCallback(PacketPool.FreeCallback);

					if (command.ChunkPayload != null && command.ChunkPayload.Peers.Count > 0)
					{
						lock (command.ChunkPayload)
						{
							server.Broadcast(0, ref command.PacketPayload, command.ChunkPayload.Peers.Values, command.ChunkPayload.Peers.Count);
						}
					}
					else
                    {
						command.PacketPayload.Dispose();
                    }
					break;
			}

			command.ChunkPayload = null;
		}
	}

	public void RemovePeer(Peer peer)
    {
		PlayersByPeerID[peer.ID] = null;
	}

	// Warning log said no await used in this function makes the async useless.
	//private async void ProcessMainThreadCommands()
	private void ProcessMainThreadCommands()
	{
		while (MainThreadCommands.TryDequeue(out Server_Command command))
		{
			switch (command.Kind)
			{
				case CommandKind.Connect:
                    {
						// SpawnPosition
						Vector3 spawnPos = new Vector3(playerCount * 1f, 0f, 0f);

						GameObject playerInstance = Instantiate(Server_PlayerEntityPrefab, spawnPos, Quaternion.identity);

						Server_PlayerEntity playerEntity = playerInstance.GetComponent<Server_PlayerEntity>();

						playerEntity.NetworkManager = this;
						playerEntity.NetworkId = NetworkedEntities.Allocate(playerEntity);
						playerEntity.Peer = command.PeerPayload;

						PlayersByPeerID[command.PeerPayload.ID] = playerEntity;

						OnPlayerConnected?.Invoke(playerEntity);

						//playerCount = FindObjectsOfType<Server_PlayerEntity>().GetLength(0);
						playerCount++;
						Debug.Log($"New peer connected with ID: {command.PeerPayload.ID}, for a total of {playerCount} players!");

						//if (IsDungeonServer)
						//	DungeonManager.JoinDungeonHandler(playerEntity);

						command.PacketPayload.Dispose();
                    }
					break;
				case CommandKind.Disconnect:
                    {
						Peer peer = command.PeerPayload;

						if(PlayersByPeerID[peer.ID] != null)
                        {
							OnPlayerDisconnected?.Invoke(PlayersByPeerID[peer.ID]);

							StartCoroutine(DelayDestroyByOneFrameC(PlayersByPeerID[peer.ID].gameObject));

							PlayersByPeerID[peer.ID] = null;

						}

						//playerCount = FindObjectsOfType<Server_PlayerEntity>().GetLength(0);
						playerCount--;
						Debug.Log($"Peer with ID {peer.ID} disconnected, for a total of {playerCount} players!");
					}
					break;

				case CommandKind.ReliablePacket:
					{
						Server_PlayerEntity playerEntity = PlayersByPeerID[command.PeerPayload.ID];
						if (playerEntity != null)
						{
							ByteBuffer buffer = ByteBuffer.CreateReader((byte*)(command.PacketPayload.Data), command.PacketPayload.Length);
							ProcessReliablePacket(ref buffer, playerEntity);
						}

						command.PacketPayload.Dispose();
					}
					break;
				case CommandKind.UnreliablePacket:
					{
						Server_PlayerEntity playerEntity = PlayersByPeerID[command.PeerPayload.ID];

						if(playerEntity != null)
                        {
							SnapshotSerializer snapshotSerializer = SnapshotSerializer.CreateReader(ByteBuffer.CreateReader((byte*)(command.PacketPayload.Data), command.PacketPayload.Length));

							playerEntity.ProcessSnapshot(ref snapshotSerializer);
						}

						command.PacketPayload.Dispose();
					}
					break;
			}

			command.ChunkPayload = null;
		}
	}

	IEnumerator DelayDestroyByOneFrameC(GameObject go)
    {
		yield return null;
		GameObject.Destroy(go);
	}

	private void ProcessReliablePacket(ref ByteBuffer buffer, Server_PlayerEntity playerEntity)
	{
		while (buffer.HasData)
		{
			PacketType packetType = buffer.GetPacketType();
			switch (packetType)
			{
                default:
					buffer.Clear();
					break;
			}
		}
	}

	public void BroadcastUnreliablePacket(ByteBuffer buffer, Server_Chunk chunk)
	{
		Packet packet = default(Packet);

		byte* data = buffer.Data;

		packet.Create((IntPtr)(data), buffer.Length, PacketFlags.NoAllocate);

		NetworkThreadCommands.Enqueue(new Server_Command()
		{
			Kind = CommandKind.UnreliablePacket,
			ChunkPayload = chunk,
			PacketPayload = packet
		});
	}

	public unsafe void SendReliablePacket(ref ByteBuffer buffer, Peer peer)
	{
		//Debug.Log("<color=lime> SERVER : </color> Sending reliable packet : " + buffer.GetPacketType().ToString() + " to peer : " + peer.ID);
		Packet packet = default(Packet);

		byte* data = buffer.Data;

		packet.Create((IntPtr)(data), buffer.Length, PacketFlags.Reliable | PacketFlags.NoAllocate);

		NetworkThreadCommands.Enqueue(new Server_Command()
		{
			Kind = CommandKind.ReliablePacket,
			PeerPayload = peer,
			PacketPayload = packet
		});

        buffer = default(ByteBuffer);
    }

	private void Update()
    {
	    ProcessMainThreadCommands();

		ChunkManager.UpdatePhysics(Time.deltaTime);

		/* */
		if (Input.GetKeyUp(KeyCode.Keypad0) && bServerRunning)
        {
			bServerRunning = false;
			Debug.Log("Server shut down");
		}
	}

    private void OnApplicationQuit()
	{
		bServerRunning = false;
	}
}
