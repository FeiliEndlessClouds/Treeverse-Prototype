using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TempAnimEvent : MonoBehaviour
{
    [SerializeField] TemporaryDudeScript dude;

    public void OnCast()
    {
        dude.bCanMove = false;
        // Debug.Log("Can't move now");
    }

    public void OnHit()
    {
        // Debug.Log("OnHit is triggered");
    }

    public void OnCut()
    {
        dude.bCanMove = true;
        dude.animator.SetTrigger("CutCasting");
        // Debug.Log("OnInterrupt is triggered");
    }
}
