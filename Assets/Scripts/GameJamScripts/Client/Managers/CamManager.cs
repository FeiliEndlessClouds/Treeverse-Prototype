using System;
using System.Collections;
using System.Collections.Generic;
using System.Numerics;
using UnityEngine;
using Quaternion = UnityEngine.Quaternion;
using Random = UnityEngine.Random;
using Vector3 = UnityEngine.Vector3;

public enum CamStatesEnum
{
    FOLLOWPLAYER,
    DONOTHING,
    LOOKATLOCALPLAYER
}

public class CamManager : MonoBehaviour
{
    private CamStatesEnum camState = CamStatesEnum.FOLLOWPLAYER;

    [SerializeField] private Transform playerCamRoot;
    [SerializeField] private Transform camLocator;
    [SerializeField] private Transform camLocatorOrig;
    private Transform playerTr;
    private Transform camTr;

    private bool bCollidingWithWall = false;
    private bool camShake = false;

    public LayerMask camLayerMask;

    private float shakeIntensity = 0.0f;
    private float shakeDecay;
    private float shakeVariation = 1.0f;
    private Vector3 shakePosition = Vector3.zero;
    private Quaternion shakeRotation = Quaternion.identity;
    public Vector3 shakeAngles = new Vector3(6.0f, 6.0f, 3.0f);
    public float shakeDur = 0.66f;

    public float smoothing = 0.0001f;
    public float rotateSpeed = 0.0001f;

    public Vector3 colDetectOffset = new Vector3(0f,2f,0f); // Collision detection offset

    public float height = 6f;
    public float sideway = 2f;
    public float backward = 3f;

    private void Awake()
    {
        camTr = Camera.main.transform;
    }

    public void SetCamSide(bool bAttack)
    {
        camLocatorOrig.localPosition = new Vector3(bAttack ? -sideway : sideway, height, bAttack ? -backward : backward);
        playerCamRoot.localEulerAngles = Vector3.zero;
    }

    public void Init(Transform player)
    {
        playerTr = player;
        SetCamSide(true);
    }

    public void SetCamState(CamStatesEnum newState)
    {
        camState = newState;
        if (newState == CamStatesEnum.LOOKATLOCALPLAYER)
        {
            playerCamRoot.position = playerTr.position + Vector3.up * 1.5f;
            camLocatorOrig.localPosition = new Vector3(2f, 2f, 2f);
        }
    }
    
    public void UpdateCam(float deltaTime)
    {
        // client timeout
        if (!playerTr)
            return;

        if (camState == CamStatesEnum.FOLLOWPLAYER)
        {
            playerCamRoot.position = playerTr.position;
            FollowCam(deltaTime);

            camLocator.position = HandleCollisions(playerTr.position + colDetectOffset, camLocator.position);
            
             if (!bCollidingWithWall)
                 camLocator.position = Vector3.Lerp(camLocator.position, camLocatorOrig.position, deltaTime * 80f);
        }
        else if (camState == CamStatesEnum.LOOKATLOCALPLAYER)
        {
            playerCamRoot.Rotate(new Vector3(0f, deltaTime * 45f, 0f));
            FollowCam(deltaTime);

            //camLocator.position = HandleCollisions(playerTr.position + colDetectOffset, camLocator.position);

            if (!bCollidingWithWall)
                camLocator.position = Vector3.Lerp(camLocator.position, camLocatorOrig.position, deltaTime * 80f);
        }
    }

    Vector3 HandleCollisions(Vector3 lookAtObjectPos, Vector3 destCam)
    {
        //if (camState == CamStatesEnum.DONOTHING)
        {
            bCollidingWithWall = false;
            return destCam;
        }

        float camColRadius = 0.05f;
        Vector3 toDestVec = destCam - lookAtObjectPos;
        Ray ray = new Ray(lookAtObjectPos, toDestVec);
        Vector3 collisionProofedPos = destCam;

        // CAM COLLISION
        RaycastHit hitInfo;
        if (Physics.SphereCast(ray, camColRadius, out hitInfo, toDestVec.magnitude, camLayerMask))
        {
            if (!bCollidingWithWall)
                bCollidingWithWall = true;

            collisionProofedPos = hitInfo.point + (camColRadius * hitInfo.normal);
        }
        else if (bCollidingWithWall)
            bCollidingWithWall = false;

        return collisionProofedPos;

    }

    private void FollowCam(float deltaTime)
    {
        HandleCameraShake();

        Vector3 camPosition = Vector3.Lerp(camTr.position, HandleCollisions(playerTr.position + colDetectOffset, camLocator.position), 1 - Mathf.Pow(smoothing, deltaTime));
        camTr.position = camPosition + shakePosition;
        
        Quaternion camRotation = Quaternion.identity;
        if (camState == CamStatesEnum.LOOKATLOCALPLAYER)
            camRotation = Quaternion.Lerp(camTr.rotation, Quaternion.LookRotation(playerTr.position - camTr.position), 1 - Mathf.Pow(rotateSpeed, deltaTime));
        else if (camState == CamStatesEnum.FOLLOWPLAYER)
            camRotation = Quaternion.LookRotation(playerTr.position - camTr.position);
        
        camTr.rotation = camRotation * shakeRotation;
    }

    public void ShakeCam(float power)
    {
        shakeIntensity = power;
        camShake = true;
    }

    void HandleCameraShake()
    {
        if (camShake)
        {
            shakeDecay = shakeIntensity / shakeDur;
            camShake = false;
        }

        float shakeMin = shakeIntensity * (1 - shakeVariation);
        float shakeX = Random.Range(-1f, 1f) * Random.Range(shakeMin, shakeIntensity);
        float shakeY = Random.Range(-1f, 1f) * Random.Range(shakeMin, shakeIntensity);
        float shakeZ = Random.Range(-1f, 1f) * Random.Range(shakeMin, shakeIntensity);

        Vector3 shakeMag = new Vector3(shakeX * shakeAngles.x,
            shakeY * shakeAngles.y,
            shakeZ * shakeAngles.z);

        shakeRotation = Quaternion.Euler(shakeMag);

        shakeIntensity -= shakeDecay * Time.unscaledDeltaTime;
        shakeIntensity = Mathf.Clamp(shakeIntensity, 0, shakeIntensity);
    }
}
