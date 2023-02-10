using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum VFXEnum
{
    PixelHit,
    Heal,
    ClassicAttack_Blue,
    Hit,
    StunLoop,
    HealLoop,
    AOE_Indicator,
    BigBoom,
    ClassicAttack_Red,
    ArmorUpLoop,
    Indi_R_15,
	Indi_R_18,
    IndiSelf_R_18,
	Indi_R_21,
	IndiSelf_R_21,
	Indi_R_24,
	IndiSelf_R_24,
	IndiSelf_G_24,
	IndiSelf_G_30,
	Emoji_Confused,
    Emoji_Freeze,
    Emoji_GameStart,
    Emoji_Happy,
    Emoji_Lose,
    Emoji_Mock,
    VFX_Ice,
    Indi_Jump_R_18,
	Indi_B_15,
	Indi_B_18,
	Indi_B_21,
	Indi_B_24,
	IndiSelf_B_24,
	Indi_Jump_B_18,
	COUNT,
    NULL = 9999
}

public enum effectsEnum
{
    DAMAGE,
    CONTINUOUSDAMAGE,
    HEAL,
    CONTINUOUSHEAL,
    ARMORUP,
    STUN,
    MANABURN,
    FREEZE,
    DANCE,
    SILENT,
    INVISIBLE,
    SLOW,
    DASH,
    INVINCIBLE,
    SEEDDROP,
    KNOCKBACK,
    CALLNEXT,
    DRAG,
    MESSUP,
    COUNT,
    NULL = 99
}

public enum AnimatorNodeNamesEnum
{
    Locomotion = 0,

    // -- BARBARIAN -- //
    BarAttack = 10,
    BarAbility1,
    BarAbility2,
    BarAbility3,

    // -- RANGER    -- //
    RanAttack = 20,
    RanAbility1,
    RanAbility2,
    RanAbility3,

    // -- PALADIN   -- //
    PalAttack = 30,
    PalAbility1,
    PalAbility2,
    PalAbility3,

    // -- ASSASSIN  -- //
    AssAttack = 40,
    AssAbility1,
    AssAbility2,
    AssAbility3,
    
    // -- SORCERER  -- //
    SorAttack = 50,
    SorAbility1,
    SorAbility2,
    SorAbility3,

    // -- RANGER    -- //
    RgrAttack = 60,
    RgrAbility1,
    RgrAbility2,
    RgrAbility3,

    Ouch = 100,
    Death,
    Stun,
    Mock,
    Celebrate,
    Mourn
}

public class StaticGameDatas : MonoBehaviour
{
    public GameObject[] fxGoArray;
    public Sprite[] effectSprites;
    public Material[] TeamColors;

    [HideInInspector] public float[] abilityCDTimers;
    
    public Sprite[] abilitySpritesBar;
    public Sprite[] abilitySpritesRan;
    public Sprite[] abilitySpritesPal;
    public Sprite[] abilitySpritesAss;

    public void SetAbilitiesIconAndCoolDownTimers(SeedGameClassesEnum whichClass)
    {
        // Icons
        Sprite[] abilitySpriteArray = new Sprite[0];
        if (whichClass == SeedGameClassesEnum.BARBARIAN) abilitySpriteArray = abilitySpritesBar;
        if (whichClass == SeedGameClassesEnum.RANGER) abilitySpriteArray = abilitySpritesRan;
        if (whichClass == SeedGameClassesEnum.PALADIN) abilitySpriteArray = abilitySpritesPal;
        if (whichClass == SeedGameClassesEnum.ASSASSIN) abilitySpriteArray = abilitySpritesAss;
        GameInfos.Instance.activeGameManagerGameOfSeed.guiManager.SetAbilityIcons(abilitySpriteArray);
        
        // Timers
        abilityCDTimers = new float[3];
        switch (whichClass)
        {
            case SeedGameClassesEnum.BARBARIAN:
                abilityCDTimers[0] = 6f;
                abilityCDTimers[1] = 6f;
                abilityCDTimers[2] = 9f;
                break;
            case SeedGameClassesEnum.RANGER:
                abilityCDTimers[0] = 6f;
                abilityCDTimers[1] = 6f;
                abilityCDTimers[2] = 9f;
                break;
            case SeedGameClassesEnum.PALADIN:
                abilityCDTimers[0] = 6f;
                abilityCDTimers[1] = 6f;
                abilityCDTimers[2] = 9f;
                break;
            case SeedGameClassesEnum.ASSASSIN:
                abilityCDTimers[0] = 6f;
                abilityCDTimers[1] = 6f;
                abilityCDTimers[2] = 9f;
                break;
        }
    }
}