using System;
using UnityEngine;

public class Client_NetworkedEntity : MonoBehaviour, IEquatable<Client_NetworkedEntity>
{
    public Client_NetworkManager Manager;

    public int networkId;

    /* Extrapolate 1 server tick */
    private const float ExtrapolationOffset = 1.0f / 30.0f;
    private const double IdleTimeout = 0.5;

    protected uint LastServerQuantizedTimestamp = 0;

    /* When to destroy entity */
    private double TimeoutAt;


    /* Used for interpolation */
    public Vector3 FromPositon;
    public Vector3 ToPosition;

    private float ToRotation;

    public double LocalNetworkTime;

    public float Lerp;
    public float LerpVelocity;

    /* Used for extrapolation, if > 1 then extrapolate */
    private float LerpClamp;


    protected bool IsDestroyed;

    private float RotationVelocity;

    /* Visual System */

    //[NonSerialized]
    //public int VisualId;

    [NonSerialized]
    public Client_NetworkedEntityVisual Visual;

    public VisualPrefabName VisualRef = VisualPrefabName.NULL;

    /// <summary> Time to interpolate rotation from current to the latest rotation received from network </summary>
    protected virtual float RotationInterpolationTime => 0.15f;

    public virtual void ReadSnapshot(ref SnapshotSerializer serializer, SnapshotFlags flags) {
        double serverTimestamp = serializer.Timestamp;

        Vector3 position = serializer.DecodePosition(serializer.Buffer.GetVector());

        float yaw = serializer.Buffer.GetAngle();

        if(LastServerQuantizedTimestamp == 0) /* First snapshot */
        {
            LastServerQuantizedTimestamp = serializer.QuantizedTimestamp;

            transform.position = position;
            transform.rotation = Quaternion.Euler(0, yaw, 0);

            TimeoutAt = Time.timeAsDouble + IdleTimeout;

            LocalNetworkTime = serverTimestamp;

            FromPositon = position;

            ToPosition = position;

            ToRotation = yaw;

            Lerp = 1.0f;
            LerpClamp = 1.0f;
        }
        else if(serializer.QuantizedTimestamp >= LastServerQuantizedTimestamp) /* If this packet is new. Packets can arrive out of order and we need to ignore older packets */
        {
            LastServerQuantizedTimestamp = serializer.QuantizedTimestamp;

            FromPositon = transform.position;
            ToPosition = position;

            ToRotation = yaw;

            float timeDiff = Mathf.Max((float)(serverTimestamp - LocalNetworkTime), 0.0f);

            Lerp = 0.0f;

            LerpVelocity = Mathf.Min(1.0f / timeDiff, 1000.0f);

            LerpClamp = 1.0f + timeDiff * ExtrapolationOffset;

            TimeoutAt = Time.timeAsDouble + IdleTimeout;

            LocalNetworkTime = serverTimestamp;
        }
    }

    public virtual void Interpolate(float deltaTime)
    {
        if (IsDestroyed)
            return;

        Lerp = Mathf.Min(Lerp + LerpVelocity * deltaTime, LerpClamp);

        float yaw = Mathf.SmoothDampAngle(transform.rotation.eulerAngles.y, ToRotation, ref RotationVelocity, RotationInterpolationTime, float.PositiveInfinity, deltaTime);

        transform.rotation = Quaternion.Euler(0, yaw, 0);
        Vector3 newPos = Vector3.LerpUnclamped(FromPositon, ToPosition, Lerp);
        transform.position = newPos;

        LocalNetworkTime += deltaTime;

        if (Time.timeAsDouble > TimeoutAt)
        {
            if (Visual != null)
            {
                Visual.Recycle();
                Visual.Owner = null;
                Visual = null;
            }

            TimeOutDestroy();

            /* Destroy self */
        }
        else
        {
            /* If visual is not loaded yet and the entity was not destroyed load it from the AdressableObjectPool */

            if (!IsDestroyed && Visual == null && VisualRef != VisualPrefabName.NULL)
            {
                SpawnVisual();
            }
        }
    }

    protected virtual void TimeOutDestroy()
    {
        Debug.Log("Client_NetworkedEntity : " + networkId + " destroyed due to time out.", gameObject);
        Destroy(gameObject);
    }

    private void SpawnVisual()
    {
        if ((int)VisualRef >= (int)VisualPrefabName.COUNT)
            Debug.LogError("You're trying to load a Visual Prefab that doesn't exist : " + VisualRef.ToString());

        Transform goTr = ObjectPoolManager.CreatePooled(GameInfos.Instance.staticGameData.allVisualPrefabs[(int)VisualRef], transform.position, transform.rotation).transform;
        goTr.SetParent(transform);
        Visual = goTr.GetComponent<Client_NetworkedEntityVisual>();
        Visual.Owner = this;
    }

    void Update()
    {
        Interpolate(Time.deltaTime);
    }

    public void UpdateVisual(VisualPrefabName visualId)
    {
        VisualRef = visualId;
        UpdateVisual();
    }
    public void UpdateVisual()
    {
        if (Visual != null)
        {
            Visual.Recycle();
            Visual.Owner = null;
            Visual = null;
        }

        SpawnVisual();
    }

    public virtual void Destroy()
    {
        IsDestroyed = true;

        if (Visual)
        {
            Visual.Recycle();
            Visual.Owner = null;
            Visual = null;
        }

        Destroy(gameObject);
    }

    public bool Equals(Client_NetworkedEntity other)
    {
        return this == other;
    }
}
