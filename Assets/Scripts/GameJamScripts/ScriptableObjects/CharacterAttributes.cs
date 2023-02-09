using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "ClassAttributes", menuName = "ScriptableObjects/ClassAttributesSO", order = 0)]
public class CharacterAttributes : ScriptableObject
{
    public int maxHp = 100;
    public float maxMp = 90;
    public int armor = 0;
    public int moveSpeed = 6;
}
