//using Sirenix.Serialization;
//using System.Collections;
//using System.Collections.Generic;
//using UnityEngine;
//using UnityEngine.EventSystems;
//using UnityEngine.UI;
//public class AbilityJoystick : VariableJoystick
//{
//    [SerializeField]
//    public PlayerInputs Input;

//    private bool m_IsDragged;
//    private Client_PlayerEntity m_Player;

//    private CreatureIndicatorsManager PlayerIndicatorsManager
//    {
//        get
//        {
//            CreatureIndicatorsManager indicatorManager = Player.GetComponentInChildren<CreatureIndicatorsManager>();

//            return indicatorManager;
//        }
//    }


//    private Client_PlayerEntity Player
//    {
//        get
//        {
//            if (m_Player == null)
//            {
//                m_Player = FindObjectOfType<Client_PlayerEntity>();
//            }

//            return m_Player;
//        }
//    }


//    protected override void Start()
//    {
//        base.Start();

//        background.GetComponent<Image>()
//            .enabled = false;

//        background.sizeDelta = new Vector2(80.0f, 80.0f);

//        GetComponent<RectTransform>()
//            .sizeDelta = new Vector2(80.0f, 80.0f);
//    }

//    public override void OnPointerDown(PointerEventData eventData)
//    {
//        base.OnPointerDown(eventData);

//        background.sizeDelta = new Vector2(256.0f, 256.0f);

//        GetComponent<RectTransform>()
//            .sizeDelta = new Vector2(256f, 256f);

//        background.GetComponent<Image>()
//            .enabled = true;

//        m_IsDragged = true;
//    }

//    public override void OnPointerUp(PointerEventData eventData)
//    {
//        background.GetComponent<Image>()
//            .enabled = false;

//        background.sizeDelta = new Vector2(80.0f, 80.0f);

//        GetComponent<RectTransform>()
//            .sizeDelta = new Vector2(80f, 80f);

//        Client_PlayerEntity player = FindObjectOfType<Client_PlayerEntity>();

//        if(player != null)
//        {
//            player.LastAim = new Vector3(Horizontal, 0.0f, Vertical);

//            player.LastInputs |= Input;
//        }

//        PlayerIndicatorsManager.HideLineIndicator();

//        m_IsDragged = false;

//        base.OnPointerUp(eventData);

//    }

//    private void LateUpdate()
//    {
//        if (m_IsDragged)
//        {
//            float angle = Mathf.Atan2(Horizontal, Vertical) * Mathf.Rad2Deg;

//            float magnitude = new Vector2(Horizontal, Vertical).magnitude;

//            if (magnitude >= 0.1f)
//            {
//                PlayerIndicatorsManager.ShowLineIndicator(angle, magnitude * 5.0f);
//            }
//            else
//            {
//                PlayerIndicatorsManager.HideLineIndicator();
//            }
//        }
//    }
//}
