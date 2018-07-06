using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Orbiter : MonoBehaviour {

	public Transform center;
	public float radius;
	public float speed;
	public bool lookat=false;

	public Vector3 axis= new Vector3(0,1,0);
	Vector3 RotFac= new Vector3(0,1,0);

	public Vector3 offset= new Vector3(0,1,0);


	float ecpl=0;

	// Use this for initialization
	void Start () {


        RotFac = new Vector3(1, 1, 1) - axis;
        RotFac.Normalize();

	}
	
	// Update is called once per frame
	void Update () {

   
		ecpl += Time.deltaTime*speed;

		float x = Mathf.Cos (ecpl*Mathf.PI*2);
		float y = Mathf.Sin (ecpl*Mathf.PI*2);

        transform.position = center.position + new Vector3 (x*RotFac.x,y*RotFac.y,y*RotFac.z)*radius+offset;


		if (lookat)
			transform.LookAt (center.position);

	}
}
