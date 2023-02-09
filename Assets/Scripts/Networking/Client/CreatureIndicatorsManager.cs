//using System.Collections;
//using System.Collections.Generic;
//using UnityEngine;

//public class CreatureIndicatorsManager : MonoBehaviour
//{
//    [SerializeField]
//    DTT.AreaOfEffectRegions.LineRegion LineIndicator;

//    [SerializeField]
//    DTT.AreaOfEffectRegions.CircleRegion CircleIndicator;

//    public void ShowLineIndicator(float angle, float range)
//    {
//        LineIndicator.Angle = angle;
//        LineIndicator.Length = range;
//        LineIndicator.FillProgress = range / 5.0f;
//        LineIndicator.gameObject.SetActive(true);

//        CircleIndicator.FillProgress = range / 5.0f;
//        CircleIndicator.gameObject.SetActive(true);
//    }

//    public void HideLineIndicator()
//    {
//        LineIndicator.gameObject.SetActive(false);

//        CircleIndicator.gameObject.SetActive(false);
//    }

//    private void LateUpdate()
//    {
//        transform.rotation = Quaternion.identity;
//    }
//}
