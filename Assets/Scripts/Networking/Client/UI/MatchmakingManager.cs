//using System;
//using System.Collections;
//using Treeverse.Models;
//using UnityEngine;
//using UnityEngine.SceneManagement;

//public class MatchmakingManager : MonoBehaviour
//{
//    public GameObject WaitingForMatchRoot;
//    public GameObject JoinMatchRoot;

    
//    public TMPro.TextMeshProUGUI DurationText;

//    private bool m_IsWaitingForMatch;
//    private Supabase.Realtime.Channel m_Channel; 

//    IEnumerator WaitForMatch()
//    {
//        DateTime startTime = DateTime.Now;

//        DateTime lastSeenUpdatedAt = DateTime.Now;

//        WaitForMatchFound();

//        while (m_IsWaitingForMatch)
//        {
//            TimeSpan span = DateTime.Now.Subtract(startTime);

//            DurationText.text = span.ToString("mm\\:ss");

//            /* Update last seen every 15 seconds */
//            if(DateTime.Now.Subtract(lastSeenUpdatedAt) >= TimeSpan.FromSeconds(15))
//            {
//                UpdateLastSeen();

//                lastSeenUpdatedAt = DateTime.Now;
//            }

//            yield return new WaitForSeconds(1.0f);
//        }

//        if (m_Channel != null)
//        {
//            m_Channel.Unsubscribe();

//            m_Channel = null;
//        }
//    }

//    private async void WaitForMatchFound()
//    {
//        if (m_Channel != null)
//        {
//            m_Channel.Unsubscribe();

//            m_Channel = null;
//        }

//        if (m_IsWaitingForMatch)
//        {
//            var supabaseClient = await AuthenticationManager
//                .Instance
//                .GetClientAsync();

//            m_Channel = await supabaseClient.From<WaitingForMatchModel>()
//                .On(Supabase.Client.ChannelEventType.All, Channel_OnUpdate);
//        }
//    }

//    private async void Channel_OnUpdate(object sender, Supabase.Realtime.SocketResponseEventArgs e)
//    {
//        if(e.Response.Event == Supabase.Realtime.Constants.EventType.Update)
//        {
//            WaitingForMatchModel model = e.Response.Model<WaitingForMatchModel>();

//            if(model.MatchFound != null)
//            {
//                string matchFound = model.MatchFound;

//                var supabaseClient = await AuthenticationManager
//                    .Instance
//                    .GetClientAsync();

//                await supabaseClient.From<WaitingForMatchModel>()
//                   .Filter("user_id", Postgrest.Constants.Operator.Equals, supabaseClient.Auth.CurrentUser.Id)
//                   .Delete();

//                UnityMainThreadDispatcher.Instance().Enqueue(() =>
//                {
//                    m_Channel.Unsubscribe();

//                    m_Channel = null;

//                    AuthenticationManager.Instance.MatchId = model.MatchFound;
//                    SceneManager.LoadScene("Preparation");
//                });
//            }
//        }
//    }

//    private async void UpdateLastSeen()
//    {
//        if (m_IsWaitingForMatch)
//        {
//            var supabaseClient = await AuthenticationManager.Instance.GetClientAsync();

//           await supabaseClient.Postgrest.Rpc("update_last_seen", new System.Collections.Generic.Dictionary<string, object>());
//        }
//    }

//    public async void CancelWaitForMatch()
//    {
//        if (m_IsWaitingForMatch)
//        {
//            var supabaseClient = await AuthenticationManager.Instance.GetClientAsync();

//            await supabaseClient.From<WaitingForMatchModel>()
//                .Filter("user_id", Postgrest.Constants.Operator.Equals, supabaseClient.Auth.CurrentUser.Id)
//                .Delete();

//            WaitingForMatchRoot.SetActive(false);
//            JoinMatchRoot.SetActive(true);

//            m_IsWaitingForMatch = false;
//        }
//    }

//    public void JoinTrioMatch()
//    {
//        JoinOrCreateMatch(3);
//    }

//    public void JoinDuoMatch()
//    {
//        JoinOrCreateMatch(2);
//    }

//    public void JoinSoloMatch()
//    {
//        JoinOrCreateMatch(1);
//    }

//    async void JoinOrCreateMatch(int playerCount)
//    {
//        var supabaseClient = await AuthenticationManager.Instance.GetClientAsync();

//        var response = await supabaseClient.Postgrest.Rpc("join_match", new System.Collections.Generic.Dictionary<string, object>()
//            {
//                {"kind", playerCount }
//            });


//        string? uuid = response.Content;

//        if (uuid == null || uuid == "null")
//        {
//            m_IsWaitingForMatch = true;

//            WaitingForMatchRoot.SetActive(true);
//            JoinMatchRoot.SetActive(false);

//            StartCoroutine(WaitForMatch());
//        }
//        else
//        {
//            AuthenticationManager.Instance.MatchId = uuid.Substring(1, uuid.Length - 2);

//            SceneManager.LoadScene("Preparation");
//        }
//    }
//}
