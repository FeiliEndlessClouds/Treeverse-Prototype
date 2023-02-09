
using System;
using System.Buffers;
using System.Runtime.CompilerServices;
using UnityEngine;

public unsafe struct ByteBuffer
{
	public const int MTU = 1400;

	const float QuantizePosition = (float)(short.MaxValue) / (float)(Server_Chunk.ChunkSize) / 2.0f;
	const float DequantizePosition = 1 / QuantizePosition;

	const float QuantizeRotation = 255.0f / 360.0f;
	const float DequantizeRotation = 360.0f / 255.0f;

	const float Quantize = 32.0f;
	const float Dequantize = 1 / Quantize;

	const float QuantizeTimespan = 30.0f;
	const float DequantizeTimespan = 1.0f / Quantize;


	const double QuantizeDouble = 64.0;
	const double DequantizeDouble = 1 / Quantize;


	const double QuantizeTime = 300.0;
	const double DequantizeTime = 1 / QuantizeTime;


	const float QuantizeNormalized = 255.0f;
	const float DequantizeNormalized = 1.0f / QuantizeNormalized;


	private int ReadPosition;
	private int NextPosition;

	public byte* Data;

	public static ByteBuffer CreateReader(byte* data, int length)
	{
		ByteBuffer buffer = new ByteBuffer();

		buffer.Data = data;

		buffer.NextPosition = length;
		buffer.ReadPosition = 0;

		return buffer;
	}

	public static ByteBuffer CreateWriter(byte* data)
	{
		ByteBuffer buffer = new ByteBuffer();

		buffer.Data = data;

		buffer.NextPosition = 0;
		buffer.ReadPosition = 0;

		return buffer;
	}

	public bool IsFull
	{
		[MethodImpl(256)]
		get
		{
			return NextPosition >= MTU;
		}
	}

	public bool IsValid
    {
		[MethodImpl(256)]
		get
		{
			return Data != null;
		}
	}

	[MethodImpl(256)]
	public void Clear()
	{
		ReadPosition = 0;
		NextPosition = 0;
	}

	public int Length
	{
		[MethodImpl(256)]
		get
		{
			return NextPosition;
		}
	}

