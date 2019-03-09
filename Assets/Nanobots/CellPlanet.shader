Shader "Unlit/CellPlanet"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
        _Color("Color", Color) = (1,1,1,1)
        _RimColor ("RimColor",Color) = (1,1,1,1)
        _RimPower ("RimPower", float) = 2
        _Normal ("Normal", 2D) = "white" {}
                _Structure ("_Structure", 2D) = "white" {}
                        _LightColor ("LightColor", Color) = (1,1,1,1)
        _LightColor2 ("LightColor2", Color) = (1,1,1,1)


                        _Structure2 ("_Structure2", 2D) = "white" {}


                                _CubeMap ("_CubeMap", Cube) = "white" {}

                                        _Cut ("_Cut", Range(0,1)) = 1

	}
	SubShader
	{

        Tags { "RenderType"="Transparent" "RenderType"="Transparent" "DisableBatching"="True"}
        LOD 100
        Blend One One
        ZWrite Off
        //Cull Off
         
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
    #include "UnityCG.cginc"
            #include "Lighting.cginc"
	struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;

            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 worldNormal: NORMAL;
                float4 worldPos: TEXCOORD2;
                float3x3 tangentToWorld: TEXCOORD3;
                float2 uv: TEXCOORD1;

                                float4 screenPosition : TEXCOORD0;

            };


			sampler2D _MainTex;
			float4 _MainTex_ST;
            float4 _Color;
			                     sampler2D _Normal;
             float4 _RimColor;
            float _RimPower;
            float4 _LightColor;
            sampler2D _Structure;
                        float4 _LightColor2;
                                    sampler2D _Structure2;
                                    float _Cut;

                samplerCUBE _CubeMap;

		        v2f vert (appdata v)
            {
                v2f o;

            
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPos= mul(unity_ObjectToWorld,v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.uv=v.uv;
                float3 tangent= normalize(  mul(float4(v.tangent.xyz, 0.0), unity_ObjectToWorld).xyz );
                o.tangentToWorld =float3x3(tangent.rgb, normalize(cross(o.worldNormal.rgb,tangent.rgb)* v.tangent.w ), o.worldNormal.rgb);
                                o.screenPosition = ComputeScreenPos(o.vertex);

                return o;
            }


            float sampleStructure(float2 uv){

                float s=tex2D(_Structure,uv*6).r*0.1;
                s+=tex2D(_Structure,uv*0.2+s).g;

                return s;
            }

		  fixed4 frag (v2f i) : SV_Target
            {

                float3 viewDir=normalize(i.worldPos-_WorldSpaceCameraPos);

                                float3 noise=tex2D(_Structure2,i.uv.xy*2).rgb;


                float3 normalTangent=UnpackNormal(tex2D(_Normal,i.uv*1+float2(_Time.x,0))).xyz*UnpackNormal(tex2D(_Normal,i.uv*4)).xyz+UnpackNormal(tex2D(_Normal,i.uv*9)).xyz*UnpackNormal(tex2D(_Normal,i.uv*6)).y*0.5;
                float3 normal= normalize(  mul( normalize(normalTangent*float3(1,1,0.6)), i.tangentToWorld).xyz );


                float2 screenPosition = (i.screenPosition.xy/i.screenPosition.w);
                float2 vec= screenPosition-float2(0.5,0.5);
                float angle= atan2(vec.x,vec.y)*3+_Time.x;
                float3 iris=pow(tex2D(_Structure2,float2(angle,length(vec)*6+_Time.x)).rgb,7)*0.8+0.2;


                float n=tex2D(_Structure2,i.uv).r-0.5;


                float3 pos=i.worldPos;
                float gl=pow(tex2D(_Structure2,i.uv*3).r*(1-tex2D(_Structure2,i.uv*4).r),2)*2;

  
                float p=pow(tex2D(_MainTex,i.uv*3).r*(1-tex2D(_MainTex,i.uv*4).r),2)*2;
                clip(p-_Cut);

                float rim= pow(1-abs(dot(viewDir,normal)),_RimPower+gl*5);
                float rimClean= pow(1-abs(dot(viewDir,i.worldNormal)),_RimPower+gl*5);

                float viewDot= pow(abs(dot(viewDir,i.worldNormal)),1);

                float light= max(pow(dot(i.worldNormal,-_WorldSpaceLightPos0.xyz)*0.5+0.5,2),0.0);

                float3 col= 0;

                col= lerp(col*(1-rim), _RimColor,(rim*0.5+n*0.5*rim+p*rim)*0.6*iris.r);
                col= lerp(col, _RimColor,pow(rimClean,5)*iris.r);

                col= lerp(col, _LightColor0.rgb,light*0.8*rim);


                //col= max(col-_Cut*(1-p),0.0);
                return float4(col*1.5,length(col)*3);
            }


			ENDCG
		}
	}
}
