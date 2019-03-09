Shader "Unlit/Aurora"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
                _Perlin ("_Perlin", 2D) = "white" {}

	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
		LOD 100
        Cull Off
        Blend One One
        ZWrite Off

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
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
            sampler2D _Perlin;
			
			v2f vert (appdata v)
			{
				v2f o;

                float p0= tex2Dlod(_Perlin,float4(v.uv.x*10.2f+_Time.x,v.uv.y*10-_Time.x,0,0)).r*2-1;


				o.vertex = UnityObjectToClipPos(v.vertex+4*float4(0,p0*0.01,sin(v.uv.x*40+_Time.y*0.4)+sin(v.uv.x*60+_Time.y*0.3),0));
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{

                fixed4 offset = tex2D(_Perlin, i.uv*float2(7.2,0)+float2(_Time.x,0))*2;
                offset *= tex2D(_Perlin, i.uv*float2(2.2,0)+float2(_Time.x,0))*2;

                fixed4 bi = tex2D(_Perlin, i.uv*float2(2.2,7))*2;

                                offset.r*=0.02+bi.r*0.01;

				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv*float2(7.2,1)+float2(_Time.x+bi.r*0.08,offset.r))*2;
                col *= tex2D(_MainTex, i.uv*float2(5.3,1)+float2(_Time.x+bi.r*0.08,offset.r));
                col += tex2D(_MainTex, i.uv*float2(12.3,1)-float2(_Time.x+bi.r*0.05,offset.r));
                col += ((tex2D(_MainTex, i.uv*float2(122.3,1)-float2(_Time.x-bi.r*0.06,offset.r)))*(tex2D(_MainTex, i.uv*float2(92.3,1)+float2(_Time.x*2+bi.r*0.05,offset.r))))*0.5-0.5;


                float a= clamp(col.r*0.45,0,1);

                //a+=pow(1.0-i.uv.y,4);
                //a*=0.5;

				// apply fog
				return float4(i.uv.y*3,1-i.uv.y*1,1-clamp(i.uv.y*2-1,0,1),1)*pow(a,2);
			}
			ENDCG
		}
	}
}
