using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

[ExecuteInEditMode]
public class PreRenderer : MonoBehaviour {

    RenderTexture renderTexture1;
    RenderTexture renderTexture2;
    CommandBuffer buf;
    Camera camera;

    public Material material;

	// Use this for initialization
	void Start () {

        renderTexture1 = new RenderTexture(340, 340, 16);
        renderTexture1.filterMode = FilterMode.Bilinear;

        renderTexture2 = new RenderTexture(340, 340, 16);
        renderTexture2.filterMode = FilterMode.Bilinear;


        CommandBuffer buf = new CommandBuffer();
        buf.name = "Grab screen";

        int screenCopyID = Shader.PropertyToID("_ScreenCopyTexture");
        buf.GetTemporaryRT (screenCopyID, -1, -1, 0, FilterMode.Bilinear);

        buf.Blit (BuiltinRenderTextureType.CurrentActive, renderTexture1);

        buf.SetGlobalVector("_Dir", new Vector4(0.2f, 0, 0, 0));
        buf.Blit(renderTexture1, renderTexture2,material);

        buf.SetGlobalVector("_Dir", new Vector4(0, 0.2f, 0, 0));
        buf.Blit(renderTexture2, renderTexture1, material);

        buf.SetGlobalVector("_Dir", new Vector4(0.4f, 0, 0, 0));
        buf.Blit(renderTexture1, renderTexture2, material);

        buf.SetGlobalVector("_Dir", new Vector4(0, 0.4f, 0, 0));
        buf.Blit(renderTexture2, renderTexture1, material);

        buf.SetGlobalTexture("_waterTex", renderTexture1);

        GetComponent<Camera>().AddCommandBuffer (CameraEvent.AfterImageEffectsOpaque, buf);

        camera = GetComponent<Camera> ();
        camera.depthTextureMode = DepthTextureMode.Depth;
    
		
	}
	
    void LateUpdate()
    {


        var matrix = GetComponent<Camera>().cameraToWorldMatrix;
        Shader.SetGlobalMatrix("_InverseView", matrix);

    }

	// Update is called once per frame
	void Update () {
		
	}
}
