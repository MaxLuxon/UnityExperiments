using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class BGRenderer : MonoBehaviour {

    public Material BGMaterial;

	
    RenderTexture renderTexture1;
    RenderTexture renderTexture2;
    CommandBuffer buf;
    Camera camera;
    public float blurScale = 1;

    public Material material;

    // Use this for initialization
    void Start()
    {

        renderTexture1 = new RenderTexture(1920, 1080, 16);
        renderTexture1.filterMode = FilterMode.Bilinear;

        renderTexture2 = new RenderTexture(1920, 1080, 16);
        renderTexture2.filterMode = FilterMode.Bilinear;


        CommandBuffer buf = new CommandBuffer();
        buf.name = "Grab screen";

        int screenCopyID = Shader.PropertyToID("_ScreenCopyTexture");
        buf.GetTemporaryRT(screenCopyID, -1, -1, 0, FilterMode.Bilinear);

        buf.Blit(BuiltinRenderTextureType.CurrentActive, renderTexture1);

        buf.SetGlobalVector("_Dir", new Vector4(0, 0.4f, 0, 0));
        buf.Blit(renderTexture1, renderTexture2, material);

        //buf.SetGlobalVector("_Dir", new Vector4(0, 0.2f * blurScale, 0, 0));
        //buf.Blit(renderTexture2, renderTexture1, material);

        buf.SetGlobalVector("_Dir", new Vector4(0.1f, 0, 0, 0));
        buf.Blit(renderTexture2, renderTexture1, material);


        buf.SetGlobalVector("_Dir", new Vector4(0, 0.7f, 0, 0));
        buf.Blit(renderTexture1, renderTexture2, material);
        //buf.SetGlobalVector("_Dir", new Vector4(0, 0.1f * blurScale, 0, 0));
        //buf.Blit(renderTexture2, renderTexture1, material);

        //buf.SetGlobalTexture("_waterTex", renderTexture1);

        GetComponent<Camera>().AddCommandBuffer(CameraEvent.AfterEverything, buf);

        camera = GetComponent<Camera>();
        camera.depthTextureMode = DepthTextureMode.Depth;

        BGMaterial.SetTexture("_EmissionMap", renderTexture2);



    }

	// Update is called once per frame
	void Update () {
		
	}
}
