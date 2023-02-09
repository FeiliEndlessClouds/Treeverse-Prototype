using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ResetClusteredPrefabsTransform : MonoBehaviour
{
    Vector3[] childTrPos;
    Quaternion[] childTrRot;

    private void Awake()
    {
        childTrPos = new Vector3[transform.childCount];
        childTrRot = new Quaternion[transform.childCount];
        for (int i = 0; i < childTrPos.Length; i++)
        {
            childTrPos[i] = transform.GetChild(i).localPosition;
            childTrRot[i] = transform.GetChild(i).rotation;
            Rigidbody rb = transform.GetChild(i).GetComponent<Rigidbody>();
            if (rb != null)
                rb.Sleep();
        }
    }

    private void Start()
    {
        ResetPrefabChildTr();
    }

    public void ResetPrefabChildTr()
    {
        for (int i = 0; i < childTrPos.Length; i++)
        {
            Rigidbody rb = transform.GetChild(i).GetComponent<Rigidbody>();
            transform.GetChild(i).localPosition = childTrPos[i];
            transform.GetChild(i).rotation = childTrRot[i];
            if (rb != null)
                StartCoroutine(KeepSleeping(rb));
        }
    }

    IEnumerator KeepSleeping(Rigidbody rb)
    {
        int forcedFrames = 0;
        while (forcedFrames < 10)
        {
            forcedFrames++;
            rb.Sleep();
            yield return null;
        }
    }
}
