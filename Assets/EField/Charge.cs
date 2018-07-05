using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Charge : MonoBehaviour {

    public Vector3 moveDir;
    public float SpeedFactor=1;

	// Use this for initialization
	void Start () {

        SpeedFactor =   Random.Range(0, 100) / 50.0f -1;
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
