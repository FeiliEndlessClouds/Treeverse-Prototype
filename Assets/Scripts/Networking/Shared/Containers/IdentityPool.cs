using System.Collections;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using UnityEngine;

public class IdentityPool<T> where T : class
{
    T[] Entities;
    int[] FreeList;

    int Head;
    int Tail;
    int Capacity;

    public T this[int id]
    {
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        get { return Entities[id]; }
    }

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public bool TryGetValue(int id, out T value)
    {
        if (id >= 0 && id <= Capacity && Entities[id] != null)
        {
            value = Entities[id];

            return true;
        }

        value = null;

        return false;
    }

    public IdentityPool()
    {
        int capacity = ushort.MaxValue;

        Entities = new T[capacity + 1];
        FreeList = new int[capacity + 1];

        for (int it = 0; it < capacity; ++it)
        {
            FreeList[it] = it + 1;
        }

        Tail = 0;

        Capacity = capacity;
    }

    public int Allocate(T entity)
    {
        int id = FreeList[Tail];

        Entities[id] = entity;

        Tail = (Tail + 1) % Capacity;
        return id;
    }

    public void Return(int id)
    {
        Entities[id] = null;

        Head = (Head + 1) % Capacity;
    }
}
