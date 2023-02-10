using System.Collections;
using System.Collections.Generic;
using System.Numerics;
//using UnityEditor.Experimental.GraphView;
using UnityEngine;
using Quaternion = UnityEngine.Quaternion;
using Vector3 = UnityEngine.Vector3;

public delegate void GameContributeEventHandler(int networkID, int damageDealt, int damageMitigated, int healed, int death, int killed);

[RequireComponent(typeof(CharacterController))]
public class Server_CreatureEntity : Server_NetworkedEntity
{
    static Collider[] Colliders = new Collider[64];

    const float GRAVITY_CONST = -9.81f;

    [SerializeField]
    protected CharacterController Controller;

    [SerializeField]
    protected LayerMask DamageLayers;

    public GameplayAbility OuchAbility;
    public GameplayAbility DieAbility;
    public GameplayAbility StunAbility;
    public GameplayAbility KnockbackAbility;
    public GameplayAbility DragAbility;
    public GameplayAbility MockAbility;
    public GameplayAbility CelebrateAbility;
    public GameplayAbility MournAbility;

    protected double CanCastAt;

    public AnimatorNodeNamesEnum AnimationId;
    public float AnimationTime;

    public float AnimationSpeed = 1.0f;

    public bool bReadInput = true;
    public bool CanMove;
    public bool CanRotate;
    public bool IsDead;
    public bool IsTeleporting;
    public bool bIsInvincible;
    public bool bInPlantingArea;

    public Vector3 Velocity;

    public CharacterAttributes defaultAttributes;            // the default player's stats
    public int maxHp = 100;
    public int hp = 100;
    public float maxMp = 90;
    public float mp = 90;
    public int armor = 2;
    public int moveSpeed = 5;
    public float mpGen = 0.002f;
    public float SpeedMultiplier = 1.0f;

    private int DamageTaken;

    protected Vector3 NormalizedMovementInput;
    protected GameplayAbilityExecution Execution;
    protected GameplayAbilityExecution previousExecution;
    protected Quaternion DesiredRotation;
    protected float Gravity;

    public Vector3 OnHitEffectDirection;

    public event GameContributeEventHandler GameContributeEvent;

    public override void Initialize()
    {
        base.Initialize();

        Flags = SnapshotFlags.IsCharacter;
    }

    private void GameContribute(int networkID, int damageDealt, int damageMitigated, int healed, int death, int killed)
    {
        if (GameContributeEvent != null) GameContributeEvent(networkID, damageDealt, damageMitigated, healed, death, killed);
    }

    public void SetPosition(Vector3 position)
    {
        Controller.enabled = false;
        transform.position = position;
        Controller.enabled = true;
    }

    public void SetPositionAndRotation(Vector3 position, Quaternion rotation)
    {
        Controller.enabled = false;
        transform.position = position;
        transform.rotation = rotation;
        Controller.enabled = true;
    }

    public Server_PlayerEntity[] GetPlayersFromCollisionSphere(Vector3 pos, float radius)
    {
		int collisionCount = Physics.OverlapSphereNonAlloc(pos, radius, Colliders, DamageLayers);
        List<Server_PlayerEntity> playerList = new List<Server_PlayerEntity>();
        for (int it = 0; it < collisionCount; ++it)
        {
            Collider collider = Colliders[it];
            if (collider.TryGetComponent(out Server_PlayerEntity otherPlayer))
            {
                playerList.Add(otherPlayer);
            }
        }
        return playerList.ToArray();
    }

	// It uses a sphere for detection, then check angles to decide if applyDmg  -------- UNUSED and DEPRECATED
	public bool ApplyConeDamage(float angle, int damage, float radius = 2.0f)
    {
        bool result = false;

        Vector3 forward = transform.forward;
        Vector3 origin = transform.position + Vector3.up;

        int collisionCount = Physics.OverlapSphereNonAlloc(origin, radius, Colliders, DamageLayers);

        int seedLayer = LayerMask.NameToLayer("Seed"); 
        
        for (int it = 0; it < collisionCount; ++it)
        {
            Collider collider = Colliders[it];

            if (collider.gameObject != gameObject && collider.TryGetComponent(out Server_CreatureEntity other))
            {
                Vector3 directionToHit = collider.transform.position - origin;

                directionToHit.y = 0f;

                float angleToHit = Vector3.Angle(forward, directionToHit);

                if (angleToHit <= angle)
                {
                    result = other.TakeDamage(this, damage);
                }
            }
        }

        return result;
    }

