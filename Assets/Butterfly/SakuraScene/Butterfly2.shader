Shader "Hex/ButterFly2" {
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
		
      Tags { "RenderType"="Transparent" "RenderType"="Transparent" "DisableBatching"="True"}
        LOD 100
        Blend SrcAlpha OneMinusSrcAlpha

        Cull Off

		CGPROGRAM
		#pragma surface surf  Standard fullforwardshadows vertex:vert alphatest:_Cutoff addShadow
		#pragma target 3.0

        #include "UnityCG.cginc"
        #include "Lighting.cginc"
        #include "AutoLight.cginc"

		sampler2D _MainTex;
                sampler2D _Normal;

		struct Input {

                     float2 uv_MainTex;
                                          float2 uv_Normal;

             half4 vertexColor; 
             half3 viewDir;
             float3 wPos;
         fixed facing : VFACE;


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

             float3 m_transform=float3(sin(_Time.x),0,0)*_WindAmount*3;

             o.wPos=mul(unity_WorldToObject, float4(0,0,0,1)).xyz;

            float theta=(sin(_Time.y+length(o.wPos.xyz)*130.02)*0.8+0.7f)*3.141 * v.vertex.x*10;



            float4x4 mat = float4x4( float4(cos(theta),0, sin(theta),0), 		
             		                   
                                       float4(0,1,0,0),
                                         float4(-sin(theta),0, cos(theta),0),
                                       float4(0,0,0,0));



             float3 vn = float4(mul(mat, v.vertex).xyz,0.0);
             float3 vnn = float4(mul(mat, v.normal).xyz,0.0);

                v.vertex.xyz= lerp(v.vertex.xyz,vn,v.color.r);
                v.normal.xyz= normalize(lerp(v.normal.xyz,vnn,v.color.r));

         }

		UNITY_INSTANCING_BUFFER_START(Props)
		UNITY_INSTANCING_BUFFER_END(Props)



		void surf (Input IN, inout SurfaceOutputStandard o) {

            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) ;
            float3 objectPos=IN.wPos;

            clip(c.a-0.5);
            
			o.Albedo = c.rgb*lerp(float3(1,1,1),tex2D(_VarMap,objectPos.xz*_VarScale).rgb,_VarAmount)*_Color.rgb;

            o.Normal = UnpackNormal (tex2D (_Normal, IN.uv_Normal));
            o.Normal.z *= IN.facing;

            half rim = pow(1.0 - saturate(dot (normalize(IN.viewDir), o.Normal)),2);

        
           
            o.Albedo= lerp(o.Albedo,float3(0,0.2,0.2),rim);


         o.Emission= c*0.25f;

			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = 1;
		}
		ENDCG
	}
     FallBack "Transparent/Cutout/Diffuse"
}
