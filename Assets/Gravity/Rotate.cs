using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotate : MonoBehaviour
{

    public float ratation = -0.7f;
    public float speed = 0.3f;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {

        ratation += Time.deltaTime* speed;

        float x = Mathf.Sin(ratation);
        float y = Mathf.Cos(ratation);

        //GetComponent<Camera>().fieldOfView += Time.deltaTime;

        transform.position = new Vector3(x,0,y)*150;
        transform.LookAt(Vector3.zero);


    }
}
