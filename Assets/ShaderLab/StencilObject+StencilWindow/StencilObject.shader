Shader "Custom/StencilObject"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _NormalTex ("Normal Texture", 2D) = "bump" {}
        _NormalIntensity ("Normal Intensity", Range(0, 5)) = 1.0
        _Smoothness ("Smoothness Intensity", Range(0, 1)) = 0.5

        _SRef ("Stensill Ref", Float)= 1
        [Enum(UnityEngine.Rendering.CompareFunction)] _SComp ("Stencill Comp", Float) = 8
        [Enum(UnityEngine.Rendering.StencilOp)] _SOp ("Stencill Operation", Float) = 2
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Geometry" }

        Stencil
        {
            Ref [_SRef]
            Comp [_SComp]
            Pass [_SOp]
        }

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

        sampler2D _MainTex, _NormalTex;
        half _Smoothness, _NormalIntensity;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;

            float3 normalTex = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));
            float3 flatNormal = float3(0, 0, 1);
            o.Normal = normalize(lerp(flatNormal, normalTex, _NormalIntensity));

        }
        ENDCG
    }
    FallBack "Diffuse"
}
