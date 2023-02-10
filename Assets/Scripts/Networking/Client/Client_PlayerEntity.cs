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
    public bool fixedCam = false;
    Camera cam;
    GameManager_GameOfSeed mgr;
    [SerializeField] float camDis = -8f, camOffset = -0.2f;
    [SerializeField] float x = 70, y = -420, z = 250, w = 105;

	private void Start()
    {
        playerInputManager = GameInfos.Instance.activeGameManagerGameOfSeed.playerInputManager;
        _camManager = GameInfos.Instance.activeGameManagerGameOfSeed.camManager;
        cam = Camera.main;
        mgr = GameInfos.Instance.activeGameManagerGameOfSeed;
        //cam.transform.localRotation = new Quaternion(x, y, z, w);
    }

    public override void ReadSnapshot(ref SnapshotSerializer serializer, SnapshotFlags flags)
    {
        base.ReadSnapshot(ref serializer, flags);

        if (hp < 120)
            GameInfos.Instance.activeGameManagerGameOfSeed.guiManager.redScreen.enabled = true;
        else
            GameInfos.Instance.activeGameManagerGameOfSeed.guiManager.redScreen.enabled = false;
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

        if (!fixedCam) 
        {
            _camManager.UpdateCam(Time.deltaTime);
		}
        else
        {
            if (mgr.gameOfSeedState == SeedGameStatesEnum.GAME_A_ATK_B_DFS && mgr.localPlayerTeam == SeedersTeamStatus.TEAM_A ||
                mgr.gameOfSeedState == SeedGameStatesEnum.GAME_B_ATK_A_DFS && mgr.localPlayerTeam == SeedersTeamStatus.TEAM_B)
            {
                cam.transform.localRotation = new Quaternion(z, w, -x, -y);
            }
            else
            {
                cam.transform.localRotation = new Quaternion(x, y, z, w);    //for testing the angles in view
            }
            cam.transform.position = transform.position + cam.transform.forward * camDis + cam.transform.up * camOffset;
        }
    }
}
