using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EField : MonoBehaviour {

	public float NumberOfParticles = 500;

	public float ParticleVelocity = 1;
    public float VectorFieldScale = 1;

	public int Behavior = 0;

    public bool paused = false;

    public GameObject ChargePrefab;
    List<GameObject> charges = new List<GameObject>();

	// Use this for initialization
	void Start () {

        for (int i = 0; i < NumberOfParticles; i++) {

            GameObject go = GameObject.Instantiate(ChargePrefab);

            go.GetComponent<Charge>().moveDir = new Vector3(Random.Range(0,100)/50.0f-1,Random.Range(0, 100) / 50.0f - 1,Random.Range(0, 100) / 50.0f - 1);
            go.transform.parent = transform;
            go.transform.position = 0.01f*go.GetComponent<Charge>().moveDir;
            go.GetComponent<Charge>().moveDir.Normalize();

            charges.Add(go);
        
        }
		
	}

    Vector3 getVectorField(Vector3 position) {

        Vector3 p = VectorFieldScale*position;

        Vector3 p1 = new Vector3(Mathf.PerlinNoise(-p.x, p.y), Mathf.PerlinNoise(p.z, p.y), Mathf.PerlinNoise(-p.z, p.x)) * 2 - Vector3.one;
        Vector3 p2 = new Vector3(Mathf.PerlinNoise(p.x*5, -p.y*5), Mathf.PerlinNoise(-p.z*5, p.y*5), Mathf.PerlinNoise(p.x*5, -p.z*5)) * 2 - Vector3.one;
        Vector3 p3 = new Vector3(Mathf.PerlinNoise(-p.z*0.5f, p.x* 0.5f), Mathf.PerlinNoise(p.y* 0.5f, p.x* 0.5f), Mathf.PerlinNoise(-p.y* 0.5f, p.z* 0.5f)) * 2 - Vector3.one;

        return p1+p2*3f+p3*1.3f;
    
    }
	
	// Update is called once per frame
	void Update () {

        if(Input.GetKeyDown(KeyCode.P)){

            paused = !paused;
        
        }

		if (Input.GetKeyDown(KeyCode.Alpha0)) Behavior = 0;
        if (Input.GetKeyDown(KeyCode.Alpha1)) Behavior = 1;
        if (Input.GetKeyDown(KeyCode.Alpha2)) Behavior = 2;
        if (Input.GetKeyDown(KeyCode.Alpha3)) Behavior = 3;
        if (Input.GetKeyDown(KeyCode.Alpha4)) Behavior = 4;

        if (paused) return;

        for (int i = 0; i < charges.Count; i++){

                GameObject go = charges[i];

			if (Behavior == 0) {
            
				Vector3 vectorField = getVectorField(go.transform.position) * 7;

				go.GetComponent<Charge>().moveDir += -go.GetComponent<Charge>().moveDir * 0.9f * Time.deltaTime + vectorField * go.GetComponent<Charge>().SpeedFactor * Time.deltaTime * 1;
				go.GetComponent<Charge>().moveDir.Normalize();

				go.transform.position += go.GetComponent<Charge>().moveDir * Time.deltaTime*ParticleVelocity;

			}else if (Behavior == 1) {

                Vector3 vectorField = getVectorField(go.transform.position*0.05f) * 7;

                go.GetComponent<Charge>().moveDir += -go.GetComponent<Charge>().moveDir * 0.98f * Time.deltaTime + vectorField * go.GetComponent<Charge>().SpeedFactor * Time.deltaTime * 1;
                go.GetComponent<Charge>().moveDir.Normalize();

                go.transform.position += go.GetComponent<Charge>().moveDir * Time.deltaTime*2.5f*ParticleVelocity;

            }else if (Behavior == 2) {

                Vector3 vectorField = getVectorField(go.transform.position*0.4f) * 7;

                go.GetComponent<Charge>().moveDir += vectorField * go.GetComponent<Charge>().SpeedFactor * Time.deltaTime * 1-go.transform.position*1.7f*Time.deltaTime;
                go.GetComponent<Charge>().moveDir.Normalize();

                go.transform.position += go.GetComponent<Charge>().moveDir * Time.deltaTime*3*ParticleVelocity;

            }else if (Behavior == 3) {

                Vector3 vectorField = getVectorField(go.transform.position*0.4f) * 7;

                go.GetComponent<Charge>().moveDir = vectorField * go.GetComponent<Charge>().SpeedFactor * Time.deltaTime * 0.2f-go.transform.position*1.7f*Time.deltaTime;
                //go.GetComponent<Charge>().moveDir.Normalize();

                go.transform.position += go.GetComponent<Charge>().moveDir * Time.deltaTime*ParticleVelocity*30;

            } else if (Behavior == 4) { 
           
                go.transform.position += go.GetComponent<Charge>().moveDir * Time.deltaTime*0.5f*ParticleVelocity;

                Vector3 vectorField = getVectorField(go.transform.position);

                go.GetComponent<Charge>().moveDir +=-go.GetComponent<Charge>().moveDir *0.99f*Time.deltaTime+ vectorField*go.GetComponent<Charge>().SpeedFactor*Time.deltaTime*20-go.transform.position*1.7f*Time.deltaTime;

            
            }           

        }
		
	}
}
