using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Server_SeedEntity : Server_NetworkedEntity
{
    public Rigidbody rb;
    public BoxCollider bodyCol;
    public float growth = 0f;
    public float growthSpeedMultiplier = 1f;
    public int playersNearby = 0;
    public bool bPlanted = false;
    public bool bHeld = false;
    float growthMul2 = 2.4f;

    private float cannotBePickedTimer = 0f;

    public void Reset()
    {
        growth = 0f;
        growthSpeedMultiplier = 1f;
        playersNearby = 0;

        rb.isKinematic = false;
        rb.useGravity = true;
        bodyCol.enabled = true;
        bPlanted = false;
        VisualId = VisualPrefabName.SeedVisual;

        bHeld = false;
        
        gameObject.layer = LayerMask.NameToLayer("Seed");
    }

    // Turn into a Trigger
    public void SetPlanted()
    {
        rb.isKinematic = true;
        rb.useGravity = false;
        bodyCol.enabled = false;
        growth = 0;
        growthSpeedMultiplier = 1f;
        playersNearby = 1;
        transform.position = new Vector3(transform.position.x, 0f, transform.position.z);
        VisualId = VisualPrefabName.TreeMorphableVisual;
        
        bPlanted = true;

        StartCoroutine(GrowingTreeC());
    }

    IEnumerator GrowingTreeC()
    {
        bool bGrowing = true;
        while (bGrowing)
        {
            if (IsDestroyed || growth >= 100 || NetworkManager.RuleSetManagerGameOfSeed.gameState == SeedGameStatesEnum.MATCHMAKING)
                bGrowing = false;
            
            playersNearby = NetworkManager.RuleSetManagerGameOfSeed.GetGrowersCount();
            growthSpeedMultiplier = (playersNearby == 0) ? 1f : 1f * playersNearby;
            
            yield return null;
        }
    }

    public IEnumerator SetPositionC(Vector3 pos)
    {
        SetHeld(true);
        yield return null;
        transform.position = pos;
        yield return null;
        SetHeld(false);
    }

    public void SetHeld(bool held)
    {
        bHeld = held;
        bPlanted = false;
        if (held)
        {
            rb.isKinematic = true;
            rb.useGravity = false;
            bodyCol.enabled = false;
        }
        else
        {
            rb.isKinematic = false;
            rb.useGravity = true;
            bodyCol.enabled = true;
        }
    }

    public IEnumerator SetGoLayerForASecC()
    {
        gameObject.layer = LayerMask.NameToLayer("Default");
        yield return new WaitForSeconds(0.3f);
        gameObject.layer = LayerMask.NameToLayer("Seed");
    }

    public void SetCannotBePickedTimer(float forHowLong)
    {
        cannotBePickedTimer = Time.time + forHowLong;
    }

    public void AddForce(Vector3 dir, float power)
    {
        rb.AddForce(dir * power, ForceMode.Impulse);
    }

    public override void Initialize()
    {
        NetworkId = NetworkManager.NetworkedEntities.Allocate(this);
        IsDestroyed = false;

        Reset();

        base.Initialize();
    }

    public override void UpdatePhysics(float deltaTime)
    {
        if (bPlanted)
        {
            if (growth < 100)
                growth += Time.deltaTime * growthSpeedMultiplier * growthMul2;
            else
                NetworkManager.RuleSetManagerGameOfSeed.TreeScored();
        }

        base.OnPositionChanged();
    }

    public void DestroySeed()
    {
        NetworkDestroy();
    }

    private void OnTriggerEnter(Collider other)
    {
        if (bPlanted)
            return;
        if (bHeld)
            return;
        if (Time.time < cannotBePickedTimer)
            return;
        
        if (other.gameObject.layer == LayerMask.NameToLayer("Player"))
        {
            // Prevents Client_PlayerEntity from nullref
            Server_PlayerEntity player = other.GetComponent<Server_PlayerEntity>();
            if (player && NetworkManager.RuleSetManagerGameOfSeed.IsPlayerAttacker(player))
                player.SetSeedHolder();
        }
    }
}
