using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Treeverse.Networking.Abilities
{
    [CreateAssetMenu(menuName = "ScriptableObjects/DieAbility", order = 0)]
    public class DieAbility : GameplayAbility
    {
        public GameplayAnimation Animation;

        public override GameplayAbilityExecution Cast(Server_CreatureEntity self)
        {
            return new Execution() { Ability = this, Self = self };
        }

        class Execution : GameplayAbilityExecution
        {
            public DieAbility Ability;
            private GameplayAnimation.AnimationSupportData AnimationSupportData;

            public override void OnStart()
            {
                AnimationSupportData = new GameplayAnimation.AnimationSupportData() { Target = Self };
                AnimationSupportData.Target.AnimationTime = 0f;
                Self.SetIsDead(true);
            }

            public override GameplayAbility GetAbility()
            {
                return Ability;
            }

            public override bool Update(float deltaTime)
            {
                if (Ability.Animation.Evaluate(ref AnimationSupportData, deltaTime))
                {
                    if (!AnimationSupportData.Target.IsDead)
                        return true;
                }

                return false;
            }
        }
    }
}