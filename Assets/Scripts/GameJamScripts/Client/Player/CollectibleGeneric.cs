using UnityEngine;
using System.Collections;

public class CollectibleGeneric : MonoBehaviour
{
	public CollectibleTypes collectibleType;
    private Collider col;

    public int id = 0;

    private void Awake()
    {
        col = GetComponent<Collider>();
        transform.localScale = Vector3.one;
    }

    private void Start()
    {
        col.enabled = true;
    }

    public void DisableCol()
    {
        col.enabled = false;
    }
}