Shader "Unlit/ThinFilm"
{
	Properties
	{
		_NormalMap ("Normal", 2D) = "Bump" {}
        _NormalStrength("NormalStrength", float) =1

        _ThicknessVarianceMap ("ThicknessVarianceMap", 2D) = "black" {}

		_FilmThickness("FilmThickness (nm)", float) = 140
        _FilmThicknessVar("FilmThicknessVar (nm)", float) = 160

		_BaseColor ("BaseColor",Color) = (1,1,1,1)
        
		_Specular("Specular", float) =	1
		_IOR("ThineFilm_IOR", Range(1,5)) =	1.535

		_Fullreflection("Fullreflection", Range(0,1)) = 0.5
        
	}
    
	SubShader{
    
		Tags { "RenderType"="Opaque" "Queue"="Geometry" "DisableBatching"="True"}
		LOD 100

        Blend SrcAlpha OneMinusSrcAlpha
       // ZWrite Off

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
				float2 uv : TEXCOORD0;
				float4 worldPos: TEXCOORD1;
				float3x3 tangentToWorld: TEXCOORD2;

				float4 vertex : SV_POSITION;
				float3 worldNormal : NORMAL;

			};
           
		

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv= v.uv;
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.worldPos= mul(unity_ObjectToWorld,v.vertex);

				float3 tangent= normalize(  mul(float4(v.tangent.xyz, 0.0), unity_ObjectToWorld).xyz );
                o.tangentToWorld =float3x3(tangent.rgb, normalize(cross(o.worldNormal.rgb,tangent.rgb)* v.tangent.w ), o.worldNormal.rgb);
               
				return o;
			}

            // Properties
            sampler2D _NormalMap;
            float4 _NormalMap_ST;

            sampler2D _ThicknessVarianceMap;
            float4 _ThicknessVarianceMap_ST;

			float4 _BaseColor;

			float _FilmThickness;
            float _FilmThicknessVar;

			float _Specular;
			float _IOR;
			float _NormalStrength;
			float _Fullreflection;

			// Wave lengths 
            #define  LAMDA_VIOLET   400
			#define  LAMDA_BLUE     450
            #define  LAMDA_CYAN     500
            #define  LAMDA_GREEN    550
            #define  LAMDA_YELLOW   600
            #define  LAMDA_ORANGE   650
            #define  LAMDA_RED      700

			float getAmplitudeOfWaveLength(float wavelenght,float3 normal, float3 viewDir, float t){

				float angle= acos(1-abs(dot(normal,viewDir)));
				float length= sqrt(t*t+ pow(t*tan(3.14159*0.5-angle),2))*2;
				float numberOfPhases= length/wavelenght;
				float constructiveness= abs(((numberOfPhases-floor(numberOfPhases))-0.5)*4);
	
				return constructiveness;
			}

			fixed4 frag (v2f i) : SV_Target{

                const int waveLenghts[7]={LAMDA_RED,LAMDA_ORANGE,LAMDA_YELLOW,LAMDA_GREEN,LAMDA_CYAN,LAMDA_BLUE,LAMDA_VIOLET};

                float3 normal= normalize(lerp(i.worldNormal,  mul( UnpackNormal(tex2D(_NormalMap,i.uv*_NormalMap_ST.xy)), i.tangentToWorld).xyz,_NormalStrength) );

				float3 lightDir=normalize(_WorldSpaceLightPos0.xyz);
                 
                half3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                float3 viewDirRefl= reflect(-viewDir, normal);
                float3 viewDirIn= refract(viewDir, normal, 1/_IOR);

          
                // Thickness of film at this point
				float t=  _FilmThickness+_FilmThicknessVar*tex2D(_ThicknessVarianceMap,i.uv*_ThicknessVarianceMap_ST.xy).r;

                float wI[3];

                 wI[0] = getAmplitudeOfWaveLength( LAMDA_RED, normal, viewDirIn,t);
                 wI[1] = getAmplitudeOfWaveLength( LAMDA_GREEN, normal, viewDirIn,t);
                 wI[2] = getAmplitudeOfWaveLength( LAMDA_BLUE, normal, viewDirIn,t);

       
                float lightSource=pow(max(dot(viewDirRefl,normalize(-_WorldSpaceLightPos0.xyz)),0),_Specular);

                half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, viewDirRefl);
                half3 skyColor = DecodeHDR (skyData, unity_SpecCube0_HDR);
                half rim = pow(1 - abs(dot(viewDir, normal)),0.1);

                float3 incomingLight= skyColor*rim+lightSource;

                float3 col= float3(wI[0],wI[1],wI[2]) * incomingLight*0.5;
               

            
     
               col= lerp(_BaseColor*pow(max(dot(normal,-_WorldSpaceLightPos0.xyz),0),1),col, _Fullreflection);

               //col/=(col+1);
               //col= pow(col,1/2.2);

               return float4(col.x,col.y,col.z,1);

                
			}
			ENDCG
		}
	}
}
