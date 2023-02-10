using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum VFXEnum
{
	Emoji_Confused,
    Emoji_Freeze,
    Emoji_GameStart,
    Emoji_Happy,
    Emoji_Lose,
    Emoji_Mock,
	COUNT,
    NULL = 9999
}

public enum BiomesEnum
{
    Plains,
    Mountains,
    Desert,
    Forest,
    COUNT,
    NULL
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
    public GameObject[] allVisualPrefabs;

    [HideInInspector] public float[] abilityCDTimers;
}