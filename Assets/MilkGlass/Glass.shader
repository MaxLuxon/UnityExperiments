Shader "Custom/Glass" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0

        _Color2 ("Color2", Color) = (1,1,1,1)

        _Radius ("Radius", Range(0,0.1)) = 0.0
        _StructureSize("StructureSize", float) =1
        _StepSize("_StepSize", float) =1

        _VectorTex ("_VectorTex (RGB)", 2D) = "white" {}

	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows vertex:vert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
            float4 screenPos;
            float3 worldPos;
                        float3 lvertex;


		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
                fixed4 _Color2;
                sampler2D _VectorTex;

          void vert (inout appdata_full v, out Input o) {

             UNITY_INITIALIZE_OUTPUT(Input,o);

                   o.lvertex = v.vertex.xyz;

          

            }

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

        sampler2D BG_Texture;
        float _Radius;

          float _StructureSize;
          float _StepSize;

            float4 sampleStructure(float3 position){


                return tex2D(_MainTex,half2(1.2,1)*position.xz*_StructureSize+tex2D(_MainTex, position.xy*half2(0.3,0.3)).rg*_StructureSize
                +tex2D(_MainTex, position.yz*0.4+float2(_Time.x*0.2,0)).gb*_StructureSize)*0.5+tex2D(_MainTex, position.yz*0.4*_StructureSize*0.02+float2(_Time.x*0.2,0)).g*0.5;

            }


		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color

            float2 screenUV = IN.screenPos.xy / IN.screenPos.w;

            half2 fTaps_Poisson[12];
    fTaps_Poisson[0]  = half2(-.326,-.406);
    fTaps_Poisson[1]  = half2(-.840,-.074);
    fTaps_Poisson[2]  = half2(-.696, .457);
    fTaps_Poisson[3]  = half2(-.203, .621);
    fTaps_Poisson[4]  = half2( .962,-.195);
    fTaps_Poisson[5]  = half2( .473,-.480);
    fTaps_Poisson[6]  = half2( .519, .767);
    fTaps_Poisson[7]  = half2( .185,-.893);
    fTaps_Poisson[8]  = half2( .507, .064);
    fTaps_Poisson[9]  = half2( .896, .412);
    fTaps_Poisson[10] = half2(-.322,-.933);
    fTaps_Poisson[11] = half2(-.792,-.598);


               float3x3 inverseMat;
                inverseMat[0]= unity_ObjectToWorld[0].xyz;
                inverseMat[1]= unity_ObjectToWorld[1].xyz;
                inverseMat[2]= unity_ObjectToWorld[2].xyz;

                inverseMat= transpose(inverseMat);

    float3 view= normalize(IN.worldPos-_WorldSpaceCameraPos);
      float3 lview=  mul(inverseMat, -view );

			fixed4 c = tex2D (BG_Texture, screenUV);
            half rim = 1.0 - saturate(dot (-view, o.Normal));

            c+= pow(rim,3)*0.3;
   
			o.Emission = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
