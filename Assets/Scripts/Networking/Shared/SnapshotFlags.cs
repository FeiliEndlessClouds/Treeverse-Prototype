using System;
using System.Collections;
using UnityEngine;

[Flags]
public enum SnapshotFlags : byte
{
    None = 0,
    IsCharacter = 1 << 0,
    IsMoving = 1 << 1,
    IsAnimating = 1 << 2,
    IsDestroyed = 1 << 3,
    HasDamage = 1 << 4,
    HasOnHitEffect = 1 << 5,
    All = byte.MaxValue
}