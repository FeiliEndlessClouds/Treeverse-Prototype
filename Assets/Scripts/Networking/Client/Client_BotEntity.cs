using UnityEngine;

public class Client_BotEntity : Client_CharacterEntity
{
    const float InputDebounceTime = 1.0f / 30.0f;

    float InputTimeout = 0.0f;

    public Vector3 LastAim;

    BotCommandManager botCommandManager;

    private void Start()
    {
        botCommandManager = GameInfos.Instance.activeGameManagerGameOfSeed.botCommandManager;
    }

    public override void Interpolate(float deltaTime)
    {
        base.Interpolate(deltaTime);

        float horizontal = botCommandManager.moveVector.x;
        float vertical = botCommandManager.moveVector.z;

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

            serializer.Buffer.Put((uint)botCommandManager.abilityInput);

            Manager.UnreliableBuffer = serializer.Buffer;

            botCommandManager.abilityInput = PlayerInputs.None;
        }

        if (IsDead)
        {
            //if (!ReviveButton.activeSelf)
            //{
            //    ReviveButton.SetActive(true);
            //}
        }
    }
}
