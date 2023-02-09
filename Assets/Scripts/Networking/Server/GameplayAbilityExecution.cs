using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class GameplayAbilityExecution
{
    public Server_CreatureEntity Self;

    public abstract GameplayAbility GetAbility();//{ get; }
    public virtual void OnStart() { }
    public virtual void OnStop() { }
    public virtual bool Update(float deltaTime) { return false; }
    public virtual void TryInterrupt(bool force = false) {  }
    public virtual void OnKeyDown() { }
    public virtual void OnKeyUp() { }
}
