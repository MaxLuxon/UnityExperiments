Shader "Unlit/Planet"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_BaseColor ("BaseColor",Color) = (1,1,1,1)
		_RimColor ("RimColor",Color) = (1,1,1,1)
		_RimPower ("RimPower", float) = 2
		_LightColor ("LightColor", Color) = (1,1,1,1)
		_Normal ("Normal", 2D) = "white" {}
				_BaseCoreColor ("BaseCoreColor",Color) = (1,1,1,1)
								_LandColor ("LandColor",Color) = (1,1,1,1)
																_Grav ("_Grav",float) = 1.0

	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "RenderType"="Transparent" "DisableBatching"="True"}
		LOD 100
		Blend SrcAlpha OneMinusSrcAlpha
		ZWrite Off
		 

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work



			#include "UnityCG.cginc"

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
				float4 localVertex : TEXCOORD0;
				    float4 screenPos : TEXCOORD6;


			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
						sampler2D _Normal;
									sampler2D _CameraDepthTexture;
									float4 Moon;
									float _Grav;
			v2f vert (appdata v)
			{
				v2f o;
				o.localVertex=v.vertex;

				o.worldNormal = UnityObjectToWorldNormal(v.normal);

				float d= pow(max( dot(o.worldNormal, normalize(Moon.xyz)),0.0),15)*_Grav;
				o.localVertex.w=d;

				o.vertex = UnityObjectToClipPos(v.vertex+v.normal*d);
				o.worldPos= mul(unity_ObjectToWorld,v.vertex+float4(v.normal.x,v.normal.y,v.normal.z,0)*d);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.uv=v.uv;
				float3 tangent= normalize(  mul(float4(v.tangent.xyz, 0.0), unity_ObjectToWorld).xyz );
                o.tangentToWorld =float3x3(tangent.rgb, normalize(cross(o.worldNormal.rgb,tangent.rgb)* v.tangent.w ), o.worldNormal.rgb);
                    o.screenPos = ComputeScreenPos(o.vertex);

				return o;
			}

			float4 _BaseColor;
			float4 _RimColor;
			float _RimPower;
			float4 _LightColor;
			float4 _BaseCoreColor;
			float4 _LandColor;

			float sampleHeight(float2 pos){

				float offset =  tex2D(_Normal, pos*3+float2(_Time.x, _Time.x*0.1f)).rgb; 
				offset *=  tex2D(_Normal, pos*5-float2(_Time.x, _Time.x*0.1f)).rgb; 

				float h = tex2D(_Normal, pos+float2(_Time.x, _Time.x*0.1f)).rgb; 
             	h +=   tex2D(_Normal, pos*3+float2(_Time.x, _Time.x*0.1f)*3).rgb*h; 
             	h +=   tex2D(_Normal, pos*12+float2(_Time.x*0.5, _Time.x*0.1f)*3).rgb*offset; 

             	return pow(h/3,3)*7;

			}

			float sampleLandHeight(float2 pos){


				float offset =  tex2D(_Normal, pos*3).rgb; 
				offset *=  tex2D(_Normal, pos*5).rgb; 


				float l = tex2D(_Normal, pos).rgb*3; 
				l += tex2D(_Normal, pos*2).rgb*l; 
				l +=   tex2D(_Normal, pos*12).rgb*offset; 


				return pow(l/5,3)*5;

			}


			fixed4 frag (v2f i) : SV_Target
			{



				float xAngle= atan2(i.localVertex.x,i.localVertex.z)/(3.14);


				float h1= sampleHeight(float2(xAngle, i.localVertex.y))*(1+i.localVertex.w);
				float h2= sampleHeight(float2(xAngle-0.008, i.localVertex.y));
				float h3= sampleHeight(float2(xAngle, i.localVertex.y-0.008));
				float slope= (h1-h2);
             	float slope2=(h1-h3);

             	float land= clamp(sampleLandHeight(float2(xAngle+slope*0.3, i.localVertex.y+slope2*0.3))-0.4,0,1);

   
				float3 viewDir=normalize(i.worldPos-_WorldSpaceCameraPos);
				//float3 normal= normalize(i.worldNormal);
				float3 normal= normalize(  mul(normalize(float3(slope2,slope,0.3)), i.tangentToWorld).xyz );


				float lightDot= pow(max(dot(normalize(float3(0.5,-0.5,0.2)), -normal)*0.5+0.5,0),4);

				float rim= pow(1-max(dot(viewDir,-normalize(normal+ i.worldNormal*2)),0),_RimPower);
				float viewDot= (1-pow(max(dot(-i.worldNormal,viewDir),0),7))*0.5+0.5;

				float3 base= lerp(_BaseCoreColor.rgb,_BaseColor.rgb,viewDot-i.localVertex.w);
				base= lerp(base,_LandColor,land);

				float3 col= lerp(base+_LightColor.rgb*lightDot, _RimColor.rgb, min(rim,1)-i.localVertex.w);

				col+= _LightColor.rgb*pow(max(dot(normal, normalize(float3(-1,1,-2))),0),25)*(land);

				col+= lerp(float3(0,0,0),float3(0,1,1), pow(max(slope2*2,0),1.4));
				col+= lerp(float3(0,0,0),_RimColor.rgb, pow(max(-slope,0),1.4));

				//col += _LightColor.rgb*lightDot;



				return float4(col.r,col.g,col.b,viewDot*0.9+0.1-i.localVertex.w*3);
			}
			ENDCG
		}
	}
}
