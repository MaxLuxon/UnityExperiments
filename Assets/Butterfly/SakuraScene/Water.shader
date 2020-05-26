Shader "Custom/WaterReflect"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0

        _NormalMap ("Normal", 2D) = "bump" {}


    }


    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _NormalMap;
        sampler2D _Reflect;

        struct Input
        {
            float2 uv_MainTex;
          float4 screenPos;
          float3 viewDir;
          float3 worldPos;

        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {


 float2 screenUV = (IN.screenPos.xy / IN.screenPos.w);

const float2 kernel[8]={float2(0.2,3.1f),float2(-0.2,-3.4),float2(-1.2,0.2),float2(1.43,-0.2),
                        float2(1.4,3.3),float2(-2.1,3.6),float2(1.5,-3.8),float2(-1.8,-3.7)};
            // Albedo comes from a texture tinted by color

            half rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));


            o.Normal = UnpackNormal (lerp(tex2D (_NormalMap, IN.worldPos.xz*0.8f),float4(0.5,0.5,1,1),0.5f));

            float3 normalView = normalize(mul((float3x3)UNITY_MATRIX_MV, o.Normal));


            float2 uv= (screenUV+normalView*0.0001f);
            uv.x= 1-uv.x;

float iRim= pow(1-rim,1.6)*1.6;

            fixed4 c = tex2D (_Reflect,uv);

for(int i=0; i<8; i++){

c += tex2D (_Reflect,uv+(kernel[i]+normalView)*0.003f*iRim);


}

for(int i=0; i<8; i++){

c += tex2D (_Reflect,uv-kernel[i]*0.005f*iRim);


}


for(int i=0; i<8; i++){

c += tex2D (_Reflect,uv+(kernel[i]+normalView)*0.006f*iRim);


}

for(int i=0; i<8; i++){

c += tex2D (_Reflect,uv-(kernel[i]+normalView)*0.01f*iRim);


}

for(int i=0; i<8; i++){

c += tex2D (_Reflect,uv+(kernel[i]+normalView)*0.012f*iRim);


}

c/=41;

            o.Albedo = _Color;
            // Metallic and smoothness come from slider variables
            o.Emission=c.rgb*rim;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
