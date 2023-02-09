using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// Container supporting list-like behaviours.
/// </summary>
/// <typeparam name="T">Type of the elements in the list.</typeparam>
public struct QuickList<T> where T: IEquatable<T>
{
    public T[] Values;
    public int Count;

    public QuickList(int capacity)
    {
        Values = new T[capacity];
        Count = 0;
    }
    public void Add(T value)
    {
        if (Count >= Values.Length)
            Array.Resize(ref Values, Values.Length * 2);

        Values[Count] = value;

        ++Count;
    }
    public void Remove(T value)
    {
        for (int it = 0; it < Count; ++it)
        {
            if (Values[it].Equals(value))
            {
                Values[it] = Values[Count - 1];

                Values[Count - 1] = default(T);

                Count--;

                return;
            }
        }
    }
}

