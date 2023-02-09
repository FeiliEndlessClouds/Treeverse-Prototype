using ENet;
using UnityEngine;

public class Server_Chunk
{
    public const int ChunkSize = 32;

    public bool IsActive;
    public Server_ChunkManager ChunkManager;


    /* Time to deactivate chunk and all networked objects inside it */
    private float Lifetime;

    public QuickList<Server_NetworkedEntity> NetworkedEntities = new QuickList<Server_NetworkedEntity>(32);
    public QuickList<Server_PlayerEntity> Players = new QuickList<Server_PlayerEntity>(32);


    public Server_Chunk Prev;
    public Server_Chunk Next;

    public readonly int X;
    public readonly int Z;

    public QuickList<Peer> Peers = new QuickList<Peer>(32);

    public Server_Chunk(int x,int z)
    {
        X = x;
        Z = z;
    }

    public void AddNonPlayerEntity(Server_NetworkedEntity entity)
    {
        NetworkedEntities.Add(entity);
    }

    public void RemoveNonPlayerEntity(Server_NetworkedEntity entity)
    {
        NetworkedEntities.Remove(entity);
    }

    public void AddPlayer(Server_PlayerEntity player)
    {
        lock (this)
        {
            Peers.Add(player.Peer);
        }

        Players.Add(player);

        if (!IsActive)
        {
            ChunkManager.Activate(this);
        }
    }

    public void RemovePlayer(Server_PlayerEntity player)
    {
        lock (this)
        {
            Peers.Remove(player.Peer);
        }

        Players.Remove(player);
    }

    public void UpdatePhysics(float deltaTime)
    {
        Lifetime -= deltaTime;

        if (Lifetime < 0) /* Chunk timed out, deactivate self */
        {
            ChunkManager.Deactivate(this);
        }
        else
        {
            for (int it = 0; it < NetworkedEntities.Count; ++it)
            {
                NetworkedEntities
                    .Values[it]
                    .UpdatePhysics(deltaTime);
            }

            for (int it = 0; it < Players.Count; ++it)
            {
                Players
                    .Values[it]
                    .UpdatePhysics(deltaTime);
            }
        }
    }

    public void OnActivate()
    {
        Lifetime = 3.0f;

        for (int it = 0; it < NetworkedEntities.Count; ++it)
        {
            NetworkedEntities
                .Values[it]
                .gameObject
                .SetActive(true);
        }
    }

    public void OnDeactivate()
    {
        for (int it = 0; it < NetworkedEntities.Count; ++it)
        {
            NetworkedEntities
                .Values[it]
                .gameObject
                .SetActive(false);
        }
    }

    // <summary> Encodes the snapshot of this and all neighbors chunks to one or multiple buffers and enqueue for sending */
    public void SnapshotEncode(float deltaTime)
    {
        SnapshotSerializer serializer = new SnapshotSerializer(X * ChunkSize, Z * ChunkSize, Time.timeAsDouble);

        SnapshotEncode(ref serializer, deltaTime, this);

        Server_Chunk chunk;

        if (ChunkManager.TryGetChunkAt(X - 1, Z - 1, out chunk))
        {
            chunk.SnapshotEncode(ref serializer, deltaTime, this);
        }

        if (ChunkManager.TryGetChunkAt(X, Z - 1, out chunk))
        {
            chunk.SnapshotEncode(ref serializer, deltaTime, this);
        }

        if (ChunkManager.TryGetChunkAt(X + 1, Z - 1, out chunk))
        {
            chunk.SnapshotEncode(ref serializer, deltaTime, this);
        }

        if (ChunkManager.TryGetChunkAt(X - 1, Z, out chunk))
        {
            chunk.SnapshotEncode(ref serializer, deltaTime, this);
        }

        if (ChunkManager.TryGetChunkAt(X + 1, Z, out chunk))
        {
            chunk.SnapshotEncode(ref serializer, deltaTime, this);
        }

        if (ChunkManager.TryGetChunkAt(X - 1, Z + 1, out chunk))
        {
            chunk.SnapshotEncode(ref serializer, deltaTime, this);
        }

        if (ChunkManager.TryGetChunkAt(X, Z + 1, out chunk))
        {
            chunk.SnapshotEncode(ref serializer, deltaTime, this);
        }

        if (ChunkManager.TryGetChunkAt(X + 1, Z + 1, out chunk))
        {
            chunk.SnapshotEncode(ref serializer, deltaTime, this);
        }

        for (int it = 0; it < Players.Count; ++it)
        {
            Players
                .Values[it]
                .FlushBuffers();
        }
    }

    private unsafe void SnapshotEncode(ref SnapshotSerializer serializer, float deltaTime, Server_Chunk sourceChunk)
    {
        for (int it = 0; it < NetworkedEntities.Count; ++it)
        {
            if (!serializer.Buffer.IsValid)
            {
                serializer.Buffer = ByteBuffer.CreateWriter(PacketPool.Allocate());

                serializer.WriteHeader();
            }

            Server_NetworkedEntity entity = NetworkedEntities.Values[it];

            entity.WriteSnapshot(ref serializer);

            if (serializer.Buffer.IsFull)
            {
                ChunkManager.NetworkManager.BroadcastUnreliablePacket(serializer.Buffer, sourceChunk);

                serializer.Buffer = default(ByteBuffer);
            }
        }

        for (int it = 0; it < Players.Count; ++it)
        {
            if (!serializer.Buffer.IsValid)
            {
                serializer.Buffer = ByteBuffer.CreateWriter(PacketPool.Allocate());

                serializer.WriteHeader();
            }

            Server_PlayerEntity entity = Players.Values[it];

            entity.WriteSnapshot(ref serializer);

            if (serializer.Buffer.IsFull)
            {
                ChunkManager.NetworkManager.BroadcastUnreliablePacket(serializer.Buffer, sourceChunk);

                serializer.Buffer = default(ByteBuffer);
            }
        }

        if (serializer.Buffer.IsValid)
        {
            ChunkManager.NetworkManager.BroadcastUnreliablePacket(serializer.Buffer, sourceChunk);

            serializer.Buffer = default(ByteBuffer);
        }

        ChunkManager.Activate(this);

        Lifetime = 3.0f;
    }
}
