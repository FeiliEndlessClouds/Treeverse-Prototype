using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShowPing : MonoBehaviour
{
    public Client_NetworkManager Manager;
    public TMPro.TextMeshProUGUI TextMeshPRO;

    private Client_PlayerEntity Player;



    // Update is called once per frame
    void Update()
    {
        if(Player == null)
        {
            Player = FindObjectOfType<Client_PlayerEntity>();
        }

        if (Player != null) {
            TextMeshPRO.text = $"Ping: {Manager.RoundTripTime} ms\nX: {Mathf.RoundToInt(Player.transform.position.x)} Y: {Mathf.RoundToInt(Player.transform.position.z)}";
        }
    }
}
