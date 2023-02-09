using System;
using UnityEngine;
using TMPro;
using UnityEngine.UI;

public class Client_CharacterEntity : Client_NetworkedEntity
{
    public AnimatorNodeNamesEnum AnimationId;

    //private double AnimationBeginAt;

    /* Recompute network time to take adressable loading time into account when playing animations */
    //public float AnimationTime =>  (float)(Time.timeAsDouble - AnimationBeginAt);

    //[NonSerialized]
    public float AnimationSpeed;

    public SnapshotFlags Flags;

    protected override float RotationInterpolationTime => AnimationId > 0 ? 0.075f : 0.15f;

    // Those stats are only used for visuals
    private int maxHP;
    private int maxMP;

    public int hp;
    public int mp;

    public TMP_Text statsTxt;
    public Canvas statsCanvas;
    public Slider sliderHP;
    public Slider sliderMP;

    private void Start()
    {
        statsCanvas.worldCamera = Camera.main;
    }

    public void ResetMaxStats()
    {
        maxHP = 0;
        maxMP = 0;
    }

    public override void ReadSnapshot(ref SnapshotSerializer serializer, SnapshotFlags flags)
    {
        base.ReadSnapshot(ref serializer, flags);

        int animationId = 0;

        float animationTime = 0.0f;

        int damageValue = 0;

        Vector2 onHitEffectPosition = default(Vector2);

        if ((flags & SnapshotFlags.IsAnimating) == SnapshotFlags.IsAnimating)
        {
            animationId = serializer.Buffer.GetUShort();

            if (animationId > 0)
            {
                animationTime = serializer.Buffer.GetTimeSpan();
            }
        }

        float animationSpeed = Utils.Remap(serializer.Buffer.GetByte(), byte.MinValue, byte.MaxValue, 0.0f, 2.0f);

        int hpT = serializer.Buffer.GetUShort();
        int spT = serializer.Buffer.GetUShort();

        if ((flags & SnapshotFlags.HasDamage) == SnapshotFlags.HasDamage)
        {
            damageValue = serializer.Buffer.GetVarInt();
        }

        if ((flags & SnapshotFlags.HasOnHitEffect) == SnapshotFlags.HasOnHitEffect)
        {
            onHitEffectPosition.x = serializer.Buffer.GetShort() / 1000f;

            onHitEffectPosition.y = serializer.Buffer.GetShort() / 1000f;
        }

        if (serializer.QuantizedTimestamp >= LastServerQuantizedTimestamp)
        {
            Flags = flags;
            AnimationId = (AnimatorNodeNamesEnum)animationId;
            AnimationSpeed = animationSpeed;
            //AnimationBeginAt = Time.timeAsDouble + animationTime;
            hp = hpT;
            mp = spT;

            if ((flags & SnapshotFlags.HasDamage) == SnapshotFlags.HasDamage)
            {
                OnTakeDamage(damageValue);
                //GameInfos.Instance.activeGameManager.SpawnVFX(VFXEnum.Hit, transform.position + Vector3.up, Quaternion.identity);
            }

            if ((flags & SnapshotFlags.HasOnHitEffect) == SnapshotFlags.HasOnHitEffect)
            {
                
            }

            // No time
            if (maxHP < hp)
            {
                maxHP = hp;
                sliderHP.maxValue = maxHP;
            }

            if (maxMP < mp)
            {
                maxMP = mp;
                sliderMP.maxValue = maxMP;
            }

            statsTxt.text = hp.ToString() + " / " + maxHP.ToString() + "\n" + mp.ToString() + " / " + maxMP.ToString();
            sliderHP.value = hp;
            sliderMP.value = mp;

            //if (IsDead)
            //{
            //    HealthbarPanel.gameObject.SetActive(false);
            //}
        }
    }

    protected override void TimeOutDestroy()
    {
        Debug.Log("Client_NetworkedEntity : " + networkId + " destroyed due to time out.", gameObject);
        GameInfos.Instance.activeGameManager.client_NetworkManager.RemoveCharacterEntity(this);
        Destroy(gameObject);
    }

    public bool IsDead
    {
        get { return AnimationId.ToString().Contains("Death"); }
    }

    private void OnTakeDamage(int value)
    {
        GameInfos.Instance.activeGameManager.SpawnVFX(VFXEnum.Hit, transform.position + Vector3.up, Quaternion.identity);
        GameInfos.Instance.activeGameManager.audioManager.PlaySound(Sounds.PlayerOuch, 0.3f, false);
        GameInfos.Instance.activeGameManager.camManager.ShakeCam(0.2f);
        Client_CharacterEntityVisual visualC = Visual as Client_CharacterEntityVisual;
        visualC.emissiveValue = 10f;

        //DamageNumber damageNumber = DamageNumberPrefab.Spawn(transform.position, value);
    }
}
