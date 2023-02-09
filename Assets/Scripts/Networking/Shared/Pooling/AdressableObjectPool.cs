//using System;
//using System.Collections;
//using System.Collections.Generic;
//using UnityEngine;
//using UnityEngine.AddressableAssets;
//using UnityEngine.ResourceManagement.AsyncOperations;

//public class AdressableObjectPool : MonoBehaviour
//{
//    private static Dictionary<string, AdressableObjectPool> Pools = new Dictionary<string, AdressableObjectPool>();

//    private Queue<GameObject> GameObjects = new Queue<GameObject>();

//    private GameObject Prefab;
//    private AsyncOperationHandle<GameObject> Handle;
//    private string AssetRef;

//    private void Start()
//    {
//        Debug.Log("This object : " + gameObject.name + " Start() tries loading addressable : " + AssetRef, gameObject);
//        try
//        {
//            Handle = Addressables.LoadAssetAsync<GameObject>(AssetRef);
    
//            Handle.Completed += AdressableLoading_Completed;
//        }
//        catch (Exception ex)
//        {
//            Debug.LogError(ex);
//        }
//    }

//    public bool IsReady
//    {
//        get
//        {
//            return Prefab != null;
//        }
//    }

//    private void OnDestroy()
//    {
//        Addressables.Release(Handle);

//        Pools.Remove(AssetRef);
//    }

//    private void AdressableLoading_Completed(AsyncOperationHandle<GameObject> obj)
//    {
//        Prefab = obj.Result;
//    }

//    public GameObject Instantiate(Transform parent = null)
//    {
//        if (IsReady)
//        {
//            if (GameObjects.Count > 0)
//            {
//                GameObject instance = GameObjects.Dequeue();

//                if (parent != null)
//                {
//                    instance.transform.SetParent(parent, false);
//                }

//                instance.SetActive(true);

//                if (instance.TryGetComponent(out PoolableGameObject poolable))
//                {
//                    poolable.Initialize();
//                }

//                //instance.SetActive(true);

//                return instance;
//            }
//            else
//            {
//                GameObject instance = Instantiate(Prefab, parent);

//                if (instance.TryGetComponent(out PoolableGameObject poolable))
//                {
//                    poolable.Pool = this;
//                }

//                return instance;
//            }
//        }
//        else
//            return null;
//    }

//    public void ReturnToPool(GameObject instance)
//    {
//        instance.SetActive(false);

//        instance.transform.SetParent(gameObject.transform, false);

//        GameObjects.Enqueue(instance);
//    }

//    public static AdressableObjectPool GetPoolByRuntimeKey(string assetRef)
//    {
//        if (assetRef != null)
//        {
//            AdressableObjectPool pool;

//            if (Pools.TryGetValue(assetRef, out pool))
//            {
//                return pool;
//            }

//            GameObject poolObject = new GameObject(assetRef + "_Pool");

//            pool = poolObject.AddComponent<AdressableObjectPool>();

//            pool.AssetRef = assetRef;

//            Pools.Add(assetRef, pool);

//            return pool;
//        }

//        return null;
//    }
//}
