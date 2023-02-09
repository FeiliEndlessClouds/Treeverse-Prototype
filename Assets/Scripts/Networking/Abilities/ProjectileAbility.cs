using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

namespace Treeverse.Networking.Abilities
{
    [CreateAssetMenu(menuName = "ScriptableObjects/ProjectileAbility", order = 0)]
    public class ProjectileAbility : GameplayAbility
    {
        public VisualPrefabName visualPrefabName = VisualPrefabName.NULL;
        public float moveSpeed = 20f;
        public float range = 10f;
        public int damage = 100;
        public effectsEnum effect = effectsEnum.NULL;
        public GameplayAnimation Animation;
        public float SpawnTime;

        public override GameplayAbilityExecution Cast(Server_CreatureEntity self)
        {
            return new Execution() { Ability = this, Self = self };
        }

        class Execution : GameplayAbilityExecution
        {
            public ProjectileAbility Ability;
            private GameplayAnimation.AnimationSupportData AnimationSupportData;
            private int State;

            public override void OnStart()
            {
                AnimationSupportData = new GameplayAnimation.AnimationSupportData() { Target = Self };
                AnimationSupportData.Target.AnimationTime = 0f;
                State = 0;

                Server_PlayerEntity selfPlayer = Self as Server_PlayerEntity;
                if (selfPlayer.pressedButtonTimer < 0.3f)
                {
                    Server_PlayerEntity[] dirPivot = AnimationSupportData.Target.GetPlayersFromCollisionSphere(AnimationSupportData.Target.transform.position, Ability.range);
                    List<Server_PlayerEntity> targetDirection = new();
                    foreach (var target in dirPivot)
                    {
                        if (target != selfPlayer && target.team != selfPlayer.team)
                            targetDirection.Add(target);
                    }

                    if (targetDirection.Count > 0 && targetDirection[0] != null)
                    {
                        targetDirection = targetDirection
                            .OrderBy(x => Vector3.Distance(selfPlayer.transform.position, x.transform.position)).ToList();
                        selfPlayer.transform.forward =
                            targetDirection[0].transform.position - selfPlayer.transform.position;
                    }
                }
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

                if (State == 0)
                {
                    if (AnimationSupportData.Target.AnimationTime >= Ability.SpawnTime)
                    {
                        State = 1;

                        Server_PlayerEntity player = Self as Server_PlayerEntity;
                        Server_ProjectileEntity.Spawn(Self, Ability.visualPrefabName, Ability.moveSpeed, Ability.range, Ability.damage, Ability.effect, 
                            player.team == SeedersTeamStatus.TEAM_A ? SeedersTeamStatus.TEAM_B : SeedersTeamStatus.TEAM_A);
                    }
   
                    return false;
                }

                return false;
            }
        }
    }
}