using UnityEngine;
using static GameplayAnimation;

public class Server_ProjectileEntity : Server_NetworkedEntity
{
    public float Lifetime;
    public float MoveSpeed;
    public int damage = 100;
    public effectsEnum effect = effectsEnum.NULL;

    public Server_CreatureEntity Owner;

    public Vector3 Forward;

    private static RaycastHit[] Colliders = new RaycastHit[16];
    private bool bHitSeed;

    public override void OnDestroy()
    {
        base.OnDestroy();

        NetworkManager.NetworkedEntities.Return(NetworkId);
    }

    public override void UpdatePhysics(float deltaTime)
    {
        base.UpdatePhysics(deltaTime);

        if (!IsDestroyed)
        {
            Lifetime = Lifetime - deltaTime;

            if (Lifetime <= 0.0f)
            {
                Owner = null;
                //OnCollide();
                NetworkDestroy();
            }
            else
            {
                Vector3 from = transform.position;
                Vector3 displacement = Forward * MoveSpeed * deltaTime;

                int collisionCount = Physics.SphereCastNonAlloc(from, 0.5f, Forward, Colliders, displacement.magnitude);

                for (int it = 0; it < collisionCount; ++it)
                {
                    ref RaycastHit hit = ref Colliders[it];

                    if (hit.collider.gameObject.layer == LayerMask.NameToLayer("Player") && hit.collider.TryGetComponent<Server_PlayerEntity>(out var other) && other != Owner)
                    {
                        transform.position = from + Forward * hit.distance;

						other.transform.forward = -transform.forward;
						other.TakeDamage(Owner, damage);

                        if (effect != effectsEnum.NULL)
                        {
                            if (effect == effectsEnum.KNOCKBACK)
                                other.transform.forward = -transform.forward;

                            //other.AddEffect(effect);
                        }

                        break;
                    }

                    if (hit.collider.gameObject.layer == LayerMask.NameToLayer("Environment"))
                    {
                        transform.position = from + Forward * hit.distance;

                        //OnCollide();

                        break;
                    }
                }

                if (!IsDestroyed)
                {
                    transform.position = from + displacement;
                }
            }

            base.OnPositionChanged();
        }
    }

    public static Server_ProjectileEntity Spawn(Server_CreatureEntity owner, VisualPrefabName visualName, float moveSpeed = 20.0f, float range = 10.0f, int damage = 100, effectsEnum effect = effectsEnum.NULL)
    {
        Vector3 position = owner.transform.position;
        Quaternion rotation = owner.transform.rotation;

        GameObject projectileInstance = new GameObject("Server_ProjectileEntity");

        Server_ProjectileEntity projectileCmp = projectileInstance.AddComponent<Server_ProjectileEntity>();

        projectileCmp.Owner = owner;
        projectileCmp.NetworkManager = owner.NetworkManager;

        projectileCmp.NetworkId = projectileCmp.NetworkManager.NetworkedEntities.Allocate(projectileCmp);
        projectileCmp.IsDestroyed = false;
        projectileCmp.transform.position = position + new Vector3(0.0f, 1.2f, 0.0f);
        projectileCmp.transform.rotation = rotation;
        if (visualName.ToString().Contains("Arrow"))
            projectileCmp.VisualId = VisualPrefabName.RedArrowVisual;
        projectileCmp.transform.position += projectileCmp.transform.forward * 0.5f;
        projectileCmp.Forward = projectileCmp.transform.forward;
        projectileCmp.Lifetime = range / moveSpeed;
        projectileCmp.MoveSpeed = moveSpeed;
        projectileCmp.damage = damage;
        projectileCmp.effect = effect;
        projectileCmp.bHitSeed = false;

        return projectileCmp;
    }
}
