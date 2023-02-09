using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AutoPoolAfterTime : MonoBehaviour
{
	public float waitTime;

	public void Start()
    {
	    StartCoroutine(AutoPoolC());
	}

	IEnumerator AutoPoolC()
	{
		yield return new WaitForSeconds(waitTime);
		ObjectPoolManager.DestroyPooled(gameObject);
	}
}
