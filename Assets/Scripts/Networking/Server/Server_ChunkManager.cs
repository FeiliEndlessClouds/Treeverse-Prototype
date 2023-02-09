using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Server_ChunkManager : MonoBehaviour
{
	/* Chunks indexed by szudzikPair. It auto grows */
	private Server_Chunk[] Chunks = new Server_Chunk[32];

	/* Double linked list of chunks, O(1) to remove from middle, O(1) append and possible to remove nodes from middle while iteraring */
	private Server_Chunk ActiveChunks;

	public Server_NetworkManager NetworkManager;

	public bool TryGetChunkAt(int szudzik, out Server_Chunk chunk)
	{
		if (szudzik >= Chunks.Length)
		{
			chunk = null;

			return false;
		}

		chunk = Chunks[szudzik];

		return chunk != null;
	}

	public bool TryGetChunkAt(int x, int z, out Server_Chunk chunk)
	{
		return TryGetChunkAt(Utils.SzudzikPair(x, z), out chunk);
	}

	public Server_Chunk GetChunkAt(int x, int z)
	{
		int szudzik = Utils.SzudzikPair(x, z);

		Server_Chunk chunk;

		if (szudzik >= Chunks.Length)
		{
			int newLength = Chunks.Length * 2;

			while(szudzik >= newLength)
            {
				newLength *= 2;
            }

			Array.Resize(ref Chunks, newLength);
		}

		if (Chunks[szudzik] == null)
		{
			chunk = new Server_Chunk(x, z) { ChunkManager = this };

			return Chunks[szudzik] = chunk;
		}
		else
		{
			return Chunks[szudzik];
		}
	}

	public void Activate(Server_Chunk chunk)
	{
		if (!chunk.IsActive)
		{
			if (ActiveChunks != null)
			{
				ActiveChunks.Prev = chunk;
			}

			chunk.Next = ActiveChunks;
			chunk.Prev = null;

			ActiveChunks = chunk;

			chunk.IsActive = true;

			chunk.OnActivate();
		}
	}

	public void Deactivate(Server_Chunk chunk)
	{
		if (chunk.IsActive)
		{
			if (chunk.Next != null)
			{
				chunk.Next.Prev = chunk.Prev;
			}

			if (chunk.Prev != null)
			{
				chunk.Prev.Next = chunk.Next;
			}

			if (chunk == ActiveChunks)
			{
				ActiveChunks = chunk.Next;
			}

			chunk.Prev = null;

			chunk.IsActive = false;

			chunk.OnDeactivate();
		}
	}

	public IEnumerator<Server_NetworkedEntity> GetNetworkedEntitiesVisibleFor(int x, int z)
	{ 
		Server_Chunk chunk;

		if (TryGetChunkAt(x, z, out chunk))
		{
			for (int it = 0; it < chunk.NetworkedEntities.Count; ++it)
			{
				yield return chunk.NetworkedEntities
					.Values[it];
			}
		}

		if (TryGetChunkAt(x - 1, z - 1, out chunk))
		{
			for (int it = 0; it < chunk.NetworkedEntities.Count; ++it)
			{
				yield return chunk.NetworkedEntities
					.Values[it];
			}
		}

		if (TryGetChunkAt(x, z - 1, out chunk))
		{
			for (int it = 0; it < chunk.NetworkedEntities.Count; ++it)
			{
				yield return chunk.NetworkedEntities
					.Values[it];
			}
		}

		if (TryGetChunkAt(x + 1, z - 1, out chunk))
		{
			for (int it = 0; it < chunk.NetworkedEntities.Count; ++it)
			{
				yield return chunk.NetworkedEntities
					.Values[it];
			}
		}

		if (TryGetChunkAt(x - 1, z, out chunk))
		{
			for (int it = 0; it < chunk.NetworkedEntities.Count; ++it)
			{
				yield return chunk.NetworkedEntities
					.Values[it];
			}
		}

		if (TryGetChunkAt(x + 1, z, out chunk))
		{
			for (int it = 0; it < chunk.NetworkedEntities.Count; ++it)
			{
				yield return chunk.NetworkedEntities
					.Values[it];
			}
		}

		if (TryGetChunkAt(x - 1, z + 1, out chunk))
		{
			for (int it = 0; it < chunk.NetworkedEntities.Count; ++it)
			{
				yield return chunk.NetworkedEntities
					.Values[it];
			}
		}

		if (TryGetChunkAt(x, z + 1, out chunk))
		{
			for (int it = 0; it < chunk.NetworkedEntities.Count; ++it)
			{
				yield return chunk.NetworkedEntities
					.Values[it];
			}
		}

		if (TryGetChunkAt(x + 1, z + 1, out chunk))
		{
			for (int it = 0; it < chunk.NetworkedEntities.Count; ++it)
			{
				yield return chunk.NetworkedEntities
					.Values[it];
			}
		}
	}

    public void UpdatePhysics(float deltaTime)
    {
		for (Server_Chunk chunk = ActiveChunks; chunk != null; chunk = chunk.Next)
		{
			chunk.UpdatePhysics(deltaTime);
		}

		for (Server_Chunk chunk = ActiveChunks; chunk != null; chunk = chunk.Next)
		{
			chunk.SnapshotEncode(deltaTime);
		}
	}

}
