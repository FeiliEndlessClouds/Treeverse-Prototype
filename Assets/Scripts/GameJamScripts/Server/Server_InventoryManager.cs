using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Server_InventoryManager
{
    public event GameContributeEventHandler GameContributeEvent;

    private void GameContribute(int networkID, int damageDealt, int damageMitigated, int healed, int death, int killed)
    {
        if (GameContributeEvent != null) GameContributeEvent(networkID, damageDealt, damageMitigated, healed, death, killed);
    }

    public void UseItem(effectsEnum whichEffect, Server_PlayerEntity player, Server_RuleSet_GameOfSeed ruleSetManager)
    {
        // Not the best but whatever works
        switch (whichEffect)
        {
            case effectsEnum.DAMAGE:
                ruleSetManager.StartItemCoroutine(DAMAGE(player));
                break;
            case effectsEnum.CONTINUOUSDAMAGE:
                ruleSetManager.StartItemCoroutine(CONTINUOUSDAMAGE(player));
                break;
            case effectsEnum.HEAL:
                ruleSetManager.StartItemCoroutine(HEAL(player));
                break;
            case effectsEnum.CONTINUOUSHEAL:
                ruleSetManager.StartItemCoroutine(CONTINUOUSHEAL(player));
                break;
            case effectsEnum.ARMORUP:
                ruleSetManager.StartItemCoroutine(ARMORUP(player));
                break;
            case effectsEnum.STUN:
                ruleSetManager.StartItemCoroutine(STUN(player));
                break;
            case effectsEnum.MANABURN:
                ruleSetManager.StartItemCoroutine(MANABURN(player));
                break;
            case effectsEnum.FREEZE:
                ruleSetManager.StartItemCoroutine(FREEZE(player));
                break;
            case effectsEnum.DANCE:
                ruleSetManager.StartItemCoroutine(DANCE(player));
                break;
            case effectsEnum.SILENT:
                ruleSetManager.StartItemCoroutine(SILENT(player));
                break;
            case effectsEnum.INVISIBLE:
                ruleSetManager.StartItemCoroutine(INVISIBLE(player));
                break;
            case effectsEnum.SLOW:
                ruleSetManager.StartItemCoroutine(SLOW(player));
                break;
            case effectsEnum.DASH:
                ruleSetManager.StartItemCoroutine(DASH(player));
                break;
            case effectsEnum.INVINCIBLE:
                ruleSetManager.StartItemCoroutine(INVINCIBLE(player));
                break;
            case effectsEnum.SEEDDROP:
                ruleSetManager.StartItemCoroutine(SEEDDROP(player));
                break;
            case effectsEnum.KNOCKBACK:
                ruleSetManager.StartItemCoroutine(KNOCKBACK(player));
                break;
            case effectsEnum.CALLNEXT:
                ruleSetManager.StartItemCoroutine(CALLNEXT(player));
                break;
            case effectsEnum.DRAG:
                ruleSetManager.StartItemCoroutine(DRAG(player));
                break;
            case effectsEnum.MESSUP:
                ruleSetManager.StartItemCoroutine(MESSUP(player));
                break;
        };
    }

    // Deal damage only once
    public IEnumerator DAMAGE(Server_PlayerEntity player)
    {
        int amount = 1;

        int finalDamage = (amount > player.hp) ? player.hp : amount;

        player.hp -= amount;

        player.hp = Mathf.Clamp(player.hp, 0, player.maxHp);

        GameContribute(player.NetworkId, finalDamage, 0 , 0, 0, 0);

        yield return null;

        player.RemoveItem(effectsEnum.DAMAGE);
    }

    // Deal damage within a duration
    public IEnumerator CONTINUOUSDAMAGE(Server_PlayerEntity player)
    {
        int amount = 10;
        int duration = 3;
        float interval = 0.5f;

        for (float i = 0; i < duration; i += interval)
        {
            int finalDamage = (amount > player.hp) ? player.hp : amount;
            player.hp -= amount;
            player.hp = Mathf.Clamp(player.hp, 0, player.maxHp);
            GameContribute(player.NetworkId, finalDamage, 0, 0, 0, 0);
            yield return new WaitForSeconds(interval);
        }

        player.RemoveItem(effectsEnum.CONTINUOUSDAMAGE);
    }

    // Heal only once
    public IEnumerator HEAL(Server_PlayerEntity player)
    {
        int amount = 150;

        int finalAmount = (amount > (player.maxHp - player.hp)) ? (player.maxHp - player.hp) : amount;

        player.hp += amount;

        player.hp = Mathf.Clamp(player.hp, 0, player.maxHp);

        GameContribute(player.NetworkId, 0, 0, finalAmount, 0, 0);

        yield return null;
    
        player.RemoveItem(effectsEnum.HEAL);
    }

    // Heal within a duration 
    public IEnumerator CONTINUOUSHEAL(Server_PlayerEntity player)
    {
        int amount = 30;
        int duration = 5;
        float interval = 0.5f;
      
        for (int i = 0; i < duration; i++)
        {
            int finalAmount = (amount > (player.maxHp - player.hp)) ? (player.maxHp - player.hp) : amount;
            player.hp += amount;
            player.hp = Mathf.Clamp(player.hp, 0, player.maxHp);
            GameContribute(player.NetworkId, 0, 0, finalAmount, 0, 0);
            yield return new WaitForSeconds(interval);
        }

        player.RemoveItem(effectsEnum.CONTINUOUSHEAL);
    }

    // Increase armor in a duration
    public IEnumerator ARMORUP(Server_PlayerEntity player)
    {
        int amount = 0;
        float duration = 1.5f;
        int healAmount = 100;

        player.armor += amount;
		player.hp += healAmount;
		player.hp = Mathf.Clamp(player.hp, 0, player.maxHp);

		yield return new WaitForSeconds(duration);
        player.armor -= amount;

        player.RemoveItem(effectsEnum.ARMORUP);
    }

    // Can't move, attack, and cast any Abilities in a duration
    public IEnumerator STUN(Server_PlayerEntity player)
    {
        float duration = 1.5f;
        player.bReadInput = false;
        player.CastEffectAbility(effectsEnum.STUN);
        yield return new WaitForSeconds(duration);

        player.RemoveItem(effectsEnum.STUN);
    }

    // Reduce mana once
    public IEnumerator MANABURN(Server_PlayerEntity player)
    {
        int amount = 100;

        player.mp -= amount;
        player.mp = Mathf.Clamp(player.mp, 0, player.maxMp);
        yield return null;

        player.RemoveItem(effectsEnum.MANABURN);
    }

    // Can't move in a duration
    public IEnumerator FREEZE(Server_PlayerEntity player)
    {
        float duration = 2f;
        int speed = player.defaultAttributes.moveSpeed;

        player.moveSpeed = 0;
        yield return new WaitForSeconds(duration);
        player.moveSpeed = speed;

        player.RemoveItem(effectsEnum.FREEZE);
    }

    // Play dance animation
    public IEnumerator DANCE(Server_PlayerEntity player)
    {
        yield return null;
    }

    // Can't attack and cast abilities in a duration
    public IEnumerator SILENT(Server_PlayerEntity player)
    {
        float duration = 10;
        float interval = 0.1f;

        for (int i = 0; i < duration; i++)
        {
            player.mp = 0;
            yield return new WaitForSeconds(interval);
        }
        player.mp = 100;

        player.RemoveItem(effectsEnum.SILENT);
    }

    // Won't be seen by enemies in a duration
    public IEnumerator INVISIBLE(Server_PlayerEntity player)
    {
        float duration = 3f;

        yield return new WaitForSeconds(duration);

        player.RemoveItem(effectsEnum.INVISIBLE);
    }

    // Slow down the movement speed in a duration
    public IEnumerator SLOW(Server_PlayerEntity player)
    {
        int amount = 2;
        float duration = 4.5f;

        player.moveSpeed -= amount;
        yield return new WaitForSeconds(duration);
        player.moveSpeed += amount;

        player.RemoveItem(effectsEnum.SLOW);
    }

    // Moving forward for an amount distance
    public IEnumerator DASH(Server_PlayerEntity player)
    {
        yield return null;
    }

    // Won't get hurt in a duration
    public IEnumerator INVINCIBLE(Server_PlayerEntity player)
    {
        float duration = 0.3f;
        player.bIsInvincible = true;
		yield return new WaitForSeconds(duration);
        player.bIsInvincible = false;

        player.RemoveItem(effectsEnum.INVINCIBLE);
    }

    // Switch the seed carrying state from TRUE to FALSE, and the seed drops down to the ground
    public IEnumerator SEEDDROP(Server_PlayerEntity player)
    {
        if (player.NetworkManager.RuleSetManager.GetSeedHolderNetworkID() == player.NetworkId)
            player.NetworkManager.RuleSetManager.DropSeed(player);
        
        yield return null;
        player.RemoveItem(effectsEnum.SEEDDROP);
    }

    // Move the target backward from the ability caster
    public IEnumerator KNOCKBACK(Server_PlayerEntity player)
    {
        float duration = 0.8f;
        player.bReadInput = false;
        player.CastEffectAbility(effectsEnum.KNOCKBACK);
        yield return new WaitForSeconds(duration);

        player.RemoveItem(effectsEnum.KNOCKBACK);
    }

    // Call the second ability
    public IEnumerator CALLNEXT(Server_PlayerEntity player)
    {
        yield return null;
    }

    public IEnumerator DRAG(Server_PlayerEntity player)
    {
        float duration = 0.8f;
        player.bReadInput = false;
        player.CastEffectAbility(effectsEnum.DRAG);
        yield return new WaitForSeconds(duration);

        player.RemoveItem(effectsEnum.DRAG);
    }

    public IEnumerator MESSUP(Server_PlayerEntity player)
    {
        yield return new WaitForSeconds(2f);
        player.RemoveItem(effectsEnum.MESSUP);
    }
}
