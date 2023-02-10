using System;
using UnityEngine;
using UnityEngine.UI;

public class Client_PlayerEntity : Client_CharacterEntity
{
    const  float InputDebounceTime = 1.0f / 30.0f;

    float InputTimeout = 0.0f;

    public Vector3 LastAim;

    PlayerInputManager playerInputManager;
    private CamManager _camManager;
    Camera cam;

	private void Start()
    {
        playerInputManager = GameInfos.Instance.activeGameManagerMMORPG.playerInputManager;
        _camManager = GameInfos.Instance.activeGameManagerMMORPG.camManager;
        cam = Camera.main;
    }

    public override void ReadSnapshot(ref SnapshotSerializer serializer, SnapshotFlags flags)
    {
        base.ReadSnapshot(ref serializer, flags);

        if (hp < 120)
            GameInfos.Instance.activeGameManagerMMORPG.guiManager.redScreen.enabled = true;
        else
            GameInfos.Instance.activeGameManagerMMORPG.guiManager.redScreen.enabled = false;
    }

    public override void Interpolate(float deltaTime)
    {
        base.Interpolate(deltaTime);

        float horizontal = playerInputManager.moveVector.x;
        float vertical = playerInputManager.moveVector.z;

        Vector3 newMovement = new Vector3(horizontal, 0, vertical);
        newMovement.Normalize();

        InputTimeout -= deltaTime;

        if (InputTimeout <= 0.0f)
        {
            InputTimeout += InputDebounceTime;

            SnapshotSerializer serializer = new SnapshotSerializer(0, 0, Time.timeAsDouble)
            {
                Buffer = Manager.UnreliableBuffer
            };

            serializer.WriteHeader();

            serializer.Buffer.Put((short)(newMovement.x * 1000));
            serializer.Buffer.Put((short)(newMovement.z * 1000));

            serializer.Buffer.Put((short)(LastAim.x * 1000));
            serializer.Buffer.Put((short)(LastAim.z * 1000));

            serializer.Buffer.Put((uint)playerInputManager.abilityInput);
            serializer.Buffer.Put((uint)playerInputManager.abilityInputState);

            Manager.UnreliableBuffer = serializer.Buffer;

            playerInputManager.abilityInput = PlayerInputs.None;
        }

        if (IsDead)
        {
            //if (!ReviveButton.activeSelf)
            //{
            //    ReviveButton.SetActive(true);
            //}
        }

        _camManager.UpdateCam(Time.deltaTime);
    }
}
