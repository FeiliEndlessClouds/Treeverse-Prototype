using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TempSeed : MonoBehaviour
{
	[SerializeField] int health;
	[SerializeField] int armor;
    [SerializeField] float slowSpeed;

	void OnTriggerEnter(Collider other) {
		if (other.TryGetComponent<TemporaryDudeScript>(out var tempDude)) {
			tempDude.moveSpeed -= slowSpeed;
			tempDude.isCarryingSeed = true;
			Destroy(gameObject);
		}
	}
}
