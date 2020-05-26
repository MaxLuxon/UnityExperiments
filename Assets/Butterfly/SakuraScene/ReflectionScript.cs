using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ReflectionScript : MonoBehaviour
{

    Camera reflectionCamera;
    Camera mainCamera;

    RenderTexture renderTarget;

    // Start is called before the first frame update
    void Start(){

        GameObject reflectionCameraGo = new GameObject("ReflectionCamera");
        reflectionCamera = reflectionCameraGo.AddComponent<Camera>();

        mainCamera = Camera.main;
        renderTarget = new RenderTexture(Screen.width, Screen.height, 24);

    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnPostRender() {

        RenderReflection();

    }

    void RenderReflection(){

        reflectionCamera.CopyFrom(mainCamera);

        Vector3 oriCamPos = mainCamera.transform.position;
        oriCamPos.y *= -1;

        Vector3 oriCamDir = mainCamera.transform.forward;
        oriCamDir.y *= -1;

        reflectionCamera.transform.position = oriCamPos;
        reflectionCamera.transform.LookAt(oriCamPos+ oriCamDir, Vector3.down );

        reflectionCamera.targetTexture = renderTarget;


        Shader.SetGlobalTexture("_Reflect", renderTarget);


    }




}
