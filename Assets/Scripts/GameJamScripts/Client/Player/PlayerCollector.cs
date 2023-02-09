using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum CollectibleTypes
{
    Seed,
    BoostA,
	COUNT,
    NULL = 99999999
}

public class PlayerCollector : MonoBehaviour
{
	public delegate void PlayerCollectAction(CollectibleGeneric collectibleScript, Transform objectTr);
	public static event PlayerCollectAction OnPlayerCollectStart;
	public static event PlayerCollectAction OnPlayerCollect;

	public GameObject collectFX;
	public GameObject dataSignalCollide;

	public AnimationCurve animCurve;
	private Transform tr;

	void Awake()
	{
		tr = transform;
	}
    
	IEnumerator LerpToPlayer(Transform lerpTarget, CollectibleGeneric collectibleScript)
	{
        collectibleScript.DisableCol();

        if (OnPlayerCollectStart != null)
			OnPlayerCollectStart(collectibleScript, lerpTarget);

        yield return null;

		ObjectPoolManager.CreatePooled(dataSignalCollide,lerpTarget.position,Quaternion.identity);
		float timer = 0f;
		Vector3 posOrig = lerpTarget.position;
        Vector3 randomPos = posOrig + new Vector3(Random.Range(-1f,1f), Random.Range(-1f, 1f), Random.Range(-1f, 1f));

        while (timer < 1f)
        {
            if (lerpTarget != null)
                lerpTarget.position = Vector3.Lerp(posOrig, randomPos, animCurve.Evaluate(timer));
            else
                yield break;
            timer += Time.deltaTime*2;
            yield return null;
        }

        posOrig = lerpTarget.position;
        yield return new WaitForSeconds(0.3f);
        timer = 0f;

        while (timer < 1f)
		{
            if (lerpTarget != null)
                lerpTarget.position = Vector3.Lerp(posOrig, tr.position, animCurve.Evaluate(timer));
            else
                yield break;
			timer += Time.deltaTime;
			yield return null;
        }

        ObjectPoolManager.CreatePooled(collectFX, lerpTarget.position,Quaternion.identity);
		if (OnPlayerCollect != null)
			OnPlayerCollect(collectibleScript, lerpTarget);

		yield return null;
		yield return null;
		ObjectPoolManager.DestroyPooled(lerpTarget.gameObject);
	}

	void OnTriggerEnter(Collider other)
	{
		if (other.gameObject.layer == LayerMask.NameToLayer("Collectible"))
        {
            CollectibleGeneric collectibleScript = other.GetComponent<CollectibleGeneric>();
            if (collectibleScript)
                StartCoroutine(LerpToPlayer(other.transform, collectibleScript));
        }
	}
}
