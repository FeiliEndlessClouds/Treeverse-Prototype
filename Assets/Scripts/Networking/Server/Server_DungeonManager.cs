//using System;
//using System.Collections;
//using System.Collections.Generic;
//using System.Threading.Tasks;
//using Networking.Server.Packets;
//using Networking.Shared.Packets;
//using UnityEngine;
//using UnityEngine.SceneManagement;

//namespace Networking.Server
//{
//	public class Server_DungeonManager : MonoBehaviour
//	{
//		private Server_NetworkManager _serverNetworkManager;

//		private Dictionary<int, Vector3> _dungeonPositions = new Dictionary<int, Vector3>();

//		public void Initialize(Server_NetworkManager serverNetworkManager)
//		{
//			_serverNetworkManager = serverNetworkManager;
//		}

//		private bool _ongoing;

//		private int matchId = 1;

//		// public IEnumerator ChangeScene(Server_PlayerEntity playerEntity)
//		// {
//		// 	yield return 0;
//		// 	playerEntity.ChangeScene("Dungeon1", true, _dungeonPositions[matchId]);
//		// }

//		public void JoinDungeonHandler(Server_PlayerEntity playerEntity)
//		{
//			var dungeonExists = _dungeonPositions.ContainsKey(matchId);

//			if (dungeonExists)
//			{
//				playerEntity.SetPosition(_dungeonPositions[matchId]);
//				// StartCoroutine(ChangeScene(playerEntity));
//				playerEntity.ChangeScene("Dungeon1", true, _dungeonPositions[matchId]);
//			}
//			else
//			{
//				if (!_ongoing)
//				{
//					_ongoing = true;
//					SceneManager.LoadSceneAsync("Dungeon1", LoadSceneMode.Additive).completed += (asyncOperation) =>
//					{
//						var dungeon = GameObject.Find("Root");
//						dungeon.name = "Dungeon" + matchId;
//						var dungeonPosition = new Vector3(matchId * 100, 0, matchId * 100);
//						dungeon.transform.position = dungeonPosition;
//						_dungeonPositions[matchId] = dungeonPosition;
//						playerEntity.SetPosition(dungeonPosition);
//						_ongoing = false;
//						playerEntity.ChangeScene("dungeon1", true, dungeonPosition);
//					};
//				}
//			}
//		}
//	}
//}