using System.Collections.Generic;
using System.Security.Cryptography;
using UnityEditor;
using UnityEditor.Search;
using UnityEngine;

// When adding a new ActorType, add its matching visualNameId at the bottom of this script
public enum ActorTypesEnum
{
    Tree,
    Ore,
    FishBubbles,
    COUNT,
    NULL = 99999
}

// Actors are objects that are spawned and despawned based on proximity to players.
// Some actors are Interactibles. Interactible Actors such as Trees can drop Collectibles.
// Collectibles can be resources.

public class Server_ActorSpawner
{
    public List<Server_ActorEntity> activeActorEntityList;
    private Server_RuleSet_MMORPG ruleSetManager;

    public void Init(Server_RuleSet_MMORPG rsm)
    {
        ruleSetManager = rsm;
        activeActorEntityList = new List<Server_ActorEntity>();
    }
    
    // Spawns / Despawn actors randomly around a player.
    public void PopulateAroundPlayer(Transform trackedPlayer, int[] actorCount, GameObject actorPrefab)
    {
        // Spawn
        for (int i = 0; i < actorCount.Length; i++)
        {
            if (actorCount[i] < 10)
            {
                Server_ActorEntity actor = ObjectPoolManager.CreatePooled(actorPrefab,
                    trackedPlayer.position + new Vector3(Random.Range(-10, 10), 0f, Random.Range(-10, 10)),
                    Quaternion.identity).GetComponent<Server_ActorEntity>();
                actor.NetworkManager = ruleSetManager.serverNetworkManager;
                actor.actorType = (ActorTypesEnum)i;
                actor.VisualId = GetVisualIdFromActorType((ActorTypesEnum)i);
                activeActorEntityList.Add(actor);
                actorCount[i]++;
            }
        }
        
        // Despawn
        for (int i = 0; i < activeActorEntityList.Count; i++)
        {
            if ((activeActorEntityList[i].transform.position - trackedPlayer.position).sqrMagnitude > 900f) // 30m
            {
                ObjectPoolManager.DestroyPooled(activeActorEntityList[i].gameObject);
                activeActorEntityList.RemoveAt(i);
                activeActorEntityList.TrimExcess();
            }
        }
    }

    public Server_ActorEntity GetClosestInteractibleActorToPos(Vector3 pos)
    {
        return activeActorEntityList[0];
    }

    // Maybe align both enums to automate.
    private VisualPrefabName GetVisualIdFromActorType(ActorTypesEnum actorType)
    {
        VisualPrefabName visualId = VisualPrefabName.NULL;
        switch (actorType)
        {
            case ActorTypesEnum.Tree :
                visualId = VisualPrefabName.SmallTree;
                break;
            case ActorTypesEnum.Ore :
                visualId = VisualPrefabName.Ore;
                break;
            case ActorTypesEnum.FishBubbles :
                visualId = VisualPrefabName.Fish;
                break;
        }

        return visualId;
    }
}