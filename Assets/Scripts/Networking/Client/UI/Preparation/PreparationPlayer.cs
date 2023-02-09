//using System.Collections;
//using System.Collections.Generic;
//using Treeverse.Models;
//using UnityEngine;
//using UnityEngine.AddressableAssets;
//using UnityEngine.ResourceManagement.AsyncOperations;

//public class PreparationPlayer : MonoBehaviour
//{
//    public TMPro.TextMeshProUGUI NameText;
//    public UnityEngine.UI.Toggle ReadyToggle;
//    public UnityEngine.UI.RawImage LoadoutImage;

//    public string m_PlayerId;

//    private async void LoadLoadoutIcon(int id)
//    {
//        ItemModel model = await ItemDatabase.Instance.GetItemById(id);

//        Addressables.LoadAssetAsync<Texture2D>(model.ItemIcon)
//                .Completed += PreparationPlayer_LoadIcon_Completed;
//    }

//    private void PreparationPlayer_LoadIcon_Completed(AsyncOperationHandle<Texture2D> obj)
//    {
//        LoadoutImage.texture = obj.Result;
//    }

//    public void SetModel(MatchesMemberModel memberModel)
//    {
//        gameObject.SetActive(true);

//        m_PlayerId = memberModel.UserId;

//        NameText.text = memberModel.Name;

//        ReadyToggle.isOn = memberModel.IsReady;

//        if(memberModel.Loadout != null)
//        {
//            LoadoutImage.enabled = true;

//            LoadLoadoutIcon(memberModel.Loadout.Value);
//        }
//        else
//        {
//            LoadoutImage.enabled = false;
//        }
//    }

//}
