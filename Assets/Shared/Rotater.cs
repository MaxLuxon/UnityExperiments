using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotater : MonoBehaviour {

	public float speed=1;
	public float dir=1;
	public Vector3 axis= new Vector3(0,1,0);


	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {

		transform.eulerAngles += axis * Time.deltaTime*dir*speed;
		
	}
}
