using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Lighting : MonoBehaviour {

    public GameObject Object;
    float life = 1;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {

        Object.transform.localScale = new Vector3(100, Random.Range(0, 200)-100, 60);
        Color color = Object.GetComponent<MeshRenderer>().material.GetColor("_TintColor");
        Object.GetComponent<MeshRenderer>().material.SetColor("_TintColor",new Color(color.r,color.g,color.b,life*0.5f));

        life -= 1.7f * Time.deltaTime;

        if (life <= 0) {

            Destroy(this.gameObject);
        
        }
		
	}
}
