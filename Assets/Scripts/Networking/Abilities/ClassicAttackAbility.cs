using UnityEngine;
using System.Linq;
using System.Collections.Generic;

namespace Treeverse.Networking.Abilities
{
    [CreateAssetMenu(menuName = "ScriptableObjects/ClassicAttackAbility", order = 0)]
    public class ClassicAttackAbility : GameplayAbility {
        public GameplayAnimation animation;
        public float detectPlayersAtThisTime;
        public float offsetZ;
        public int damage;
        public effectsEnum effect;
        public float radius;
        [SerializeField] 
        GameObject gizmoBase;

        public enum TargetType
        {
            Directional,
            Target
        }
        public TargetType targetType;
        public enum TargetTeam
        {
            enemy,
            ally,
            self,
            allyAndSelf,
            all
        }
        public TargetTeam targetTeam;
        
        public override GameplayAbilityExecution Cast(Server_CreatureEntity self)
        {
            return new Execution() { Ability = this, Self = self };
        }

        class Execution : GameplayAbilityExecution
        {
            public ClassicAttackAbility Ability;
            private GameplayAnimation.AnimationSupportData AnimationSupportData;
            private bool bAttacked = false;

            public override void OnStart()
            {
                AnimationSupportData = new GameplayAnimation.AnimationSupportData() { Target = Self };
                AnimationSupportData.Target.AnimationTime = 0f;

                Server_PlayerEntity selfPlayer = Self as Server_PlayerEntity;
				if (Ability.targetTeam == TargetTeam.enemy && selfPlayer.pressedButtonTimer < 0.3f)
                {
					Server_PlayerEntity[] dirPivot = AnimationSupportData.Target.GetPlayersFromCollisionSphere(AnimationSupportData.Target.transform.position, Ability.radius * 2);
                    List<Server_PlayerEntity> targetDirection = new();
					foreach (var target in dirPivot) 
                    {
                        if(target != selfPlayer && target.team != selfPlayer.team) 
                            targetDirection.Add(target);
                    }
                    if(targetDirection.Count > 0 && targetDirection[0] != null) 
                    {
						targetDirection = targetDirection.OrderBy(x => Vector3.Distance(selfPlayer.transform.position, x.transform.position)).ToList();
						selfPlayer.transform.forward = targetDirection[0].transform.position - selfPlayer.transform.position;
					}
				}
			}

			private bool bInterrupt = false;
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

                if (Ability.animation == null)
                {
                    Debug.Log("No animation. (Animation not set?)");
                    return true;
                }

                if (Ability.animation.Evaluate(ref AnimationSupportData, deltaTime)) 
                {
					return true;
				}

                if (!bAttacked && AnimationSupportData.Target.AnimationTime > Ability.detectPlayersAtThisTime)
                {
					Vector3 spherePos = AnimationSupportData.Target.transform.position +
                                        AnimationSupportData.Target.transform.forward * Ability.offsetZ;

                    Server_PlayerEntity p = AnimationSupportData.Target as Server_PlayerEntity;
                    if (!AnimationSupportData.Target.NetworkManager.RuleSetManagerGameOfSeed.IsPlayerAttacker(p))
                    {
                        AnimationSupportData.Target.DetectSeedAndHitIt(spherePos, Ability.radius, (int)(Ability.damage));
                    }

                    Server_PlayerEntity selfPlayer = Self as Server_PlayerEntity;
                    Server_PlayerEntity[] detectedPlayers = AnimationSupportData.Target.GetPlayersFromCollisionSphere(spherePos, Ability.radius);
                    List<Server_PlayerEntity> finalTarget = new();

                    // for compare to the actual ability scope
                    //GenerateGizmo(spherePos);

					if (detectedPlayers.Length > 0)
                    {
						foreach (var player in detectedPlayers) {
							switch (Ability.targetTeam) {
								case TargetTeam.all: //for testing purpose
								break;

								case TargetTeam.enemy:
								if (player != selfPlayer && player.team != selfPlayer.team) {
									finalTarget.Add(player);
								}
								break;

								case TargetTeam.ally:
								if (player != selfPlayer && player.team == selfPlayer.team) {
									finalTarget.Add(player);
								}
								break;

								case TargetTeam.self:
								if (player == selfPlayer) {
									finalTarget.Add(player);
								}
								break;

								case TargetTeam.allyAndSelf:
								if (player.team == selfPlayer.team) {
									finalTarget.Add(player);
								}
								break;
							}
						}

                        if(Ability.targetType == TargetType.Target)
                        {
                            finalTarget = finalTarget.OrderBy(x => Vector3.Distance(selfPlayer.transform.position, x.transform.position)).ToList();
                            Casting(finalTarget[0]);
                        } 
                        else
                        {
                            foreach(var finalPlayer in finalTarget) 
                            {
                                Casting(finalPlayer);
                            }
                        }
                    }
                    bAttacked = true;
                }
                return false;
            }

            private void Casting(Server_PlayerEntity player)
            {
				player.transform.forward = -AnimationSupportData.Target.transform.forward;
				player.TakeDamage(AnimationSupportData.Target, Ability.damage);

                if (Ability.effect != effectsEnum.NULL)
                {
                    player.AddEffect(Ability.effect);
                }
            }

            void GenerateGizmo(Vector3 pos) 
            {
				GameObject scopeBase = Instantiate(Ability.gizmoBase, pos, Quaternion.LookRotation(pos - Self.transform.position));
				GizmoScope scope = scopeBase.GetComponent<GizmoScope>();
				scope.centerPosition = pos;
				scope.radius = Ability.radius;
			}
        }
    }
}
