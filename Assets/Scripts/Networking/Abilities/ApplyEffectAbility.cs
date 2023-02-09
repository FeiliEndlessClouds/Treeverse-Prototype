using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Treeverse.Networking.Abilities
{
    [CreateAssetMenu(menuName = "ScriptableObjects/ApplyEffectAbility", order = 0)]
    public class ApplyEffectAbility : GameplayAbility
    {
        public GameplayAnimation animation;
        public float[] applyEffectAtThisTime;
        public effectsEnum effectToApply;
        public float radius;
        public float offsetZ;
        public enum TargetTeam
        {
            enemy,
            ally,
            self,
            allyAndSelf,
            all
        }
        public TargetTeam targetTeam;
		[SerializeField] GameObject gizmoBase;

		public override GameplayAbilityExecution Cast(Server_CreatureEntity self)
        {
            return new Execution() { Ability = this, Self = self };
        }

        class Execution : GameplayAbilityExecution
        {
            public ApplyEffectAbility Ability;
            private GameplayAnimation.AnimationSupportData AnimationSupportData;
            private int applyEffectIdx;
            private bool bInterrupt = false;

            public override void OnStart()
            {
                AnimationSupportData = new GameplayAnimation.AnimationSupportData() { Target = Self };
                AnimationSupportData.Target.AnimationTime = 0f;
            }

            public override void TryInterrupt(bool force = false)
            {
                if (!force)
                {
                    if (AnimationSupportData.Target.AnimationTime > Ability.animation.CanResetComboAt)
                        bInterrupt = true;
                }
                else
                    bInterrupt = true;
            }

            public override GameplayAbility GetAbility()
            {
                return Ability;
            }

            public override bool Update(float deltaTime)
            {
                if (bInterrupt)
                    return true;

                if (Ability.animation.Evaluate(ref AnimationSupportData, deltaTime))
                    return true;

                // Apply Effect
                if (applyEffectIdx < Ability.applyEffectAtThisTime.Length &&
                    AnimationSupportData.Target.AnimationTime > Ability.applyEffectAtThisTime[applyEffectIdx])
                {
                    Vector3 detectPos = AnimationSupportData.Target.transform.position + (AnimationSupportData.Target.transform.forward * Ability.offsetZ);
                    Server_PlayerEntity selfPlayer = Self as Server_PlayerEntity;
                    Server_PlayerEntity[] detectedPlayers = AnimationSupportData.Target.GetPlayersFromCollisionSphere(detectPos, Ability.radius);

					// for compare to the actual ability scope
					//GenerateGizmo(AnimationSupportData.Target.transform.position);

					foreach (var player in detectedPlayers)
                    {   
                        switch (Ability.targetTeam)
                        {
                            case TargetTeam.all: //for testing purpose
                                player.AddEffect(Ability.effectToApply);
                                break;

                            case TargetTeam.enemy:
                                if (player.team != selfPlayer.team)
                                {
                                    player.AddEffect(Ability.effectToApply);
                                }
                                break;

                            case TargetTeam.ally:
                                if (player.team == selfPlayer.team && player != Self)
                                {
                                    player.AddEffect(Ability.effectToApply);
                                }
                                break;

                            case TargetTeam.self:
                                if (player == selfPlayer)
                                {
                                    player.AddEffect(Ability.effectToApply);
                                }
                                break;

                            case TargetTeam.allyAndSelf:
                                if (player.team == selfPlayer.team)
                                {
                                    player.AddEffect(Ability.effectToApply);
                                }
                                break;
                        }
                    }
                    applyEffectIdx++;
                }
                return false;
            }

			void GenerateGizmo(Vector3 pos) {
				GameObject scopeBase = Instantiate(Ability.gizmoBase, pos, Quaternion.LookRotation(pos - Self.transform.position));
				GizmoScope scope = scopeBase.GetComponent<GizmoScope>();
				scope.centerPosition = pos;
				scope.radius = Ability.radius;
			}
		}
    }
}