    public void SetIsDead(bool value)
    {
        IsDead = value;

        if (value)
        {
            Controller.enabled = false;
        }
    }

    public override void UpdatePhysics(float deltaTime)
    {
        CanMove = !IsDead;
        CanRotate = !IsDead;
        if (IsTeleporting) return;

        AnimationId = AnimatorNodeNamesEnum.Locomotion;

        if(mp < maxMp && !IsDead)
            mp += mpGen;

        if (Controller.isGrounded)
        {
            if (CanMove)
            {
                float DesiredMagnitude = moveSpeed * SpeedMultiplier;

                Velocity = NormalizedMovementInput * DesiredMagnitude * deltaTime;

                AnimationSpeed = SpeedMultiplier;

                Flags ^= ((Velocity == Vector3.zero ? 0 : SnapshotFlags.All) ^ Flags) & SnapshotFlags.IsMoving;

                Gravity = 0.0f;
            }
            else
            {
                Velocity = Vector3.zero;

                Flags = Flags & ~SnapshotFlags.IsMoving;
            }
        }

        Gravity += GRAVITY_CONST * deltaTime;

        if (Execution != null)
        {
            AnimationSpeed = 1.0f;

            if (Execution.Update(deltaTime))
            {
                Execution = null;
                bReadInput = true;

                CanCastAt = Time.time + 0.1;
            }
        }

        if (CanRotate)
        {
            if (Execution != null)
            {
                transform.rotation = Quaternion.RotateTowards(transform.rotation, DesiredRotation, 1800.0f * deltaTime);
            }
            else if (NormalizedMovementInput != Vector3.zero)
            {
                transform.rotation = Quaternion.LookRotation(NormalizedMovementInput);
            }
        }

        Flags ^= ((AnimationId == 0 ? 0 : SnapshotFlags.All) ^ Flags) & SnapshotFlags.IsAnimating;

        Velocity.y += Gravity * deltaTime;

        if (Controller.enabled)
            Controller.Move(Velocity);

        this.OnPositionChanged();
    }

    public override void WriteSnapshot(ref SnapshotSerializer serializer)
    {
        base.WriteSnapshot(ref serializer);

        if ((Flags & SnapshotFlags.IsAnimating) == SnapshotFlags.IsAnimating)
        {
            serializer.Buffer.Put((ushort)(AnimationId)); /* Optional uses only 1 bit for the value 0, when no animation is playing */

            /* If we are playing any animation, write for how much time we are playing it already */
            serializer.Buffer.PutTimespan(AnimationTime);
        }

        serializer.Buffer.Put((byte)(Utils.Remap(AnimationSpeed, 0f, 2.0f, byte.MinValue, byte.MaxValue)));

        /* Write health percentage, from 0 to 255. It is needed to show healthbar on top of player head in realtime */
        //serializer.Buffer.Put((byte)(((modifiedAttributes.health * 255 + defaultAttributes.health - 1) / defaultAttributes.health)));
        //serializer.Buffer.Put((byte)(((modifiedAttributes.mana * 255 + defaultAttributes.mana - 1) / defaultAttributes.mana)));

        serializer.Buffer.Put((ushort)hp);
        serializer.Buffer.Put((ushort)mp);

        if ((Flags & SnapshotFlags.HasDamage) == SnapshotFlags.HasDamage)
        {
            serializer.Buffer.PutVar(DamageTaken);

            DamageTaken = 0;

            Flags &= ~SnapshotFlags.HasDamage;
        }

        if ((Flags & SnapshotFlags.HasOnHitEffect) == SnapshotFlags.HasOnHitEffect)
        {
            serializer.Buffer.Put((short)(OnHitEffectDirection.x * 1000));
            serializer.Buffer.Put((short)(OnHitEffectDirection.z * 1000));

            Flags &= ~SnapshotFlags.HasOnHitEffect;
        }
    }

