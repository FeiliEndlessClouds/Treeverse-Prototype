//using System.Collections;
//using System.Collections.Generic;
//using Treeverse.Models;
//using UnityEngine;

//public class PreparationTeam : MonoBehaviour
//{
//    private PreparationPlayer[] m_Players;
//    private int m_Count;


//    private void Awake()
//    {
//        m_Players = GetComponentsInChildren<PreparationPlayer>();

//        foreach(var player in m_Players)
//        {
//            player.gameObject.SetActive(false);
//        }
//    }

//    public void AddMember(MatchesMemberModel memberModel)
//    {
//        m_Players[m_Count]
//            .SetModel(memberModel);

//        ++m_Count;
//    }

//    public void UpdateMember(MatchesMemberModel memberModel)
//    {
//        foreach(var player in m_Players)
//        {
//            if(player.m_PlayerId == memberModel.UserId)
//            {
//                player.SetModel(memberModel);
//            }
//        }
//    }
//}
