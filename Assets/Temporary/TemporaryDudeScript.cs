using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TemporaryDudeScript : MonoBehaviour
{
    public int HP = 100;
    public int SP = 100;
    public float moveSpeed = 6f;

    public bool bCanMove = true;

    private GameManager gm;
    private CharacterController cc;
    public Transform rawDir;
    public Camera camMain;
    private readonly float rotSpeed = 15f;

    public Animator animator;

    public bool isCarryingSeed;

    private void Start()
    {
        cc = GetComponent<CharacterController>();
    }

    private void Update()
    {
        if (!bCanMove)
            return;

        if (gm == null)
            gm = GameInfos.Instance.activeGameManager;

        if (camMain == null)
            camMain = Camera.main;

        if (gm.playerInputManager.MoveInputMagnitude > 0.2f)
        {
            rawDir.eulerAngles = new Vector3(0, camMain.transform.eulerAngles.y + Mathf.Atan2(gm.playerInputManager.moveVector.x, gm.playerInputManager.moveVector.z) * 180 / Mathf.PI, 0);
            transform.rotation = Quaternion.Lerp(transform.rotation, rawDir.rotation, Time.deltaTime * rotSpeed);
            animator.SetBool("isRunning", true);
        }
        else
        {
            animator.SetBool("isRunning", false);
        }

        cc.Move((gm.playerInputManager.MoveInputMagnitude > 1f ? gm.playerInputManager.moveVector.normalized : gm.playerInputManager.moveVector) * Time.deltaTime * moveSpeed);
    }

    /*
    private void LateUpdate()
    {
        if (gm.GetComponent<PlayerInputManager>().MoveInputMagnitude > 0)
        {
            animator.SetBool("isRunning", true);
        }
        else
        {
            animator.SetBool("isRunning", false);
        }
    }
    */
}
