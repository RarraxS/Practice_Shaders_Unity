Shader "Custom/Stencil Window"
{
    Properties
    {
        _Color ("Main Color", Color) = (1, 1, 1, 1)
        _SRef ("Stensill Ref", Float)= 1
        [Enum(UnityEngine.Rendering.CompareFunction)] _SComp ("Stencill Comp", Float) = 8
        [Enum(UnityEngine.Rendering.StencilOp)] _SOp ("Stencill Operation", Float) = 2
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Geometry-1" }

        ColorMask 0
        ZWrite off
        Stencil
        {
            Ref [_SRef]
            Comp [_SComp]
            Pass [_SOp]
        }

        CGPROGRAM
        #pragma surface surf Standard

        float4 _Color;

        struct Input 
        {
            float2 uv_MainTexture;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            o.Albedo = _Color.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