    public virtual bool TakeDamage(Server_CreatureEntity damageDealer, int value)
    {
        if (bIsInvincible)
            return false;

        if (!IsDead)
        {
            StartCoroutine(IFramesC(0.5f));

            Flags |= SnapshotFlags.HasDamage;
            Flags |= SnapshotFlags.HasOnHitEffect;

            int dealtDamage = Mathf.Max(value - armor, 0);

            DamageTaken += dealtDamage;

            OnHitEffectDirection = (damageDealer.transform.position - transform.position);
            OnHitEffectDirection.y = 0;
            OnHitEffectDirection.Normalize();
            OnHitEffectDirection *= Controller.radius;

            int finalDamage = (dealtDamage > hp) ? hp : dealtDamage;
            hp = Mathf.Max(0, hp - dealtDamage);

            if (hp <= 0)
            {
                GameContribute(damageDealer.NetworkId, finalDamage, 0, 0, 0, 1);
                GameContribute(this.NetworkId, 0, 0, 0, 1, 0);
                Execution = DieAbility.Cast(this);

                Execution.OnStart();
            }
            else
            {
                GameContribute(damageDealer.NetworkId, dealtDamage, 0, 0, 0, 0);
                
                // Reset cooldown if ability was thrown during ouch
                if (Execution != null)
                    abilityInterruptByOuch();
                else
                {
                    Execution = OuchAbility.Cast(this);
                    Execution.OnStart();
                }
            }
            return true;
        }

        return false;
    }
    
    public void TakeNeutralDamage(Vector3 dir, int value)
    {
        if (!IsDead)
        {
            Flags |= SnapshotFlags.HasDamage;
            Flags |= SnapshotFlags.HasOnHitEffect;

            int dealtDamage = Mathf.Max(value - armor, 0);

            DamageTaken += dealtDamage;

            OnHitEffectDirection = dir;
            OnHitEffectDirection.y = 0;
            OnHitEffectDirection.Normalize();
            OnHitEffectDirection *= Controller.radius;

            hp = Mathf.Max(0, hp - dealtDamage);

            if (hp <= 0)
            {
                GameContribute(this.NetworkId, 0, 0, 0, 1, 0);
                Execution = DieAbility.Cast(this);
            }
            else
            {
                if (Execution != null)
                    abilityInterruptByOuch();
                else
                    Execution = OuchAbility.Cast(this);
            }
            Execution.OnStart();
        }
    }

    protected virtual void abilityInterruptByOuch()
    {
        
    }
    
    public void CastEffectAbility(effectsEnum effect)
    {
        if (effect == effectsEnum.STUN)
        {
            Execution = StunAbility.Cast(this);
            Execution.OnStart();
        }
        else if(effect == effectsEnum.KNOCKBACK)
        {
            Execution = KnockbackAbility.Cast(this);
            Execution.OnStart();
        }
        else if(effect == effectsEnum.DRAG)
        {
            Execution = DragAbility.Cast(this);
            Execution.OnStart();
        }
    }

    public void CastMock()
    {
        if (Time.time >= CanCastAt)
        {
            AnimationTime = 0.0f;
            bReadInput = false;
            Execution = MockAbility.Cast(this);
            Execution.OnStart();
        }
    }

    public void CastCelebrate()
    {
        Execution = CelebrateAbility.Cast(this);
        Execution.OnStart();
    }

    public void CastMourn()
    {
        Execution = MournAbility.Cast(this);
        Execution.OnStart();
    }

    IEnumerator IFramesC(float timer)
    {
        bIsInvincible = true;

        yield return new WaitForSeconds(timer);

        bIsInvincible = false;
    }
}
