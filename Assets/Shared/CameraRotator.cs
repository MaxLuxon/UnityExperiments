using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraRotator : MonoBehaviour {

	public Transform center;
	public float radius =5;
	public float speed=1;

	float _time=0;
	float _internalRadius=5;

	void Start () {

		_internalRadius = radius;
		
	}

	void Update () {

		_internalRadius += Input.GetAxis("Mouse ScrollWheel");

		_time += Time.deltaTime*speed;
		transform.position = center.transform.position + new Vector3 (Mathf.Sin(_time),0,Mathf.Cos(_time))*radius;
		transform.LookAt (center.position);
	
	}
}
