using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Gravity : MonoBehaviour{

    // Avarage moving star velocity 200 km/s
	// Average Star mass 10^15

    public Camera camera;

    public int NumberOfParticle = 100;
    public GameObject Prefab;

    List<GameObject> Trash = new List<GameObject>();


    List<Vector3> positions = new List<Vector3>();
    List<Vector3> Velocity = new List<Vector3>();
    List<GameObject> Objects = new List<GameObject>();
    List<float> Masses = new List<float>();

	public float SimSpeed=1;
    public float G = 1;

    public Vector3 averageImpulse;

    public Material SunMat;

   public float colRadius = 0;

    bool colapse = false;

    // Start is called before the first frame update
    void Start()
    {

       


    }

	public void TriggerExplosion(){


        for(int i = 0; i < NumberOfParticle; i++) {

            GameObject go = GameObject.Instantiate(Prefab);
            go.SetActive(true);
            go.name = "Star";
            Objects.Add(go);

            float q = Random.Range(0, Mathf.PI);
            float p = Random.Range(0, Mathf.PI * 2);

            float x = Mathf.Sin(q) * Mathf.Cos(p);
            float y = Mathf.Sin(q) * Mathf.Sin(p);
            float z = Mathf.Cos(q);


            positions.Add(new Vector3(x, y, z) * Random.Range(0.0f, 1f));
            Velocity.Add(new Vector3(Random.Range(0, 2.0f) - 1, Random.Range(0, 2.0f) - 1, Random.Range(0, 2.0f) - 1) * 8.6f);
            Masses.Add(Mathf.Exp(Random.Range(0.1f, 3.2f)));


        }

    }



    public void TriggerCollapse() {

        colapse = true;


    }


    // Update is called once per frame
    void Update()
    {

		float TimeScale = Time.deltaTime * SimSpeed;


		for(int i=0; i<Trash.Count; i++){


            Trash [i].transform.localScale = Trash [i].transform.localScale - Vector3.one*TimeScale*0.0005f;
			if(Trash [i].transform.localScale.x<0.0f){

                Destroy(Trash [i]);
                Trash.RemoveAt(i);
                i--;



            }


        }


        if(colapse){


            for(int i = 0; i < positions.Count; i++) {

                positions [i] -= positions [i].normalized * TimeScale*5;
                Velocity [i] -= Velocity [i].normalized * TimeScale*2;


			if(positions[i].magnitude<0.02f && Velocity [i].magnitude < 2) {

                    Trash.Add(Objects [i]);



                    positions.RemoveAt(i);
                    Masses.RemoveAt(i);
                    Velocity.RemoveAt(i);
                    Objects.RemoveAt(i);

                    NumberOfParticle--;

                    i--;


                }




            }



        }


        averageImpulse = Vector3.zero;

        for(int i = 0; i < positions.Count; i++) {

            positions [i] += Velocity [i] * TimeScale;

            averageImpulse += Velocity [i] * Masses [i];

            Objects [i].transform.position = positions [i];

            Objects [i].transform.localScale = Vector3.one * Mathf.Clamp(Masses [i] * 0.05f, 0.1f, 0.1f);



        }


        Vector3 impulsCorrection = averageImpulse / positions.Count;


		for(int i = 0; i < positions.Count; i++) {


			Velocity [i] -= (impulsCorrection / Masses [i]);



		}






		for(int i = 0; i < positions.Count; i++) {

            for(int a = i; a < positions.Count; a++) {

                if(a == i) continue;

                Vector3 dir = (positions [a] - positions [i]).normalized;
                float r =Vector3.Distance(positions [a], positions [i])+1;

        

                 Velocity [i] += dir*(Masses [a]/(r*r)) * TimeScale*G;
				 Velocity [a] -= dir*(Masses [i]/(r*r)) * TimeScale*G;



            }


        }

		/*

		if(Random.Range(0,100)<5 && positions.Count > 20){

            int a = Random.Range(0, positions.Count);
            int i = Random.Range(0, positions.Count);


			if(a!=i && Mathf.Min(positions [i].magnitude,positions[a].magnitude)>50) {

                float vx = (Masses [i] * Velocity [i].x + Masses [a] * Velocity [a].x) / (Masses [a] + Masses [i]);
                float vy = (Masses [i] * Velocity [i].y + Masses [a] * Velocity [a].y) / (Masses [a] + Masses [i]);
                float vz = (Masses [i] * Velocity [i].z + Masses [a] * Velocity [a].z) / (Masses [a] + Masses [i]);


                Velocity [i] = new Vector3(vx, vy, vz);
                positions [i] = Vector3.Lerp(positions [a], positions [i], Masses [i] / (Masses [a] + Masses [i]));

                Masses [i] = Masses [i] + Masses [a];


                Destroy(Objects [a]);

                positions.RemoveAt(a);
                Masses.RemoveAt(a);
                Velocity.RemoveAt(a);
                Objects.RemoveAt(a);

                NumberOfParticle--;


                Debug.Log("Random Collision");

            }


        }


		*/

        for(int i = 0; i < positions.Count; i++) {

            if(Vector3.Distance(positions [i], Vector3.zero) >900) {

				/*
                float q = Random.Range(0, Mathf.PI);
                float p = Random.Range(0, Mathf.PI * 2);

                float x = Mathf.Sin(q) * Mathf.Cos(p);
                float y = Mathf.Sin(q) * Mathf.Sin(p);
                float z = Mathf.Cos(q);


                positions [i] = new Vector3(x, y, z) * (300+Random.Range(0,200));
                Velocity [i] = new Vector3(Random.Range(0, 2.0f) - 1, Random.Range(0, 2.0f) - 1, Random.Range(0, 2.0f) - 1);
                Masses [i] = Random.Range(0.1f, 4);


                Destroy(Objects [i]);

                GameObject go = GameObject.Instantiate(Prefab);

                go.name = "Star";
                Objects [i] = go;
                go.transform.position = positions [i];

				*/


                Destroy(Objects [i]);

                positions.RemoveAt(i);
                Masses.RemoveAt(i);
                Velocity.RemoveAt(i);
                Objects.RemoveAt(i);

                NumberOfParticle--;

                i--;

                continue;

			}

            /*


                for(int a = i; a < positions.Count; a++) {

                if (a == i) continue;



                float dcenter = Mathf.Min( (positions [a].magnitude + positions [i].magnitude)/2, 200)/10;
                float d = Vector3.Distance(positions [a], positions [i]);

                if(Mathf.PerlinNoise(i*0.1f,a * 0.1f) >0.2f && d< 30* colRadius / (Masses [i] + Masses [a])) {

					// Conservation of Implulse
					
                   float vx = (Masses[i]*Velocity[i].x+ Masses [a] * Velocity [a].x)/(Masses[a]+Masses[i]);
                    float vy = (Masses [i] * Velocity [i].y + Masses [a] * Velocity [a].y) / (Masses [a] + Masses [i]);
                    float vz = (Masses [i] * Velocity [i].z + Masses [a] * Velocity [a].z) / (Masses [a] + Masses [i]);


                    Velocity [i] = new Vector3(vx,vy,vz);
                    positions [i] = Vector3.Lerp(positions [a], positions [i], Masses [i]/(Masses [a] + Masses [i]));

                    Masses [i] = Masses [i]+ Masses [a];


				


                    
                    Destroy(Objects [a]);

                    positions.RemoveAt(a);
                    Masses.RemoveAt(a);
                    Velocity.RemoveAt(a);
                    Objects.RemoveAt(a);

                    NumberOfParticle--;


                    if(a>0){

						a--;
						if(i > a) {

							i--;

						}
                    }

	

                  //  Debug.Log("Collision");

                    continue;

	

                }


            }

		*/


        }




    }
}
