using System;
using System.Collections;
using Unity.Collections;
using Unity.Collections.LowLevel.Unsafe;
using UnityEngine;


public unsafe static class PacketPool
{
    static byte** Packets;
    static object Locker = new object();

    static int Capacity;
    static int Count;

    static PacketPool()
    {
        Capacity = 2048;

        Packets = (byte**)(UnsafeUtility.Malloc(sizeof(byte*) * Capacity, sizeof(byte*), Allocator.Persistent));
    }

    [AOT.MonoPInvokeCallback(typeof(ENet.PacketFreeCallback))]
    public static void FreeCallback(ENet.Packet packet)
    {
        Free((byte*)(packet.Data));
    }

    public static void Free(byte* packet)
    {
        lock (Locker)
        {
            if (Count >= Capacity)
            {
                int oldCapacity = Capacity;

                Capacity = Capacity + Capacity;

                byte** newPackets = (byte**)(UnsafeUtility.Malloc(sizeof(byte*) * Capacity, sizeof(byte*), Allocator.Persistent));

                UnsafeUtility.MemCpy(newPackets, Packets, sizeof(byte*) * oldCapacity);

                UnsafeUtility.Free(Packets, Allocator.Persistent);

                Packets = newPackets;
            }

            Packets[Count] = packet;
            ++Count;
        }
    }

    public static byte* Allocate()
    {
        lock (Locker)
        {
            if (Count == 0)
                return (byte*)(UnsafeUtility.Malloc(2048, 8, Allocator.Persistent));

            return Packets[--Count];
        }
    }
}
