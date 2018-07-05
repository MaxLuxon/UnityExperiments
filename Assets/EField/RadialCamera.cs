using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RadialCamera : MonoBehaviour {

    public float distance = 7;
    public float angle = 0;
    public bool autoRotate = false;

    float momentum = 0;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {

        if (autoRotate) { 
        
            momentum = 0.5f;

        }

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
