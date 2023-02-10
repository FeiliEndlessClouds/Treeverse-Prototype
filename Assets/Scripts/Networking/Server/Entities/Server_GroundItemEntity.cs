using UnityEngine;

public class Server_GroundItemEntity : Server_NetworkedEntity
{
    public effectsEnum effect;
    public int posIndex;

    public override void Initialize()
    {
        NetworkId = NetworkManager.NetworkedEntities.Allocate(this);
        IsDestroyed = false;

        base.Initialize();
    }

    private void OnTriggerEnter(Collider other)
    {
        if (!IsDestroyed)
        {
            if (other.TryGetComponent<Server_PlayerEntity>(out Server_PlayerEntity player))
            {
                //player.AddEffect(effect);

                NetworkDestroy();
            }
        }
    }

    public static Server_GroundItemEntity Spawn(Transform parent, Server_NetworkManager networkManager, VisualPrefabName visualId, effectsEnum effect, int index)
    {
        GameObject go = new GameObject("Server_GroundItemEntity");
        SphereCollider col = go.AddComponent<SphereCollider>();
        col.isTrigger = true;
        col.radius = 0.5f;
        Server_GroundItemEntity groundItemEntity = go.AddComponent<Server_GroundItemEntity>();

        groundItemEntity.NetworkManager = networkManager;

        groundItemEntity.transform.SetParent(parent, false);
        groundItemEntity.VisualId = visualId;
        groundItemEntity.effect = effect;

        groundItemEntity.posIndex = index;

        go.layer = LayerMask.NameToLayer("Collectible");

        return groundItemEntity;
    }

    /*
    public IEnumerator Respawn(int index)
    {
        yield return new WaitForSeconds(3);
        ruleSet.SpawnOneGroundItem(index);
        Debug.LogWarning("try to respawn");
    }
    */
}
