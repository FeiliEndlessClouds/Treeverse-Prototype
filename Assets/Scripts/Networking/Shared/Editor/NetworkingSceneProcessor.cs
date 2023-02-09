using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEditor.Build;
using UnityEditor.Build.Reporting;
using UnityEngine;


public class NetworkingSceneProcessor : IProcessSceneWithReport
{
    public int callbackOrder { get { return 0; } }
    public void OnProcessScene(UnityEngine.SceneManagement.Scene scene, BuildReport report)
    {
        if (report != null)
        {
            Debug.Log("NetworkingSceneProcessor.OnPreprocessBuild " + scene.name);

#if UNITY_SERVER
            GameObject collidersRoot = GameObject.Find("#Colliders");

            if (collidersRoot != null)
            {
                GameObject.DestroyImmediate(collidersRoot);
            }

            collidersRoot = new GameObject("#Colliders");

            HashSet<GameObject> CollidersExtracted = new HashSet<GameObject>();

            Action<GameObject> ExtractColliders = go =>
            {
                if (!CollidersExtracted.Contains(go))
                {
                    CollidersExtracted.Add(go);

                    foreach (var collider in go.GetComponentsInChildren<Collider>())
                    {
                        GameObject obj = new GameObject("Collider");

                        obj.transform.SetParent(collidersRoot.transform);

                        obj.transform.position = collider.transform.position;

                        if (collider is CapsuleCollider capsuleCollider)
                        {
                            var other = obj.AddComponent<CapsuleCollider>();

                            other.transform.localScale = capsuleCollider.transform.localScale;
                            other.transform.rotation = capsuleCollider.transform.rotation;
                            other.direction = capsuleCollider.direction;
                            other.radius = capsuleCollider.radius;
                            other.height = capsuleCollider.height;
                            other.center = capsuleCollider.center;
                        }

                        if (collider is BoxCollider boxCollider)
                        {
                            var other = obj.AddComponent<BoxCollider>();

                            other.transform.localScale = boxCollider.transform.localScale;
                            other.transform.rotation = boxCollider.transform.rotation;
                            other.size = boxCollider.size;
                            other.center = boxCollider.center;
                        }

                        
                        if (collider is MeshCollider meshCollider && collider.GetComponent<Terrain>() == null)
                        {
                            var other = obj.AddComponent<MeshCollider>();

                            other.transform.localScale = meshCollider.transform.localScale;
                            other.transform.rotation = meshCollider.transform.rotation;
                            other.transform.localScale = meshCollider.transform.localScale;
                            other.sharedMesh = meshCollider.sharedMesh;
                            other.convex = meshCollider.convex;
                            other.cookingOptions = meshCollider.cookingOptions;
                            other.contactOffset = meshCollider.contactOffset;
                        }

                        UnityEditor.GameObjectUtility.SetStaticEditorFlags(obj, UnityEditor.StaticEditorFlags.NavigationStatic);
                    }
                }
            };

            foreach (var go in scene.GetRootGameObjects().Where(obj => obj.name.StartsWith("#") && obj.name.Contains("Level") && obj.name.Contains("Design")))
            {
                foreach(var col in go.GetComponentsInChildren<Collider>())
                {
                    ExtractColliders(col.gameObject);
                }

                GameObject.DestroyImmediate(go.gameObject);
            }

            foreach (var go in scene.GetRootGameObjects().Where(obj => obj.name.StartsWith("#") && obj.name.Contains("Client") && obj.name.Contains("Only")))
            {
                Debug.Log(go.name + " removed from scene");

                GameObject.DestroyImmediate(go.gameObject);
            }


            foreach (var comp in scene.GetRootGameObjects().SelectMany(x => x.GetComponentsInChildren<Renderer>()))
            {
                GameObject.DestroyImmediate(comp);
            }

            foreach (var comp in scene.GetRootGameObjects().SelectMany(x => x.GetComponentsInChildren<MeshFilter>()))
            {
                GameObject.DestroyImmediate(comp);
            }

            foreach (var comp in scene.GetRootGameObjects().SelectMany(x => x.GetComponentsInChildren<Terrain>()))
            {
                foreach(var component in comp.gameObject.GetComponents<Component>())
                {
                    if(!(component is Collider))
                    {
                        GameObject.DestroyImmediate(comp);
                    }
                }
            }

            foreach (var comp in scene.GetRootGameObjects().SelectMany(x => x.GetComponentsInChildren<Light>()))
            {
                GameObject.DestroyImmediate(comp.gameObject);
            }
#else
            foreach (var go in scene.GetRootGameObjects().Where(obj => obj.name.StartsWith("#") && obj.name.Contains("Server") && obj.name.Contains("Only")))
            {
                Debug.Log(go.name + " removed from scene");

                GameObject.DestroyImmediate(go.gameObject);
            }
#endif

            bool continueRemoving = true;

            while (continueRemoving)
            {
                continueRemoving = false;

                foreach (var go in scene.GetRootGameObjects().SelectMany(x => x.GetComponentsInChildren<Transform>()))
                {
                    if (go.name.StartsWith("#") && (
                        !go.name.Contains("Level Design") ||
#if UNITY_SERVER
                            true
#else
                            false
#endif

                        ))
                    {
                        Debug.Log(go.name + " removed from scene");

                        go.DetachChildren();

                        GameObject.DestroyImmediate(go.gameObject);
                    }
                }
            }
        }
    }
}
