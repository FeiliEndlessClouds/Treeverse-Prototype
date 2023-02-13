using UnityEngine;

public class Server_ActorEntity : Server_NetworkedEntity
{
    public ActorTypesEnum actorType = ActorTypesEnum.NULL;
    
    public override void Initialize()
    {
        Debug.Log("2", gameObject);
        NetworkId = NetworkManager.NetworkedEntities.Allocate(this);
        IsDestroyed = false;

        Reset();

        base.Initialize();
    }
    
    public void Reset()
    {
        Debug.Log("Reset actor");
    }
}