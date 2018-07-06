using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RenderQueue : MonoBehaviour {

	// Use this for initialization
	void Start () {

        GetComponent<MeshRenderer>().material.renderQueue = 3200;

	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
