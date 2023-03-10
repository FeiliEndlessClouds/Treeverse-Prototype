using System.Collections.Generic;
using System.Linq;
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
            if ((ActorTypesEnum)i != ActorTypesEnum.FishBubbles)
            {
                if (actorCount[i] < 30)
                {
                    Vector2 randomPoint = Random.insideUnitCircle * 30f;
                    if (randomPoint.magnitude < 10f) randomPoint = randomPoint.normalized * Random.Range(10f, 30f);
                    Server_ActorEntity actor = ObjectPoolManager.CreatePooled(actorPrefab,
                            trackedPlayer.position + new Vector3(randomPoint.x, 0f, randomPoint.y), Quaternion.identity)
                        .GetComponent<Server_ActorEntity>();
                    actor.NetworkManager = ruleSetManager.serverNetworkManager;
                    actor.actorType = (ActorTypesEnum)i;
                    actor.VisualId = Utils.GetVisualIdFromActorType((ActorTypesEnum)i);
                    activeActorEntityList.Add(actor);
                    actorCount[i]++;
                }
            }
        }
        
        // Despawn
        for (int i = 0; i < activeActorEntityList.Count; i++)
        {
            if ((activeActorEntityList[i].transform.position - trackedPlayer.position).sqrMagnitude > 1225f) // 15m
            {
                actorCount[(int)activeActorEntityList[i].actorType]--;
                ObjectPoolManager.DestroyPooled(activeActorEntityList[i].gameObject);
                activeActorEntityList.RemoveAt(i);
                activeActorEntityList.TrimExcess();
            }
        }
    }

    public Server_ActorEntity GetClosestInteractibleActorToPos(Vector3 pos)
    {
        activeActorEntityList = activeActorEntityList.OrderBy(x => Vector3.Distance(pos, x.transform.position)).ToList();
        for (int i = 0; i < activeActorEntityList.Count; i++)
        {
            if ((activeActorEntityList[i].transform.position - pos).sqrMagnitude < 10f && !activeActorEntityList[i].bDead)
            {
                return activeActorEntityList[i];
            }
        }
        return null;
    }
}