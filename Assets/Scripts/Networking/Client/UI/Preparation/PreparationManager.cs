//using System;
//using System.Collections;
//using Treeverse.Models;
//using UnityEngine;
//using UnityEngine.SceneManagement;

//public class PreparationManager : MonoBehaviour
//{
//    public PreparationTeam BlueTeam;
//    public PreparationTeam RedTeam;
//    public UnityEngine.UI.Button ReadyButton;

//    public string MatchId;
//    private Supabase.Realtime.Channel m_ChannelMembers;
//    private Supabase.Realtime.Channel m_ChannelMatch;

//    private void Awake()
//    {
//        MatchId = AuthenticationManager.Instance.MatchId;

//        LoadAndWatchMembers();
//    }

//    public async void SetReady()
//    {
//        var supabaseClient = await AuthenticationManager.Instance.GetClientAsync();

//        await supabaseClient.Postgrest.Rpc("set_ready", new System.Collections.Generic.Dictionary<string, object>() {
//            { "__match_id", MatchId },
//            { "value", true }
//        });
//    }

//    async void LoadAndWatchMembers()
//    {
//        var supabaseClient = await AuthenticationManager.Instance.GetClientAsync();

//        var response = await supabaseClient.From<MatchesMemberModel>()
//            .Filter("match_id", Postgrest.Constants.Operator.Equals, MatchId)
//            .Get();

//        foreach(var model in response.Models)
//        {
//            switch (model.Team)
//            {
//                case 0:
//                    BlueTeam.AddMember(model);
//                    break;
//                case 1:
//                    RedTeam.AddMember(model);
//                    break;
//            }
//        }

//        m_ChannelMembers = await supabaseClient.From<MatchesMemberModel>()
//            .On(Supabase.Client.ChannelEventType.All, Channel_OnUpdateMembers);

//        m_ChannelMembers = await supabaseClient.From<MatchModel>()
//            .On(Supabase.Client.ChannelEventType.All, Channel_OnUpdateMatch);
//    }

//    private void Channel_OnUpdateMembers(object sender, Supabase.Realtime.SocketResponseEventArgs e)
//    {
//        if (e.Response.Event == Supabase.Realtime.Constants.EventType.Update)
//        {
//            MatchesMemberModel model = e.Response.Model<MatchesMemberModel>();

//            UnityMainThreadDispatcher.Instance().Enqueue(() =>
//            {
//                switch (model.Team)
//                {
//                    case 0:
//                        BlueTeam.UpdateMember(model);
//                        break;
//                    case 1:
//                        RedTeam.UpdateMember(model);
//                        break;
//                }
//            });
//        }
//    }

//    private void Channel_OnUpdateMatch(object sender, Supabase.Realtime.SocketResponseEventArgs e)
//    {
//        if (e.Response.Event == Supabase.Realtime.Constants.EventType.Update)
//        {
//            MatchModel model = e.Response.Model<MatchModel>();

//            UnityMainThreadDispatcher.Instance().Enqueue(() =>
//            {
//                if (model.IsReady)
//                {
//                    Debug.Log("Everyone is ready and match is on ready state, move to dungeon scene here!!");

//                    /* everyone is ready */
//                }
//            });
//        }
//    }
//}
