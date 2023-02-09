using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TempDudeController : MonoBehaviour
{
    //[SerializeField] GameObject character;
    [SerializeField] PlayerInputManager inputManager;
    [SerializeField] Animator animator;

	// [SerializeField] TemporaryDudeScript.MotionState dudeMotion;


	void LateUpdate()
    {
        //character.transform.SetPositionAndRotation(transform.position, transform.rotation);

        if (inputManager.MoveInputMagnitude > 0) {
            animator.SetBool("isRunning", true);
        }
        else 
        {
			animator.SetBool("isRunning", false);
		}
	}
    
}
