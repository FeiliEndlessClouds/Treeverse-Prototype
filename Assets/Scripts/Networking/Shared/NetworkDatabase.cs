//using System.Collections;
//using System.Collections.Generic;
//using System.Linq;
//using UnityEngine;
//using UnityEngine.AddressableAssets;

//public class NetworkDatabase : ScriptableObject
//{
//    const string VisualsFolder = "Assets/Data/Visuals";
//    const string AnimationsFolder = "Assets/Data/Animations";

//    [SerializeField] private GameplayAnimation[] Animations;
//    [SerializeField] private AssetReference[] Visuals;

//    /* Map of adressable key to network id */
//    private Dictionary<object, int> VisualsCache;

//    static NetworkDatabase instance;

//    public static NetworkDatabase Instance
//    {
//        get
//        {
//            if (instance == null)
//            {
//                instance = Resources.Load<NetworkDatabase>("NetworkDatabase");

//                instance.Initialize();
//            }

//            return instance;
//        }
//    }

//    private void Initialize()
//    {
//        if (Animations != null)
//        {
//            for (int it = 0; it < Animations.Length; ++it)
//            {
//                Animations[it].NetworkId = (it + 1);
//            }
//        }

//        if(Visuals != null)
//        {
//            VisualsCache = new Dictionary<object, int>();

//            for (int visualId = 0; visualId < Visuals.Length; ++visualId)
//            {
//                VisualsCache[Visuals[visualId].RuntimeKey] = (visualId + 1);
//            }
//        }
//    }

//#if UNITY_EDITOR
//    [UnityEditor.MenuItem("Networking/Generate Network Database")]
//    static void GenerateNetworkDatabase()
//    {
//        NetworkDatabase instance = UnityEditor.AssetDatabase.LoadAssetAtPath<NetworkDatabase>($"Assets/Data/Resources/NetworkDatabase.asset");

//        if (instance == null)
//        {
//            instance = ScriptableObject.CreateInstance<NetworkDatabase>();

//            UnityEditor.AssetDatabase.CreateAsset(instance, $"Assets/Data/Resources/NetworkDatabase.asset");
//        }

//        List<AssetReference> visuals = new List<AssetReference>();
 
//        Object[] visualAssets = UnityEditor.AssetDatabase.FindAssets("t:Object", new[] { VisualsFolder }).Select(guid =>
//        {
//            var myObjectPath = UnityEditor.AssetDatabase.GUIDToAssetPath(guid);
//            var myObjs = UnityEditor.AssetDatabase.LoadMainAssetAtPath(myObjectPath) as GameObject;

//            if(myObjs?.GetComponent<Client_NetworkedEntityVisual>() == null && myObjs != null)
//            {
//                Debug.LogWarning($"{myObjs.name} - Client_NetworkedEntityVisual is required!");
//            }
            
//            return myObjs;
//        }).ToArray();

//        foreach (Object visualAsset in visualAssets)
//        {
//            if (visualAsset != null)
//            {
//                var assetRef = new AssetReference();

//                assetRef.SetEditorAsset(visualAsset);

//                visuals.Add(assetRef);
//            }
//        }

//        GameplayAnimation[] animations = UnityEditor.AssetDatabase.FindAssets("t:Object", new[] { AnimationsFolder }).SelectMany(guid =>
//        {
//            var myObjectPath = UnityEditor.AssetDatabase.GUIDToAssetPath(guid);
//            var myObjs = UnityEditor.AssetDatabase.LoadAllAssetsAtPath(myObjectPath);

//            return myObjs.Select(obj => obj as GameplayAnimation);
//        }).ToArray();

//        instance.Visuals = visuals.ToArray();
//        instance.Animations = animations;

//        UnityEditor.EditorUtility.SetDirty(instance);

//        UnityEditor.AssetDatabase.SaveAssets();
//    }
//#endif


//    public int GetVisualNetworkId(AssetReferenceGameObject assetRef)
//    {
//        return VisualsCache[assetRef.RuntimeKey];
//    }

//    public AssetReference GetVisualAssetReference(int visualId)
//    {
//        if(visualId > 0 && visualId <= Visuals.Length)
//        {
//            return Visuals[visualId - 1];
//        }

//        return null;
//    }
//}
