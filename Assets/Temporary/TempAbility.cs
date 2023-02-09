using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TempAbility : MonoBehaviour
{
    [SerializeField] KeyCode toggleKey;
    public int damage;
    public int manaCost;
    [SerializeField] int cooldown;

    TemporaryDudeScript dude;

    [SerializeField] Animator animator;

    public bool isTriggered;
    
    void Awake()
    {
	    dude= transform.root.GetComponent<TemporaryDudeScript>();
	}

	void Update()
    {
	    if(Input.GetKeyDown(toggleKey) && dude.bCanMove && !isTriggered) 
        {
            isTriggered = true;
            dude.bCanMove = false;
            dude.SP -= manaCost;
            animator.SetTrigger(toggleKey.ToString());
        }	
	}

	private void OnTriggerStay(Collider other)
    {
        if (other.TryGetComponent<TemporaryDudeScript>(out var tempDude)) 
        {
            if (isTriggered) 
            {
				tempDude.HP -= damage;
				GameInfos.Instance.activeGameManager.SpawnVFX(VFXEnum.PixelHit, other.gameObject.transform);

				Debug.Log($"dealt {damage}, the target HP last {tempDude.HP}");
                isTriggered = false;
			}
        } else if (other.TryGetComponent<TempTrapTrigger>(out var tempTrap))
        {
			if (isTriggered) 
            {
				tempTrap.health -= damage;
				GameInfos.Instance.activeGameManager.SpawnVFX(VFXEnum.PixelHit, other.gameObject.transform);

				Debug.Log($"dealt {damage}, the target HP last {tempTrap.health}");
				isTriggered = false;
			}
		}
	}
}
