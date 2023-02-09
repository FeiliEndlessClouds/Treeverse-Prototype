using UnityEngine;

[CreateAssetMenu(menuName = "ScriptableObjects/GameplayAnimation", order = 0)]
public class GameplayAnimation : ScriptableObject
{
    public bool ApplyRootMotion;

    public AnimationCurve RootMotionX;
    public AnimationCurve RootMotionY;

    public AnimationCurve RootMotionZ;

    public float RootMotionScale = 1.0f;
    public float Speed = 1.0f;

    [Header("After length time, Gameplay animation data stops being Evaluated.")]
    public float Length;

    [Header("After CanResetComboAt, animation can be overridden.")]
    public float CanResetComboAt;

    public AnimatorNodeNamesEnum AnimationName;

    public struct AnimationSupportData
    {
        public Server_CreatureEntity Target;
        public int Trigger;
        public Vector3 RootMotion;
    }

    public bool Evaluate(ref AnimationSupportData data, float deltaTime)
    {
        data.Target.AnimationSpeed *= Speed;
        data.Target.AnimationTime = Mathf.Min(data.Target.AnimationTime + (data.Target.AnimationSpeed * deltaTime), Length);

        data.Target.AnimationId = AnimationName;

        if (ApplyRootMotion)
        {
            data.Target.CanMove = false;

            Vector3 accumulatedRootMotion = new Vector3(RootMotionX.Evaluate(data.Target.AnimationTime), RootMotionY.Evaluate(data.Target.AnimationTime), RootMotionZ.Evaluate(data.Target.AnimationTime));

            Vector3 rootMotionFrame = accumulatedRootMotion - data.RootMotion;

            rootMotionFrame = data.Target.transform.TransformVector(rootMotionFrame) * RootMotionScale;

            data.Target.Velocity = rootMotionFrame;

            // data.Target.Velocity.y += target.Gravity;

            data.RootMotion = accumulatedRootMotion;
        }

        return (data.Target.AnimationTime + 0.1f) > Length;
    }

    public bool CanResetCombo(ref AnimationSupportData data)
    {
        return data.Target.AnimationTime >= CanResetComboAt;
    }
}
