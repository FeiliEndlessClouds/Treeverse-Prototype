using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TemporaryAbility : MonoBehaviour
{
    public KeyCode toggleKey;
    [Range(0.2f, 1000f)] public float fireInterval = 1f;
    public int HPModifier = -1;
    public int SpCost = 0;

    private float lastFireTime;
    private bool bActive = false;
    public bool bColCanTrigger = false;
    private float activeColTimer = 0f;
    private TemporaryDudeScript myDudeScript;

    private void Awake()
    {
        myDudeScript = transform.root.GetComponent<TemporaryDudeScript>();
    }

    private void Update()
    {
        if (Input.GetKeyDown(toggleKey))
            bActive = !bActive;

        if (!bActive)
            return;

        if (!bColCanTrigger)
        {
            if (Time.timeSinceLevelLoad > lastFireTime)
            {
                bColCanTrigger = true;
                lastFireTime = Time.timeSinceLevelLoad + fireInterval;
                activeColTimer = 0f;
            }
        }
        else
        {
            if (activeColTimer < 0.2f)
            {
                activeColTimer += Time.deltaTime;
                return;
            }
            else
                bColCanTrigger = false;
        }
    }

    private void OnTriggerStay(Collider other)
    {
        if (!bColCanTrigger)
            return;

        if (other.gameObject.layer == LayerMask.NameToLayer("Player") && other.gameObject.GetInstanceID() != transform.root.gameObject.GetInstanceID())
        {
            myDudeScript.SP -= SpCost;

            TemporaryDudeScript tempDudeScript = other.gameObject.GetComponent<TemporaryDudeScript>();
            if(tempDudeScript != null) {
				tempDudeScript.HP += HPModifier;

				GameInfos.Instance.activeGameManager.SpawnVFX(VFXEnum.PixelHit, other.gameObject.transform);
				GameInfos.Instance.activeGameManager.DisplayLog(transform.root.gameObject.name + " attacked " + other.gameObject.name +
					", their HP is " + tempDudeScript.HP + " it cost : " + SpCost + " SP");

				activeColTimer = 0f;
				bColCanTrigger = false;
			}
        }
    }
}
