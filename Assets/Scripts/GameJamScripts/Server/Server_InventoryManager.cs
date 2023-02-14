using UnityEngine;

public class Server_InventoryManager
{
    public int[] playerInventory;

    public void Init()
    {
        playerInventory = new int[(int)CollectiblesEnum.COUNT];
    }

    public void AddToInventory(CollectiblesEnum whichCollectible, int howMany)
    {
        playerInventory[(int)whichCollectible] += howMany;
    }
    
    public void RemoveFromInventory(CollectiblesEnum whichCollectible, int howMany)
    {
        if (howMany > playerInventory[(int)whichCollectible])
            Debug.LogWarning("You're trying to remove more " +whichCollectible.ToString() + " from your inventory than you actually have.");

        playerInventory[(int)whichCollectible] -= howMany;
    }
}