//using System.Collections.Generic;
//using UnityEngine;

//[RequireComponent(typeof(UnityEngine.UI.Toggle))]
//public class PreparationLoadout : MonoBehaviour
//{
//    public int ItemId;
//    public PreparationManager Manager;

//    private void Awake()
//    {
//        GetComponent<UnityEngine.UI.Toggle>()
//            .onValueChanged.AddListener(OnValueChanged);
//    }

//    public async void OnValueChanged(bool value)
//    {
//        if (value)
//        {
//            await AuthenticationManager.Instance.CallRpc("choose_loadout", new Dictionary<string, object>()
//            {
//                { "__match_id", Manager.MatchId },
//                { "__item_id", ItemId }
//            });
//        }
//    }
//}
