using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TempTrapTrigger : MonoBehaviour
{
    [SerializeField] GameObject trapObject;
	TempAbility trapAbility;

	public int health = 1;

    [SerializeField] float resetTime;
    [SerializeField] bool beenTriggered;

    [SerializeField] Material triggeringMat;
    [SerializeField] Material unTriggeringMat;

    void Awake()
    {
        trapAbility = trapObject.GetComponent<TempAbility>();
    }

    void Update()
    { 
        if(health == 0 && !beenTriggered)
        {
            trapAbility.isTriggered = true;
            beenTriggered = true;
            GetComponent<MeshRenderer>().material = triggeringMat;
            Invoke(nameof(ReOpenTheTrap), resetTime);
        }
	}

	void ReOpenTheTrap() {
        health = 1;
        beenTriggered = false;
        GetComponent<MeshRenderer>().material = unTriggeringMat;
        Debug.Log("Revived");
	}
}
