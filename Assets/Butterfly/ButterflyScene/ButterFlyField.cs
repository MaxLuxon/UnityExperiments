using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ButterFlyField : MonoBehaviour
{

    public GameObject prefab;
    List<GameObject> butterFlys = new List<GameObject>();

    List<Vector3> positions = new List<Vector3>();
    List<Vector3> momentum = new List<Vector3>();
    List<float> leader = new List<float>();
    List<float> velo = new List<float>();


    public float minSwarmDistance = 0.7f;
    public float ps = 0.7f;
    public float ms = 2.7f;
    public float lf = 2.7f;
    public float cf = 2.7f;

    public int numberOfButterFlies = 100;


    int tick = 0;
    // Start is called before the first frame update
    void Start()
    {

		for(int i=0; i<numberOfButterFlies; i++){

            butterFlys.Add(GameObject.Instantiate(prefab));
            positions.Add(new Vector3(Random.Range(0, 2.0f) - 1, Random.Range(0, 2.0f) - 1, Random.Range(0, 2.0f) - 1));
            momentum.Add(new Vector3(Random.Range(0, 2.0f) - 1, Random.Range(0, 2.0f) - 1, Random.Range(0, 2.0f) - 1).normalized);
            leader.Add(1);

            velo.Add(Mathf.Pow(Random.Range(0.4f, 1.0f), 1.4f));

        }

        for(int i = 0; i < numberOfButterFlies; i++) {

            butterFlys [i].transform.localScale = Vector3.one * Random.Range(0.6f, 2.0f);




            }



    }

    // Update is called once per frame
    void Update()
    {

        for(int a = 0; a < numberOfButterFlies; a++) {

            butterFlys [a].transform.position = positions [a];
            butterFlys [a].transform.LookAt(positions [a]+ momentum [a], Vector3.up);


            positions [a] += momentum [a] * Time.deltaTime * 0.05f * velo [a]* ms;


        }


       
        tick+=50;
        tick = tick % numberOfButterFlies;



		for(int i=tick; i<tick+50; i++){

        Vector3 center = new Vector3(Mathf.PerlinNoise(i * 5.24534f * ps, 0) - 0.5f, Mathf.PerlinNoise(i * 6.24534f * ps, 0) - 0.5f, Mathf.PerlinNoise(i * 3.24534f * ps, 0) - 0.5f) * 0.3f;



        // if(Vector3.Dot(positions [i].normalized, momentum [i])+0.5f > 0)
        if(Vector3.Distance(center, positions [i]) > 0.2f)
            momentum [i] -= (positions [i] - center).normalized * Time.deltaTime * 0.9f* cf*Mathf.Max((1/(Vector3.Distance(center, positions [i])*0.1f)));

        Vector3 avMom = momentumOfNearestButterFlys(positions [i], minSwarmDistance, i);
        momentum [i] += avMom.normalized * Time.deltaTime * 0.8f * leader [i]*lf;


        momentum [i] += (1 - leader [i]) * new Vector3(Mathf.PerlinNoise(positions [i].x * ps + i * 5, positions [i].y * ps) - 0.5f, Mathf.PerlinNoise(positions [i].z * ps, positions [i].y * ps + i * 5) - 0.5f, Mathf.PerlinNoise(positions [i].x * ps + i * 43, positions [i].z * ps) - 0.5f) * Time.deltaTime * 0.9f;


        momentum [i].Normalize();

        }


    }


	Vector3 momentumOfNearestButterFlys(Vector3 pos, float maxDistance, int exlucde){

        Vector3 outMom= Vector3.zero;

        for(int i = 0; i < numberOfButterFlies; i+=1) {

            if(i == exlucde)
                continue;

			if(Vector3.Distance(butterFlys [i].transform.position,pos)<maxDistance){


                outMom += (momentum [i]*0.1f+ (butterFlys [i].transform.position- pos).normalized);


            }

      
        }

        return outMom;
    }


}
