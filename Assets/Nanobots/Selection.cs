using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Selection : MonoBehaviour {

    float life = 1;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {

        transform.localScale = transform.localScale- Vector3.one*Time.deltaTime;


        if (transform.localScale.x <= 0) {

            Destroy(this.gameObject);
        
        }
		
	}
}
