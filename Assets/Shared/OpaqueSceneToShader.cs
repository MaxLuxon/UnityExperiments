using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class OpaqueSceneToShader : MonoBehaviour {

	// Use this for initialization
	void Start () {

		CommandBuffer buf = new CommandBuffer();
		buf.name = "Grab screen";

		int screenCopyID = Shader.PropertyToID("_ScreenCopyTexture");
		buf.GetTemporaryRT (screenCopyID, -1, -1, 0, FilterMode.Bilinear);
		buf.Blit (BuiltinRenderTextureType.CurrentActive, screenCopyID);

		buf.SetGlobalTexture("BG_Texture", screenCopyID);

		GetComponent<Camera>().AddCommandBuffer (CameraEvent.BeforeForwardAlpha, buf);

	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
