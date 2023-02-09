//using System;
//using System.Collections;
//using System.Collections.Generic;
//using UnityEngine;
//using UnityEngine.SceneManagement;

//public class LoginController : MonoBehaviour
//{
//    [SerializeField]
//    TMPro.TMP_InputField m_Email_Input;
//    [SerializeField]
//    TMPro.TMP_InputField m_Password_Input;

//    [SerializeField]
//    UnityEngine.UI.Button m_SignIn_Btn;
//    [SerializeField]
//    UnityEngine.UI.Button m_Register_Btn;

//    [SerializeField]
//    TMPro.TextMeshProUGUI m_Message_Text;

//    private void Awake()
//    {
//        /*
//        if (AuthenticationManager.Instance.HasCredentials)
//        {
//            // Auto Login

//            SceneManager.LoadScene("SampleScene");
//        }
//        */

//            m_Register_Btn.onClick.AddListener(OnRegisterClick);
//        m_SignIn_Btn.onClick.AddListener(OnSignInClick);
//    }

//    private async void OnRegisterClick()
//    {
//        m_Message_Text.text = "...Loading";

//        try
//        {
//            await AuthenticationManager.Instance.SignUpAsync(m_Email_Input.text, m_Password_Input.text);

//            m_Message_Text.text = @"Thank you!
//Your account has been successfully created. Please confirm your email!";
//        }
//        catch(Exception ex)
//        {
//            m_Message_Text.text = ex.Message;
//        }
//    }

//    private async void OnSignInClick()
//    {
//        m_Message_Text.text = "...Loading";

//        try
//        {
//            await AuthenticationManager.Instance.SignInAsync(m_Email_Input.text, m_Password_Input.text);

//            /* Create character on first login */
//            await AuthenticationManager.Instance.CreateCharacterAsync(m_Email_Input.text);

//            var characterList = await AuthenticationManager.Instance.GetCharactersAsync();

//            PlayerPrefs.SetInt("AUTO_SIGN_IN_CHARACTER_ID", characterList[0].Id);

//            PlayerPrefs.Save();

//            SceneManager.LoadScene("Matchmaking");
//        }
//        catch(Exception ex)
//        {
//            m_Message_Text.text = "Wrong email or password! " + ex.Message;
//        }
//    }
//}
