using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Treeverse.Networking.Abilities
{
    [CreateAssetMenu(menuName = "ScriptableObjects/AutoAttackAbility", order = 0)]
    public class AutoAttackAbility : GameplayAbility
    {
        [Serializable]
        public struct ComboEntry
        {
            public GameplayAnimation Animation;
            public float[] DamageTime;
            public int damage;
            public int coneAngle;
        }

        public ComboEntry[] ComboEntryList;
        public float SlowDownByOnHit = 0.8f;
        public float SlowDownForOnHit = 1.0f;

        public override GameplayAbilityExecution Cast(Server_CreatureEntity self)
        {
            return new Execution() { Ability = this, Self = self };
        }

        class Execution : GameplayAbilityExecution
        {
            public AutoAttackAbility Ability;
            private GameplayAnimation.AnimationSupportData AnimationSupportData;
            private int ComboIndex;
            private int DamageIndex;

            private double SlowDownTimeout;

            public override void OnStart()
            {
                AnimationSupportData = new GameplayAnimation.AnimationSupportData() { Target = Self };
                AnimationSupportData.Target.AnimationTime = 0f;
            }

            public override void TryInterrupt(bool force = false)
            {
                if (!force)
                {
                    ComboEntry entry = Ability.ComboEntryList[ComboIndex];

                    if (entry.Animation.CanResetCombo(ref AnimationSupportData))
                    {
                        ComboIndex = -1;
                    }
                }
            }

            public override void OnKeyDown()
            {
                if (ComboIndex == -1)
                    return;

                ComboEntry entry = Ability.ComboEntryList[ComboIndex];

                if (entry.Animation.CanResetCombo(ref AnimationSupportData))
                {
                    ComboIndex += 1;

                    DamageIndex = 0;

                    if (ComboIndex == Ability.ComboEntryList.Length)
                    {
                        ComboIndex = -1;
                    }
                    AnimationSupportData.Target.AnimationTime = 0f;
                    AnimationSupportData.RootMotion = Vector3.zero;
                }
            }

            public override GameplayAbility GetAbility()
            {
                return Ability;
            }

            public override bool Update(float deltaTime)
            {
                if (ComboIndex >= 0)
                {
                    ComboEntry entry = Ability.ComboEntryList[ComboIndex];

                    if(DamageIndex < entry.DamageTime.Length)
                    {
                        if(AnimationSupportData.Target.AnimationTime >= entry.DamageTime[DamageIndex])
                        {
                            if(AnimationSupportData.Target.ApplyConeDamage(entry.coneAngle, entry.damage, 2.0f))
                            {
                                SlowDownTimeout = Time.timeAsDouble + Ability.SlowDownForOnHit;
                            }

                            ++DamageIndex;
                        }
                    }

                    if (Time.timeAsDouble <= SlowDownTimeout)
                    {
                        AnimationSupportData.Target.AnimationSpeed *= (1.0f - Ability.SlowDownByOnHit);
                    }

                    if (entry.Animation.Evaluate(ref AnimationSupportData, deltaTime))
                    {
                        return true;
                    }

                    return false;
                }

                return true;
            }
        }
    }
}