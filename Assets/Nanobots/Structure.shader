Shader "Unlit/Structure"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{

        Tags { "RenderType"="Transparent" "RenderType"="Transparent" "DisableBatching"="True"}
        LOD 100
        Blend SrcAlpha OneMinusSrcAlpha
        LOD 100

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

			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
                float3 worldNormal: NORMAL;
                float4 worldPos: TEXCOORD2;

			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldPos= mul(unity_ObjectToWorld,v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{

                float3 viewDir=normalize(i.worldPos-_WorldSpaceCameraPos);
                float rim= pow(1-abs(dot(viewDir,i.worldNormal)),2);

                float light= pow(max(dot(i.worldNormal,_WorldSpaceLightPos0.xyz),0),3.0);


				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
                clip(col.r-0.6+rim);
                col.rgb=float3(0.2,0.2,1)*rim+light*float3(1,1,1);
                col.a=0.1;
				// apply fog
				return col;
			}
			ENDCG
		}
	}
}
