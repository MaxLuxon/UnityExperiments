using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlanetOrbiter : MonoBehaviour {

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



	}
	
	// Update is called once per frame
	void Update () {

        RotFac = new Vector3(1, 1, 1) - axis;
        RotFac.Normalize();

		ecpl += Time.deltaTime*speed;

		float x = Mathf.Cos (ecpl*Mathf.PI*2);
		float y = Mathf.Sin (ecpl*Mathf.PI*2);

        transform.position = center.position + new Vector3 (x*axis.x,y*axis.y,y*axis.z)*radius+offset;

		Shader.SetGlobalVector ("Moon", new Vector4 (x,y*0.5f,y,0)*radius);

		if (lookat)
			transform.LookAt (center.position);

	}
}
