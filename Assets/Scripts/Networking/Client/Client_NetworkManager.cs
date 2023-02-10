using DisruptorUnity3d;
using ENet;
using System;
using System.Threading;
using Networking.Shared.Packets;
//using ParrelSync;
using UnityEngine;
using UnityEngine.SceneManagement;
using Event = ENet.Event;
using EventType = ENet.EventType;
using System.Collections.Generic;

[DefaultExecutionOrder(-10000)]
public class Client_NetworkManager : MonoBehaviour
{
	private Thread NetworkThread;
	private Peer Peer;
	private volatile bool IsQuitRequested;
	private bool Connected = false;

	public string IpAddress = "127.0.0.1";
	public ushort Port = 8080;

	public GameObject Client_PropEntityPrefab;
	public GameObject Client_PlayerEntityPrefab;
	public GameObject Client_CreatureEntityPrefab;

	//public Client_VisualPrefabFactory VisualFactory;

	public int NetworkPlayerId = -1;

	public ByteBuffer UnreliableBuffer;
	public ByteBuffer ReliableBuffer;

	public uint RoundTripTime;

	/* Ring buffer is a disruptor queue https://lmax-exchange.github.io/disruptor/disruptor.html */
	private RingBuffer<Client_Command> NetworkThreadCommands = new RingBuffer<Client_Command>(short.MaxValue);
	private RingBuffer<Client_Command> MainThreadCommands = new RingBuffer<Client_Command>(short.MaxValue);

	private Client_NetworkedEntity[] Entities = new Client_NetworkedEntity[ushort.MaxValue];
	private List<Client_CharacterEntity> characterEntities = new List<Client_CharacterEntity>();
	
	private unsafe void NetworkLoop()
	{
		if (!Connected)
			Library.Initialize();

		try
		{
			using (Host client = new Host())
			{
				Address address = new Address();

				address.SetHost(IpAddress);
				address.Port = 8080;
				client.Create(1, 3);

				client.SetChecksumCallback(Library.CRC64);

				Peer = client.Connect(address, 3);
				Connected = true;

				Event netEvent;

				while (true)
				{
					ProcessNetworkThreadCommands(client);

					bool polled = false;

					while (!polled)
					{
						if (client.CheckEvents(out netEvent) <= 0)
						{
							if (client.Service(1, out netEvent) <= 0)
								break;

							polled = true;
						}

						switch (netEvent.Type)
						{
							case EventType.None:
								break;

							case EventType.Connect:
								Debug.Log("CLIENT DETECTS CONNECTS");
								break;

							case EventType.Disconnect:
								Debug.Log("CLIENT DETECTS DISCONNECT");
								break;

							case EventType.Timeout:
								break;

							case EventType.Receive:
								if (netEvent.ChannelID == 0) // Unreliable Channel
								{
									MainThreadCommands.Enqueue(new Client_Command()
									{
										Kind = CommandKind.UnreliablePacket,
										PeerPayload = netEvent.Peer,
										PacketPayload = netEvent.Packet
									});
								}
								else
								{
									MainThreadCommands.Enqueue(new Client_Command()
									{
										Kind = CommandKind.ReliablePacket,
										PeerPayload = netEvent.Peer,
										PacketPayload = netEvent.Packet
									});
								}
								break;
						}
					}

					/* Graceful disconnection */
					if (IsQuitRequested)
					{
						if (Peer.State == PeerState.Connected)
						{

							Peer.Disconnect(0);

						}

						if (Peer.State == PeerState.Disconnected)
						{
							NetworkPlayerId = -1;
							IsQuitRequested = false;
							return;
						}
					}

					RoundTripTime = Peer.RoundTripTime;

					client.Flush();
				}
			}
		}
		finally
		{
			if (Connected)
				Library.Deinitialize();
			else
			{
				Thread.Sleep(5000);
				NetworkLoop();
			}
		}
	}

    private unsafe void Start()
    {
		NetworkThread = new Thread(NetworkLoop)
		{
			IsBackground = true
		};

		NetworkThread.Start();

		UnreliableBuffer = ByteBuffer.CreateWriter(PacketPool.Allocate());

		// AuthenticateAsync();

		Application.targetFrameRate = 30;

		GameInfos.Instance.activeGameManagerGameOfSeed.client_NetworkManager = this;
	}

    // SUPABASE stuff
    //private async void AuthenticateAsync()
    //   {
    //	try
    //	{
    //		var accessToken = await AuthenticationManager.Instance.GetAccessToken();
    //		var characterId = AuthenticationManager.Instance.GetCharacterId();
    //	}
    //	catch(Exception)
    //       {
    //		Debug.Log("Error while authenticating");
    //       }
    //}

