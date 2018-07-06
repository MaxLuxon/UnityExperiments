Shader "Unlit/CubeFrag"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_TintColor ("TintColor",Color) = (1,1,1,1)

		_Distortion("Distortion", float)= 1
		_SampleLength("SampleLength", float)= 1
		_StructureSize("StructureSize", float)= 1
		_EffectStrenght("EffectStrenght", float)= 1

	}

	SubShader
	{

		Tags { "RenderType"="Transparent" "RenderType"="Transparent" "DisableBatching"="True"}
		LOD 100
		Blend SrcAlpha OneMinusSrcAlpha
		Cull Off

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

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

				float4 localVertex : TEXCOORD0;
				float4 screenPos : TEXCOORD1;
				float4 worldPos: TEXCOORD2;
				float3x3 inverseMat: TEXCOORD3;

				float4 vertex : SV_POSITION;

			};

			sampler2D _MainTex;
			sampler2D BG_Texture;
			float4 _MainTex_ST;
			float4 _TintColor;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.localVertex=v.vertex;

				float3x3 inverseMat;
				inverseMat[0]= unity_ObjectToWorld[0].xyz;
				inverseMat[1]= unity_ObjectToWorld[1].xyz;
				inverseMat[2]= unity_ObjectToWorld[2].xyz;

				o.inverseMat= transpose(inverseMat);

				o.vertex = UnityObjectToClipPos(v.vertex);
				o.worldPos= mul(unity_ObjectToWorld,v.vertex);
			
                o.screenPos = ComputeScreenPos(o.vertex);

				return o;
			}
	
			float _Distortion;
			float _SampleLength;
			float _StructureSize;
			float _EffectStrenght;

			float4 sampleStructure(float3 position){

				return tex2D(_MainTex, position.xz*_StructureSize+tex2D(_MainTex, position.xy).rg*_StructureSize*_Distortion
				+tex2D(_MainTex, position.yz).gb*_StructureSize*_Distortion);

			}


			fixed4 frag (v2f i) : SV_Target
			{

				int samples=10;
				float stepSize= _SampleLength/ samples;

				float3 viewDir=normalize(i.worldPos-_WorldSpaceCameraPos);
				float3 localViewDir=  mul(i.inverseMat, viewDir );

				fixed4 col= fixed4(0,0,0,0);

				float3 vertexPos=i.localVertex.xyz;
				float2 screenPos= i.screenPos.xy/i.screenPos.w;

				float3 ray= float3(0,0,1);
				float3 rayRed= ray;
				float3 rayBlue= ray;

				float4 firstSample= sampleStructure(vertexPos.xyz);
				float lastDensity= firstSample.r;

				float lightSum=0;

				for(int i=1; i<samples; i++){

					float3 samplePos= (vertexPos.xyz+localViewDir*(stepSize*i)).xzy*0.1;
					float4 sample= sampleStructure(samplePos);

					float densityDif= (lastDensity-sample.r);
					lastDensity= sample.r;

					float3 normal= normalize(normalize(sample.rgb*2-1));

					col.rgb= lerp(float3(0,0,0),col.rgb,clamp(pow(length(samplePos)*15,0.7)+0.3,0,1));
					col.rgb= lerp(col.rgb,float3(0,0,0),clamp(pow(length(samplePos)*1.5,2),0,1));

					ray= refract(ray,normal,0.8-densityDif);
					rayRed= refract(rayRed,normal,0.8-densityDif+0.1);
					rayBlue= refract(rayBlue,normal,0.8-densityDif-0.1);

					float4 colorrefract= tex2D(BG_Texture, screenPos+ray.xy*0.2*_EffectStrenght);
					float4 colorrefractRed= tex2D(BG_Texture, screenPos+rayRed.xy*0.2*_EffectStrenght);
					float4 colorrefractBlue= tex2D(BG_Texture, screenPos+rayBlue.xy*0.2*_EffectStrenght);
	
					lightSum+= pow(abs(densityDif),4);
				
					col.g+=colorrefract.g*pow(abs(densityDif),4);
					col.r+=colorrefractRed.r*pow(abs(densityDif),4);
					col.b+=colorrefractBlue.b*pow(abs(densityDif),4);

				}

				col.rgb/=lightSum;
				col.rgb*=_TintColor.rgb;

				col.rgb= clamp(col,0,1);

				return float4(col.x,col.y,col.z,1);
			}
			ENDCG
		}
	}
}
