using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Treeverse.Networking.Abilities
{
    [CreateAssetMenu(menuName = "ScriptableObjects/DodgeAbility", order = 0)]
    public class DodgeAbility : GameplayAbility
    {
        public GameplayAnimation Animation;

        public override GameplayAbilityExecution Cast(Server_CreatureEntity self)
        {
            return new Execution() { Ability = this, Self = self };
        }

        class Execution : GameplayAbilityExecution
        {
            public DodgeAbility Ability;
            private GameplayAnimation.AnimationSupportData AnimationSupportData;

            public override void OnStart()
            {
                AnimationSupportData = new GameplayAnimation.AnimationSupportData() { Target = Self };
                AnimationSupportData.Target.AnimationTime = 0f;
            }

            public override GameplayAbility GetAbility()
            {
                return Ability;
            }

            public override bool Update(float deltaTime)
            {
                if (Ability.Animation.Evaluate(ref AnimationSupportData, deltaTime))
                {
                    return true;
                }

                return false;
            }
        }
    }
}