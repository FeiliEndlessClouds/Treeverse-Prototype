using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PoolableGameObject : MonoBehaviour
{
    //[NonSerialized]
    //public AdressableObjectPool Pool;

    private void Start()
    {
        Initialize();
    }

    public virtual void Initialize()
    {

    }

    public virtual void Recycle()
    {
        ObjectPoolManager.DestroyPooled(gameObject);

        //Debug.Log("Pooling object : " + gameObject.name, gameObject);
        //Pool.ReturnToPool(gameObject);
    }
}
