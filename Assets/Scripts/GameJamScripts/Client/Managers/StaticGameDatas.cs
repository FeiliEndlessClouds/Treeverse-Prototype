using System;
using UnityEngine;

public enum VisualPrefabName
{
    PlayerVisual,   // Default Classless visual
    SmallTree,
    SmallTreeStump,
    Ore,
    OreMined,
    Fish,
    Bird,
    COUNT,
    NULL = 999
}

public enum CollectiblesEnum
{
    Wood,
    Ore,
    Fish,
    Fertilizer,
    COUNT,
    NULL = 999
}

public enum VFXEnum
{
    PixelHit,
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

    private void Awake()
    {
        abilityCDTimers = new float[3];
    }
}