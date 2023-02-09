using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraFollow : MonoBehaviour
{
    Camera m_Camera;
    [SerializeField] float cameraDistence;
	[SerializeField] float cameraOffset;

	// Start is called before the first frame update
	void Start()
    {
        m_Camera = Camera.main;
    }

    // Update is called once per frame
    void LateUpdate()
    {
        m_Camera.transform.position = transform.position + m_Camera.transform.forward * cameraDistence + m_Camera.transform.up * cameraOffset;
    }
}
