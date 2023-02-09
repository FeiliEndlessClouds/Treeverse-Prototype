using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerInputManager : MonoBehaviour
{
    public bool bIsActive = true;
    public RectTransform canvasRTr;
    
    public CanvasGroup joystickCG;
    private float joystickCgAlpha = 0f;

    public RectTransform joystickBase;
    public RectTransform joystick;
    private bool bJoystickActive;
    private Vector2 joystickDragPosOrig;

    public Vector3 moveVector = Vector3.zero;
    public float MoveInputMagnitude;
    public PlayerInputs abilityInput;
    public PlayerInputsStates abilityInputState;

    private Transform joystickDirTr;
    private Camera camMain;

    public bool isMessedUp;

    public float pressedTimer = 0f;

    private void Awake()
    {
        joystickCG.alpha = 0f;
    }

    public void SetJoystickTr(Transform tr)
    {
        joystickDirTr = tr;
    }
    
    private void OnEnable()
    {
        GameManager.OnGameReady += GameManager_OnGameReady;
    }

    private void GameManager_OnGameReady(GameManager gameManager)
    {
        camMain = Camera.main;
    }

    private void OnDisable()
    {
        GameManager.OnGameReady -= GameManager_OnGameReady;
    }

    private void Update()
    {
        if (!bIsActive)
            return;
#if UNITY_ANDROID || UNITY_IOS
        UpdateJoystick();
#endif
#if UNITY_EDITOR || UNITY_STANDALONE
        UpdateKeyboardMouse();
#endif
        FadeJoystick();

        if (abilityInputState == PlayerInputsStates.PRESS) pressedTimer += Time.deltaTime;
        else if (abilityInputState == PlayerInputsStates.RELEASE) pressedTimer = 0f;
        
        MoveInputMagnitude = moveVector.magnitude;
        ConvertJoystickToCameraDir();
    }

    void ConvertJoystickToCameraDir()
    {
        if (joystickDirTr)
        {
            joystickDirTr.eulerAngles = new Vector3(0, camMain.transform.eulerAngles.y + Mathf.Atan2(moveVector.x, moveVector.z) * 180 / Mathf.PI, 0);
            moveVector = joystickDirTr.forward * MoveInputMagnitude;
        }
    }

    private void FadeJoystick()
    {
        if (bJoystickActive && joystickCgAlpha < 1f)
        {
            joystickCgAlpha += Time.deltaTime*10f;
            joystickCG.alpha = joystickCgAlpha;
        }
        else if (!bJoystickActive && joystickCgAlpha > 0f)
        {
            joystickCgAlpha -= Time.deltaTime*10f;
            joystickCG.alpha = joystickCgAlpha;
        }  
    }

    private void UpdateJoystick()
    {
        if (Input.touchCount > 0)
        {
            Touch touch = Input.GetTouch(0);
            
            // Joystick
            if (touch.phase == TouchPhase.Began)
            {
                if (touch.position.x < Screen.width / 2 && touch.position.y < Screen.height / 2)
                {
                    bJoystickActive = true;

                    Vector2 normalizedPos = touch.position / new Vector2(Screen.width, Screen.height);
                    joystickBase.anchoredPosition = new Vector2(normalizedPos.x * canvasRTr.rect.width,
                        normalizedPos.y * canvasRTr.rect.height);

                    joystickDragPosOrig = touch.position;
                }
            }

            if (bJoystickActive)
            {
                if (touch.phase == TouchPhase.Ended)
                {
                    bJoystickActive = false;

                    moveVector = Vector3.zero;
                }
                else if (touch.phase != TouchPhase.Canceled)
                {
                    // Move
                    Vector2 joystickPos = touch.position - joystickDragPosOrig;
                    joystickPos = Vector2.ClampMagnitude(joystickPos, 50f);
                    joystick.anchoredPosition = joystickPos;

                    moveVector = new Vector3(joystickPos.x, 0f, joystickPos.y);
                }
            }
        }
    }

    public void PressedAbility(int whichOne)
    {
        Client_CharacterEntityVisual v = GameInfos.Instance.activeGameManager.localClient_PlayerEntity.Visual as Client_CharacterEntityVisual;
        int animId = (int)v.GetAnimId();
        if (animId >= 10 && animId < 100)
            return;

        abilityInput = (PlayerInputs)(1 << whichOne);
    }

    public void SetPlayerInputState(int state)
    {
        Client_CharacterEntityVisual v = GameInfos.Instance.activeGameManager.localClient_PlayerEntity.Visual as Client_CharacterEntityVisual;
        int animId = (int)v.GetAnimId();
        if (animId >= 10 && animId < 100)
            return;

        abilityInputState = (PlayerInputsStates)state;
    }

    private void UpdateKeyboardMouse()
    {
        if (!isMessedUp)
        {
            moveVector = new Vector3(Input.GetAxis("Horizontal"), 0f, Input.GetAxis("Vertical"));
        }
        else
        {
            moveVector = new Vector3(-Input.GetAxis("Horizontal"), 0f, -Input.GetAxis("Vertical"));
        }
        if (moveVector.magnitude > 0.1f)
            moveVector.Normalize();
        else if (moveVector.magnitude < 0.95f)
            moveVector = Vector3.zero;

        if (Input.GetKeyDown(KeyCode.Z)) PressedAbility(0);
        else if (Input.GetKeyDown(KeyCode.X)) PressedAbility(1);
        else if (Input.GetKeyDown(KeyCode.C)) PressedAbility(2);
        else if (Input.GetKeyDown(KeyCode.V)) PressedAbility(3);
        
        if (Input.GetKeyDown(KeyCode.Z) || Input.GetKeyDown(KeyCode.X) || Input.GetKeyDown(KeyCode.C) || Input.GetKeyDown(KeyCode.V))
            SetPlayerInputState(1);
        else if (Input.GetKeyUp(KeyCode.Z) || Input.GetKeyUp(KeyCode.X) || Input.GetKeyUp(KeyCode.C) || Input.GetKeyUp(KeyCode.V))
            SetPlayerInputState(2);

        // Using Mouse joystick
            
        if (Input.GetMouseButtonDown(0))
        {
            if (Input.mousePosition.x < Screen.width / 2 && Input.mousePosition.y < Screen.height / 2)
            {
                bJoystickActive = true;

                Vector2 normalizedPos = Input.mousePosition / new Vector2(Screen.width, Screen.height);
                joystickBase.anchoredPosition = new Vector2(normalizedPos.x * canvasRTr.rect.width,
                    normalizedPos.y * canvasRTr.rect.height);

                joystickDragPosOrig = Input.mousePosition;
            }
        }

        if (bJoystickActive)
        {
            if (Input.GetMouseButtonUp(0))
            {
                bJoystickActive = false;
                moveVector = Vector3.zero;
            }
            else if (Input.GetMouseButton(0))
            {
                Vector2 joystickPos = (Vector2)Input.mousePosition - joystickDragPosOrig;
                joystickPos = Vector2.ClampMagnitude(joystickPos, 50f);
                joystick.anchoredPosition = joystickPos;

                if (!isMessedUp)
                {
                    moveVector = new Vector3(joystickPos.x, 0f, joystickPos.y);
                }
                else
                {
                    moveVector = new Vector3(-joystickPos.x, 0f, -joystickPos.y);
                }
                
            }
        }
    }
}