	public bool HasData
	{
		[MethodImpl(256)]
		get
		{
			return NextPosition > ReadPosition;
		}
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public void PutNormalized(float value)
	{
		Put((byte)(value * QuantizeNormalized));
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public float GetNormalizedFloat()
	{
		return GetByte() * DequantizeNormalized;
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public void Put(ulong value)
	{
		*(ulong*)(Data + NextPosition) = value;

		NextPosition += 8;
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public PacketType GetPacketType()
	{
		return (PacketType)(GetByte());
	}


	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public void Put(PacketType value)
	{
		Put((byte)(value));
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public void Put(int value)
	{
		*(int*)(Data + NextPosition) = value;

		NextPosition += 4;
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public void Put(uint value)
	{
		*(uint*)(Data + NextPosition) = value;

		NextPosition += 4;
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public void Put(ushort value)
	{
		*(ushort*)(Data + NextPosition) = value;

		NextPosition += 2;
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public void Put(float value)
	{
		PutVar((int)(value * Quantize));
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public float GetSingle()
	{
		return (float)(GetVarInt() * Dequantize);
	}


	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public float GetTimeSpan()
	{
		return (float)(GetVarUInt() * DequantizeTimespan);
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public void PutTimespan(float value)
	{
		PutVar((uint)(value * QuantizeTimespan));
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public Vector3 GetVector()
	{
		return new Vector3(GetShort() * DequantizePosition, GetShort() * DequantizePosition, GetShort() * DequantizePosition);
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public void Put(in Vector3 position)
	{
		Put((short)(position.x * QuantizePosition));
		Put((short)(position.y * QuantizePosition));
		Put((short)(position.z * QuantizePosition));
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public void PutAngle(float rot)
	{
		Put((byte)(rot * QuantizeRotation));
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public float GetAngle()
	{
		return GetByte() * DequantizeRotation;
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public void Put(short value)
	{
		*(short*)(Data + NextPosition) = value;

		NextPosition += 2;
	}


	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public void PutVar(int value)
	{
		uint zigzag = (uint)((value << 1) ^ (value >> 31));

		PutVar(zigzag);
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public void PutVar(long value)
	{
		ulong zigzag = (ulong)((value << 1) ^ (value >> 63));

		PutVar(zigzag);
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public void PutVar(ulong value)
	{
		ulong buffer;

		do
		{
			buffer = value & 0x7Fu;
			value >>= 7;

			if (value > 0)
				buffer |= 0x80u;

			Put((byte)buffer);
		}

		while (value > 0);
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public void PutVar(uint value)
	{
		uint buffer;

		do
		{
			buffer = value & 0x7Fu;
			value >>= 7;

			if (value > 0)
				buffer |= 0x80u;

			Put((byte)buffer);
		}

		while (value > 0);
	}


	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public void Put(sbyte value)
	{
		Data[NextPosition] = (byte)value;
		NextPosition++;
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public void Put(byte value)
	{
		Data[NextPosition] = value;
		NextPosition++;
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public void Put(bool value)
	{
		Data[NextPosition] = (byte)(value ? 1 : 0);

		NextPosition++;
	}

	/*
	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public void Memcpy(int srcOffset, ByteBuffer dest, int destOffset, int count)
	{
		System.Buffer.MemoryCopy(data + srcOffset, dest.data + destOffset, Connection.Mtu - destOffset, count);
		for(int it = 0; it < count; ++it)
		{
			dest.data[destOffset + it] = data[srcOffset + it];
		}
	}
	*/

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public void Put(string value)
	{
		Put(value, 80);
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public void Put(string value, int maxLength)
	{
		if (string.IsNullOrEmpty(value))
		{
			PutVar((uint)0);
			return;
		}

		int length = value.Length > maxLength ? maxLength : value.Length;

		PutVar((uint)length);

		for (int it = 0; it < length; ++it)
		{
			PutVar((uint)(value[it]));
		}
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public byte GetByte()
	{
		byte res = this.Data[this.ReadPosition];
		this.ReadPosition += 1;
		return res;
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public sbyte GetSByte()
	{
		var b = (sbyte)this.Data[this.ReadPosition];
		this.ReadPosition++;
		return b;
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public bool GetBool()
	{
		bool res = this.Data[this.ReadPosition] > 0;
		this.ReadPosition += 1;
		return res;
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public ushort GetUShort()
	{
		ushort result;

		result = *(ushort*)(Data + ReadPosition);

		this.ReadPosition += 2;

		return result;
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public short GetShort()
	{
		short result = *(short*)(Data + ReadPosition);

		this.ReadPosition += 2;

		return result;
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public long GetLong()
	{
		long result = *(long*)(Data + ReadPosition);

		this.ReadPosition += 8;

		return result;
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public ulong GetULong()
	{
		ulong result = *(ulong*)(Data + ReadPosition);

		ReadPosition += 8;

		return result;
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public int GetInt()
	{
		int result = *(int*)(Data + ReadPosition);

		this.ReadPosition += 4;

		return result;
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public uint GetUInt()
	{
		uint result = *(uint*)(Data + ReadPosition);

		this.ReadPosition += 4;

		return result;
	}


	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public int GetVarInt()
	{
		uint value = GetVarUInt();

		int zagzig = (int)((value >> 1) ^ (-(int)(value & 1)));

		return zagzig;
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public uint GetVarUInt()
	{
		uint buffer;
		uint value = 0x0u;
		int shift = 0;

		do
		{
			buffer = GetByte();

			value |= (buffer & 0x7Fu) << shift;
			shift += 7;
		}

		while ((buffer & 0x80u) > 0);

		return value;
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public string GetString(int maxLength)
	{
		int length = (int)GetVarUInt();

		if (length > maxLength)
		{
			throw new ArgumentOutOfRangeException("value length exceeded");
		}

		char[] chars = ArrayPool<char>.Shared.Rent(length);

		for (int i = 0; i < length; i++)
		{
			chars[i] = (char)GetVarUInt();
		}

		string result = new string(chars, 0, length);

		ArrayPool<char>
			.Shared
			.Return(chars, false);

		return result;
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public string GetString()
	{
		return GetString(80);
	}

	// public Item GetItem()
 //    {
	// 	string itemName = GetString();
	// 	if (itemName != null)
	// 	{
	// 		return Resources.Load<Item>(itemName);
	// 	}
	// 	else
	// 	{
	// 		return null;
	// 	}
	// }
 //
	// public void Put(Item item)
 //    {
	// 	Put(item.name);
 //    }
}
