using UnityEngine;

/// <summary> Creatures are either casting an ability (and has a GameplayAbilityExecution assigned) or free to cast/walk </summary>
public abstract class GameplayAbility : ScriptableObject
{
    public int manaCost;
    public float cooldown;

    /// <summary>Higher priority abilities can cancel lower priority abilityes</summary>
    public virtual int Priority { get { return 0; } }

    public virtual void PreloadAnimations() { }

    public abstract GameplayAbilityExecution Cast(Server_CreatureEntity self);
}
