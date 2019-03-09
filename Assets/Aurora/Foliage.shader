Shader "Hex/Foliage" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
	
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
                _VarMap ("_VarMap", 2D) = "white" {}
                        _VarAmount ("_VarAmount", Range(0,1)) = 0.5
                                                _VarScale ("_VarScale", float) = 0.5

		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
	         _Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
                     _Normal ("_Normal", 2D) = "bump" {}
                                             _WindAmount ("_WindAmount", Range(0,1)) = 1

    }
    
	SubShader {
		
        Tags { "Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout" }
		LOD 200

        Cull Off

		CGPROGRAM
		#pragma surface surf  Standard fullforwardshadows vertex:vert alphatest:_Cutoff
		#pragma target 3.0

        #include "UnityCG.cginc"
        #include "Lighting.cginc"
        #include "AutoLight.cginc"

		sampler2D _MainTex;
                sampler2D _Normal;

		struct Input {

                     float2 uv_MainTex;
                                          float2 uv_Normal;

            // half4 vertexColor; 
             half3 viewDir;
             float3 wPos;


             INTERNAL_DATA
   
         };
         
    
		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
        float _VarAmount;
        sampler2D _VarMap;
        float _VarScale;
        float _WindAmount;

        void vert (inout appdata_full v, out Input o){

             UNITY_INITIALIZE_OUTPUT(Input,o);
            // o.vertexColor = v.color;
                       
               float3 worldPos = mul(unity_ObjectToWorld,v.vertex);

             float3 m_transform=float3(sin(worldPos.x+worldPos.z+_Time.z+v.texcoord.x*4)*sin(worldPos.x*2+worldPos.z*3+_Time.y+v.texcoord.x*4),0,0)*_WindAmount;

             o.wPos=mul(unity_WorldToObject, float4(0,0,0,1)).xyz;

             v.vertex.xyz += float4(mul(unity_WorldToObject, m_transform).xyz,1.0)*0.04;

         }

		UNITY_INSTANCING_BUFFER_START(Props)
		UNITY_INSTANCING_BUFFER_END(Props)



		void surf (Input IN, inout SurfaceOutputStandard o) {

            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            float3 objectPos=IN.wPos;

            clip(c.a-0.5);
            
			o.Albedo = c.rgb*lerp(float3(1,1,1),tex2D(_VarMap,objectPos.xz*_VarScale).rgb,_VarAmount);

           half rim = pow(1.0 - saturate(dot (normalize(IN.viewDir), o.Normal)),2);
                   o.Normal = UnpackNormal (tex2D (_Normal, IN.uv_Normal));

           
                 o.Emission= c.rgb*float3(0.5,0.6,0.5)*rim*0.3;

			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
     FallBack "Transparent/Cutout/Diffuse"
}
