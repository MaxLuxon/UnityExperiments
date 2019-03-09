using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CellController : MonoBehaviour {


    public List<Cell> cells;
    public List<Cell> bcells;

    int control=0;

    public GameObject lightPerfab;
    public GameObject select;

    List<Vector2> offsets = new List<Vector2>();

	// Use this for initialization
	void Start () {

        offsets.Add(new Vector2(0,0));
        offsets.Add(new Vector2(1, 0).normalized*0.1f);
        offsets.Add(new Vector2(1, 1).normalized * 0.1f);
        offsets.Add(new Vector2(0, 1).normalized * 0.1f);
        offsets.Add(new Vector2(1, -1).normalized * 0.1f);
        offsets.Add(new Vector2(0, -1).normalized * 0.1f);
        offsets.Add(new Vector2(-1, -1).normalized * 0.1f);
        offsets.Add(new Vector2(-1, 0).normalized * 0.1f);
        offsets.Add(new Vector2(-1, 1).normalized * 0.1f);



	}
	
	// Update is called once per frame
	void Update () {

        if (Input.GetKeyDown(KeyCode.Alpha1))
        {

            control = 0;

        }
        else if (Input.GetKeyDown(KeyCode.Alpha2)) { 
        
            control = 1;

        }


        int random = Random.Range(1, 70);


        if (random == 20) { 

            float phi = Random.Range(0,6.7f);
            float theta = Random.Range(0, 6.7f);

            float xDir = Mathf.Sin(theta) * Mathf.Cos(phi);
            float zDir = Mathf.Sin(theta) * Mathf.Sin(phi);
            float yDir = Mathf.Cos(theta);
        
            GameObject light = Instantiate(lightPerfab);

            light.transform.position = new Vector3(xDir, yDir, -zDir) * 2.34f;
            light.transform.up = new Vector3(xDir, yDir, -zDir).normalized;
        
        }

        if (Input.GetMouseButtonDown(0)) { 
        
            RaycastHit hit;
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);

            if (Physics.Raycast(ray, out hit))
            {
                Transform objectHit = hit.transform;

                GameObject selectCop = Instantiate(select);

                selectCop.transform.position = hit.point;
               

                float angle = Mathf.Atan2(hit.point.x,hit.point.z);

                float polar = Mathf.Acos(hit.point.y / 2.34f);

                if (control == 0)
                {
                    int count = 0;
                    foreach (Cell cell in cells)
                    {

                        cell.targetH = angle + offsets[count].x;
                        cell.targetV = polar + offsets[count].y;
                        cell.perlinOffset = 1;

                        count++;

                    }

                }
                else { 
                
                    int count = 0;
                    foreach (Cell cell in bcells)
                    {

                        cell.targetH = angle + offsets[count].x;
                        cell.targetV = polar + offsets[count].y;
                        cell.perlinOffset = 1;

                        count++;

                    }
                
                }

                // Do something with the object that was hit by the raycast.
            }
        
        
        }


		
	}
}
