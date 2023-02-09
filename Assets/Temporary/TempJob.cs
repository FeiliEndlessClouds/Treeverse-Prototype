using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Temp/TempJob", order = 7)]
public class TempJob : ScriptableObject
{
    public int jobNum;

    public int hp;
    public int mp;
    public int armor;

    public TempAbility attack;
    public TempAbility skill_1;
    public TempAbility skill_2;
    public TempAbility skill_3;
}
