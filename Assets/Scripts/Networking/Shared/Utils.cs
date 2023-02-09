using System.Collections.Generic;
using UnityEngine;

public static class Utils
{
	/// <summary>
	/// Maps two integers to a positive integer: http://szudzik.com/ElegantPairing.pdf
	/// </summary>
	public static int SzudzikPair(int x, int y)
	{
		var xx = x >= 0 ? x * 2 : x * -2 - 1;
		var yy = y >= 0 ? y * 2 : y * -2 - 1;

		return (xx >= yy) ? (xx * xx + xx + yy) : (yy * yy + xx);
	}

	public static float Remap(float value, float from1, float to1, float from2, float to2)
	{
		return (Mathf.Clamp(value, from1, to1) - from1) / (to1 - from1) * (to2 - from2) + from2;
	}

	public static T GetEnumerator<T>(this T enumerator) => enumerator;
}
