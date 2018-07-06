using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RandomRotation : MonoBehaviour {

    float coolDown = 1;
    Color mainColor;
	// Use this for initialization
	void Start () {
        mainColor = GetComponent<MeshRenderer>().material.GetColor("_TintColor");
        coolDown += Random.Range(0,500)/100.0f;

	}
	
	// Update is called once per frame
	void Update () {

        coolDown -= Time.deltaTime*3;

        if (coolDown < 1)
        {
            GetComponent<MeshRenderer>().material.SetColor("_TintColor", mainColor * coolDown);
        }
        if (coolDown < 0) {


            transform.eulerAngles = new Vector3(Random.Range(0, 360), Random.Range(0, 360), Random.Range(0, 360));
            coolDown += Random.Range(0, 500) / 100.0f;
        }
		
	}
}