    private void OnApplicationPause(bool pause)
    {
		if (pause)
		{
            IsQuitRequested = true;

            NetworkThread.Join(1000);
        }
    }

    private void OnDestroy()
    {
		IsQuitRequested = true;
	}

	private void OnApplicationQuit()
	{
		IsQuitRequested = true;

		NetworkThread.Join(1000);
	}

	public void DisconnectImmediately(Action callback)
	{
		if (Peer.State == PeerState.Connected)
		{
			Peer.DisconnectNow(0);
			NetworkPlayerId = -1;
		}
	}

	public Client_NetworkedEntity GetEntityByNetworkID(int networkID)
    {
		return Entities[networkID];
	}

	public Client_CharacterEntity GetCharacterEntityByNetworkID(int networkID)
    {
		for (int i = 0; i < characterEntities.Count; i++)
		{
			if (characterEntities[i].networkId == networkID)
			{
				return characterEntities[i];
			}
		}
		return null;
    }

    private void ProcessSnapshot(ref SnapshotSerializer serializer)
    {
		if (NetworkPlayerId > 0)
		{
			while (serializer.Buffer.HasData)
			{
				SnapshotFlags flags = (SnapshotFlags)(serializer.Buffer.GetByte());

				int networkId = serializer.Buffer.GetUShort();
				int visualId = serializer.Buffer.GetUShort();

				Client_NetworkedEntity entity = Entities[networkId];

				if ((flags & SnapshotFlags.IsDestroyed) == SnapshotFlags.IsDestroyed)
				{
					if(entity != null)
                    {
						entity.ReadSnapshot(ref serializer, flags);

						entity.Destroy();

						Entities[networkId] = null;
					}
					else
                    {
						/* Discard data when destroyed */
						serializer.Buffer.GetVector();
						serializer.Buffer.GetAngle();
					}
				}
				else
				{
					if (entity == null)
					{
						GameObject instance;

						GameObject prefab = null;

						if ((flags & SnapshotFlags.IsCharacter) == SnapshotFlags.IsCharacter)
						{
							/* character entity */
							if (networkId == NetworkPlayerId)
							{
								prefab = Client_PlayerEntityPrefab;
							}
							else
							{
								prefab = Client_CreatureEntityPrefab;
							}
						}
						else
						{
							prefab = Client_PropEntityPrefab;
						}

						instance = Instantiate(prefab);

						entity = instance.GetComponent<Client_NetworkedEntity>();

						entity.Manager = this;
						//entity.VisualId = visualId;
						entity.VisualRef = (VisualPrefabName)visualId;

						Entities[networkId] = entity;
						Entities[networkId].networkId = networkId;

						if (networkId == NetworkPlayerId)
							GameInfos.Instance.activeGameManagerGameOfSeed.LocalClientPlayerInstantiated(Entities[networkId] as Client_PlayerEntity);

						if ((flags & SnapshotFlags.IsCharacter) == SnapshotFlags.IsCharacter)
						{
							characterEntities.Add(entity as Client_CharacterEntity);
							GameInfos.Instance.activeGameManagerGameOfSeed.ClientPlayerInstantiated(Entities[networkId] as Client_CharacterEntity);
						}
						else
                        {
							GameInfos.Instance.activeGameManagerGameOfSeed.PropsInstantiated(entity);
						}
					}

					if (entity != null)
					{
						entity.ReadSnapshot(ref serializer, flags);
					}
				}
			}
		}
	}

	public void RemoveCharacterEntity(Client_CharacterEntity player)
    {
		characterEntities.Remove(player);
		characterEntities.TrimExcess();
	}

