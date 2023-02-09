//using System.Collections;
//using System.Collections.Generic;
//using System.Threading.Tasks;
//using Treeverse.Models;
//using UnityEngine;


//public class ItemDatabase
//{
//    public static ItemDatabase Instance = new ItemDatabase();

//    private Dictionary<int, ItemModel> Items;

//    private Task InitializeTask;

//    private async Task InitializeItemsAsync()
//    {
//        Items = new Dictionary<int, ItemModel>();

//        var itemTable = await AuthenticationManager.Instance.GetSupabaseTable<ItemModel>();

//        var itemList = await itemTable.Get();

//        foreach (var item in itemList.Models)
//        {
//            Items.Add(item.Id, item);
//        }

//    }

//    public async Task<ItemModel> GetItemById(int itemId)
//    {
//        if(Items == null)
//        {
//            InitializeTask = InitializeItemsAsync();
//        }

//        if(Items.Count == 0)
//        {
//            await InitializeTask;
//        }

//        return Items[itemId];
//    }
//}
