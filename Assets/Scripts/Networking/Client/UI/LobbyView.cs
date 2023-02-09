using TMPro;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.UIElements;

namespace Networking.Client.UI
{
    public class LobbyView : MonoBehaviour
    {

        // Start is called before the first frame update
        void Start()
        {
        
        }

        // Update is called once per frame
        void Update()
        {
        
        }

        private void OnEnable()
        {

            // var playerInfo = AssetDatabase.LoadAssetAtPath<VisualTreeAsset>("Assets/UXML/Templates/PlayerInfo.uxml");
            VisualElement root = GetComponent<UIDocument>().rootVisualElement;
            GroupBox blueTeamArea = root.Q("BlueTeam")! as GroupBox;
            VisualElement bluePlayer1 = root.Q("PlayerInfo1");
            bluePlayer1.Q<Label>("Name").text = "Player 1";

            VisualElement bluePlayer2 = root.Q("PlayerInfo2");
            VisualElement bluePlayer3 = root.Q("PlayerInfo3");

            VisualElement redTeamArea = root.Q("RedTeam");
            VisualElement redPlayer1 = root.Q("PlayerInfo1");
            VisualElement redPlayer2 = root.Q("PlayerInfo2");
            VisualElement redPlayer3 = root.Q("PlayerInfo3");

        }
    }
}
