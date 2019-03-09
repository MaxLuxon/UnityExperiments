using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Cell : MonoBehaviour {


    public float speed = 1;
    public float distance = 7;
    float angle = 0;
    float angleV = 0;

    public float targetV;
    public float targetH;

    public float perlinOffset = 0;

    Vector2 perlinSeed = new Vector2();

	// Use this for initialization
	void Start () {

        perlinSeed = new Vector2(Random.Range(0, 2000),Random.Range(0, 2000));
		
	}
	
	// Update is called once per frame
	void Update () {


        angle = Mathf.LerpAngle(angle/Mathf.PI*180,targetH/ Mathf.PI * 180,Time.deltaTime*speed);
        angle = angle / 360 * Mathf.PI * 2;

        angleV = Mathf.LerpAngle(angleV / Mathf.PI * 180, targetV / Mathf.PI * 180, Time.deltaTime*speed);
        angleV = angleV / 360 * Mathf.PI * 2;

        perlinOffset -= perlinOffset * Time.deltaTime*0.5f;

        angle += (Mathf.PerlinNoise(angle*4+perlinSeed.x, angleV* 4+perlinSeed.y)-0.5f) * perlinOffset*0.03f;
        angleV += (Mathf.PerlinNoise(angle*4+300+perlinSeed.x, angleV* 4-3434+perlinSeed.y)-0.5f) * perlinOffset*0.03f;


        float phi = angle - Mathf.PI * 0.5f;
        float theta = angleV ;

        float xDir = Mathf.Sin(theta) * Mathf.Cos(phi);
        float zDir = Mathf.Sin(theta) * Mathf.Sin(phi);
        float yDir = Mathf.Cos(theta);

        transform.position = new Vector3(xDir, yDir, -zDir) * distance;
        transform.LookAt(Vector3.zero);
		
	}
}