	private void ProcessReliablePacket(ref ByteBuffer buffer)
    {
	    while (buffer.HasData)
	    {
		    PacketType packetType = buffer.GetPacketType();
			//Debug.Log("<color=yellow>CLIENT : </color>Received reliable packet of type : " + packetType + ", I am client with NetworkPlayerId : " + NetworkPlayerId);
			switch (packetType)
		    {
			    case PacketType.Client_SetPlayerId:
				    Client_SetPlayerIdPacketProcessor.Process(ref buffer, this);
				    break;
			    case PacketType.Client_SetItemAt:
			    {
				    Server_RuleSetDataPacketProcessor.ProcessSetEffect(ref buffer);
			    }
				    break;
				case PacketType.Server_RuleSetData:
				{
					Server_RuleSetDataPacketProcessor.ProcessRuleSetData(ref buffer, NetworkPlayerId);
				}
					break;
				case PacketType.Client_SetPlayerClass:
				{
					Debug.LogWarning("Client should not send Client package to Client");
				}
					break;
				case PacketType.Server_SetPlayerClass:
				{
					Server_RuleSetDataPacketProcessor.ProcessSetClass(ref buffer);
				}
					break;
				case PacketType.Server_SetSeedHolder:
				{
					Server_RuleSetDataPacketProcessor.ProcessSetSeedHolder(ref buffer);
				}
					break;
			    case PacketType.Server_TreeExplode:
			    {
				    Server_RuleSetDataPacketProcessor.ProcessTreeExplode(ref buffer);
			    }
				    break;
                case PacketType.Server_SendMessage:
                {
                    GameInfos.Instance.activeGameManagerGameOfSeed.RefreshChatBoard(ref buffer);
                }
                    break;
                //case PacketType.Server_ChangeScene:
                //   {
                //    var (item1, item2, vector3) = ServerChangeScenePacketProcessor.Process(ref buffer);


                //    SceneManager.LoadSceneAsync(item1, item2 ? LoadSceneMode.Additive : LoadSceneMode
                //	    .Single).completed += (AsyncOperation op) =>
                //    {
                //	    var dungeon = GameObject.Find("Root");
                //	    dungeon.name = "Dungeon" + vector3;
                //	    dungeon.transform.position = vector3;
                //    };
                //   }
                //    break;
                default:
				    buffer.Clear();
				    break;
		    }

	    }
    }

	private unsafe void ProcessMainThreadCommands()
	{
		while (MainThreadCommands.TryDequeue(out Client_Command command))
		{
			switch (command.Kind)
			{
				case CommandKind.UnreliablePacket:
					{
						SnapshotSerializer snapshotSerializer = SnapshotSerializer.CreateReader(ByteBuffer.CreateReader((byte*)(command.PacketPayload.Data), command.PacketPayload.Length));

						ProcessSnapshot(ref snapshotSerializer);

						command.PacketPayload.Dispose();
					}
					break;
				case CommandKind.ReliablePacket:
                    {
						ByteBuffer buffer = ByteBuffer.CreateReader((byte*)(command.PacketPayload.Data), command.PacketPayload.Length);

						ProcessReliablePacket(ref buffer);

						command.PacketPayload.Dispose();
					}
					break;
			}
		}
	}


	public void BeginReliablePacket()
	{
		if (!ReliableBuffer.IsValid)
		{
			unsafe
			{
				ReliableBuffer = ByteBuffer.CreateWriter(PacketPool.Allocate());
			}
		}
	}

	public unsafe void FlushBuffers(ref ByteBuffer buffer)
	{
		if (buffer.IsValid)
		{
			Packet packet = default(Packet);

			byte* data = buffer.Data;

			packet.Create((IntPtr)(data), buffer.Length, PacketFlags.Reliable | PacketFlags.NoAllocate);

			NetworkThreadCommands.Enqueue(new Client_Command()
			{
				Kind = CommandKind.ReliablePacket,
				PeerPayload = Peer,
				PacketPayload = packet
			});

			buffer = default;
		}
	}

	private void ProcessNetworkThreadCommands(Host client)
	{
		while (NetworkThreadCommands.TryDequeue(out Client_Command command))
		{
			switch (command.Kind)
			{
				case CommandKind.ReliablePacket:
					command.PeerPayload.Send(1, ref command.PacketPayload);
					command.PacketPayload.Dispose();
					break;
				case CommandKind.UnreliablePacket:
					command.PeerPayload.Send(0, ref command.PacketPayload);
					break;
			}
		}
	}

	private void Update()
    {
		ProcessMainThreadCommands();

        if (Input.GetKey(KeyCode.LeftShift) && Input.GetKey(KeyCode.LeftControl) && Input.GetKeyDown(KeyCode.O))
        {
            IsQuitRequested = true;
        }
		/*
        if (Input.GetKeyDown(KeyCode.P))
		{
			if (NetworkPlayerId == -1)
			{
				NetworkThread.Join();
				Start();
			}
				// SceneManager.LoadScene(SceneManager.GetActiveScene().ToString());
		}*/
    }

    private unsafe void LateUpdate()
    {
		if (UnreliableBuffer.Length > 0)
		{
			Packet packet = default(Packet);

			packet.Create((IntPtr)(UnreliableBuffer.Data), UnreliableBuffer.Length, PacketFlags.None);

			NetworkThreadCommands.Enqueue(new Client_Command()
			{
				Kind = CommandKind.UnreliablePacket,
				PacketPayload = packet,
				PeerPayload = Peer
			});

			UnreliableBuffer.Clear();
		}
	}
}
