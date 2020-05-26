using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SakuraScript : MonoBehaviour
{

    public int numberOfButterFlies = 100;
    public GameObject butterflyObject;

    bool active = false;

    List<GameObject> butterFly = new List<GameObject>();
    List<Vector3> momentum = new List<Vector3>();
    List<float> delays = new List<float>();
    List<float> speed = new List<float>();

    float timestampt = 0;

    float butterflyspeed = 3;
    bool slowDown = false;

    public float ps = 1;

    // https://stackoverflow.com/questions/5531827/random-point-on-a-given-sphere
    Vector3 randomSpherePoint(float radius) {
        var u = Random.Range(0.0f,1.0f);
        var v = Random.Range(0.0f, 1.0f);
        var theta = 2 * Mathf.PI * u;
        var phi = Mathf.Acos(2 * v - 1);
        var x =  (radius * Mathf.Sin(phi) * Mathf.Cos(theta));
        var y =  (radius * Mathf.Sin(phi) * Mathf.Sin(theta));
        var z =  (radius * Mathf.Cos(phi));
        return new Vector3(x,y,z);
    }


    // Start is called before the first frame update
    void Start()
    {

		for(int i=0; i<numberOfButterFlies; i++){


            int layer_mask = LayerMask.GetMask("Sakura");

            Vector3 ori = randomSpherePoint(8);

            Vector3 dir = randomSpherePoint(8).normalized;
            if(Vector3.Dot(dir, ori.normalized) > 0)
                dir *= -1;

            Ray ray = new Ray(ori, dir);
            RaycastHit hit = new RaycastHit();

            if(Physics.Raycast(ray, out hit, 1000, layer_mask)) {

                GameObject go = GameObject.Instantiate(butterflyObject);
                go.transform.localScale = Vector3.one * Random.Range(4.0f,7f)*2.3f;
                butterFly.Add(go);

                go.transform.position = hit.point- hit.normal*(Random.Range(0,1.5f)-0.2f);
                go.transform.up = randomSpherePoint(8).normalized+ hit.normal;

                // go.transform.up = hit.normal;
                momentum.Add(go.transform.forward+Vector3.up);
                speed.Add(Random.Range(0.2f,2f));
                delays.Add(Random.Range(0.2f, 12f));


            } else {

                i--;
			}



        }


  

    }

    // Update is called once per frame
    void Update()
    {

		if(Input.GetKeyDown(KeyCode.P)){

            active = !active;
            timestampt = Time.time;

        }


        if(Input.GetKeyDown(KeyCode.O)) {

            slowDown = true;


        }

        if(slowDown)
            butterflyspeed -= butterflyspeed * Time.deltaTime*0.25f;


        if(active){

            transform.position += Vector3.forward * Time.deltaTime*0.35f;

            for(int i = 0; i < butterFly.Count; i++) {

				if(timestampt+delays[i]<Time.time){

					GameObject go = butterFly [i];
					go.transform.position += momentum[i] * Time.deltaTime*0.05f*speed[i]* butterflyspeed;
                    go.transform.LookAt(go.transform.position + momentum [i]);

                    Vector3 p = go.transform.position;

                    momentum [i] += Vector3.up * Time.deltaTime*0.04f;
                    momentum [i] += 2*new Vector3(Mathf.PerlinNoise(p.x * ps + i * 5, p.y * ps) - 0.5f, Mathf.PerlinNoise(p.z * ps, p.y * ps + i * 5) - 0.5f, Mathf.PerlinNoise(p.x * ps + i * 43, p.z * ps) - 0.5f) * Time.deltaTime * 3.9f;
                    momentum [i] -= Vector3.Cross(Vector3.up, new Vector3(p.x, 0, p.z).normalized) * Time.deltaTime*3.75f;
                    momentum [i] -= new Vector3(p.x, 0, p.z).normalized * Time.deltaTime * 5.75f;

                    momentum [i].Normalize();

                }


            }


        }

        
    }
}

