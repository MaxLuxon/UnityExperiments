using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CellCamController : MonoBehaviour {

    public float distance = 7;
    float angle = 0;

    float momentum = 0;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {


        if (Input.GetKey(KeyCode.A)) {

            momentum = -1;

        }

        if (Input.GetKey(KeyCode.D))
        {

            momentum = 1;

        }

        momentum -= momentum * 0.1f;

        angle += momentum*Time.deltaTime;

        float xDir = Mathf.Sin(angle);
        float yDir = Mathf.Cos(angle);

        transform.position = new Vector3(xDir,0, -yDir)*distance;
        transform.LookAt(Vector3.zero);

	}
}
