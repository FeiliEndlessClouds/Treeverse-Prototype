using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GizmoScope : MonoBehaviour
{
	public Vector3 centerPosition;
	public float radius;

	public enum AbilityType 
	{
		circle,
		projectile
	}
	public AbilityType type;

	private void OnDrawGizmos() {
		Gizmos.DrawWireSphere(centerPosition, radius);
	}
}