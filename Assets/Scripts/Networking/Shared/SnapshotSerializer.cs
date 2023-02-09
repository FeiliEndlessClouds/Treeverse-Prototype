using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public struct SnapshotSerializer
{
    private const int TicksPerSecond = 300;

    public ByteBuffer Buffer;

    public readonly int OffsetX;
    public readonly int OffsetZ;
    public readonly uint QuantizedTimestamp;

    public double Timestamp => (double)(QuantizedTimestamp) / (double)(TicksPerSecond);

    public Vector3 EncodePosition(in Vector3 globalPosition)
    {
        return new Vector3(globalPosition.x - OffsetX, globalPosition.y, globalPosition.z - OffsetZ);
    }

    public Vector3 DecodePosition(in Vector3 localPosition)
    {
        return new Vector3(localPosition.x + OffsetX, localPosition.y, localPosition.z + OffsetZ);
    }

    public static SnapshotSerializer CreateReader(ByteBuffer buffer)
    {
        uint timestamp = buffer.GetUInt();

        int offsetX = buffer.GetShort();
        int offsetZ = buffer.GetShort();

        return new SnapshotSerializer(offsetX, offsetZ, timestamp) { Buffer = buffer };
    }

    public void WriteHeader()
    {
        Buffer.Put(QuantizedTimestamp);
        
        Buffer.Put((short)(OffsetX));
        Buffer.Put((short)(OffsetZ));
    }

    public SnapshotSerializer(int offsetX, int offsetZ, double timestamp)
    {
        Buffer = default(ByteBuffer);

        OffsetX = offsetX;
        OffsetZ = offsetZ;

        QuantizedTimestamp = (uint)(timestamp * TicksPerSecond);
    }

    public SnapshotSerializer(int offsetX, int offsetZ, uint quantizedTimestamp)
    {
        Buffer = default(ByteBuffer);

        OffsetX = offsetX;
        OffsetZ = offsetZ;

        QuantizedTimestamp = quantizedTimestamp;
    }
}
