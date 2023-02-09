using System;
using System.Collections;
using UnityEngine;

[Flags]
[Serializable]
public enum PlayerInputs
{
    None = 0,
    Action1 = 1 << 0,
    Action2 = 1 << 1,
    Action3 = 1 << 2,
    Action4 = 1 << 3,
    Action5 = 1 << 4
}

public enum PlayerInputsStates
{
    NULL,
    PRESS,
    RELEASE,
    HOLD
}
