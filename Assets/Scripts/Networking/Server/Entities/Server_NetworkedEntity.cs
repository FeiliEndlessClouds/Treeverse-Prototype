using System;
using UnityEngine;

public class Server_NetworkedEntity : MonoBehaviour, IEquatable<Server_NetworkedEntity>
{
    protected Server_Chunk CurrentChunk;

    [NonSerialized]
    public int NetworkId;

    public VisualPrefabName VisualId;

    public Server_NetworkManager NetworkManager;

    protected SnapshotFlags Flags;

    private float DestroyTimeout = 0.5f;

    private void Start()
    {
        Initialize();
    }

    public bool IsDestroyed
    {
        get { return (Flags & SnapshotFlags.IsDestroyed) == SnapshotFlags.IsDestroyed; }

        protected set
        {
            if (value)
            {
                Flags = Flags | SnapshotFlags.IsDestroyed;

            }
            else
            {
                Flags = Flags & ~SnapshotFlags.IsDestroyed;
            }
        }
    }

    public virtual void Initialize()
    {
        Flags = SnapshotFlags.None;

        IsDestroyed = false;

        Vector3 position = transform.position;

        CurrentChunk = NetworkManager.ChunkManager.GetChunkAt(Mathf.RoundToInt(position.x / Server_Chunk.ChunkSize), Mathf.RoundToInt(position.z / Server_Chunk.ChunkSize));

        OnAddTo(CurrentChunk);
    }

    // <summary> Called by Chunk manager, it runs before snapshot code and ensures snapshot is always using fresh state </summary>
    public virtual void UpdatePhysics(float deltaTime) {
        if (IsDestroyed)
        {
            DestroyTimeout -= deltaTime;

            if(DestroyTimeout <= 0.0f)
            {
                Destroy(gameObject);
            }
        }
    }

    public virtual void WriteSnapshot(ref SnapshotSerializer serializer)
    {
        serializer.Buffer.Put((byte)(Flags));
        serializer.Buffer.Put((ushort)(NetworkId));
        serializer.Buffer.Put((ushort)(VisualId));
        serializer.Buffer.Put(serializer.EncodePosition(transform.position));
        serializer.Buffer.PutAngle(transform.rotation.eulerAngles.y);
    }

    protected virtual void OnAddTo(Server_Chunk chunk)
    {
        /* On Change chunk */

        chunk.AddNonPlayerEntity(this);
    }

    protected virtual void OnRemoveFrom(Server_Chunk chunk)
    {
        chunk.RemoveNonPlayerEntity(this);
    }

    protected virtual void OnPositionChanged()
    {
        Vector3 position = transform.position;

        int x = Mathf.RoundToInt(position.x / Server_Chunk.ChunkSize);
        int z = Mathf.RoundToInt(position.z / Server_Chunk.ChunkSize);

        if (x != CurrentChunk.X || z != CurrentChunk.Z)
        {
            OnRemoveFrom(CurrentChunk);

            CurrentChunk = NetworkManager.ChunkManager.GetChunkAt(Mathf.RoundToInt(position.x / Server_Chunk.ChunkSize), Mathf.RoundToInt(position.z / Server_Chunk.ChunkSize));

            OnAddTo(CurrentChunk);
        }
    }

    public virtual void OnDestroy()
    {
        if(CurrentChunk != null)
        {
            OnRemoveFrom(CurrentChunk);
        }
    }

    protected void NetworkDestroy()
    {
        IsDestroyed = true;
        Debug.Log("SERVER : Setting entity to be destroyed : " + NetworkId);
        /* Time to send info about destruction to client */
        DestroyTimeout = 0.5f;
    }

    public bool Equals(Server_NetworkedEntity other)
    {
        return this == other;
    }
}
