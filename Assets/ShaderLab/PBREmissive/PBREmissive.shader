Shader "Custom/PBREmissive"
{
    Properties
    {
        _mainTexture ("Main Texture", 2D) = "white" {}
        
        _normalTexture ("Normal Texture", 2D) = "bump" {}
        _normalIntensity ("Normal Intensity", Range(0, 5)) = 1.0

        _ARMTexture ("ARM Texture", 2D) = "white" {}
        _AOIntensity ("Ambient Occlusion Intensity", Range(0, 1)) = 0.5
        _smoothnessIntensity ("Smoothness Intensity", Range(0, 1)) = 0.5
        _metallicIntensity ("Metallic Intensity", Range(0, 1)) = 0.5

        _emissionTexture ("Emission Texture", 2D) = "black" {}
        _emissionIntensity ("Emission Intensity", Range(0,2)) = 0.5
        _emissionColor ("Emission Color", Color) = (0,0,0,1)
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Standard

        struct Input {
            float2 uv_mainTexture;
            float2 uv_normalTexture;
            float2 uv_arm;
            float2 uv_emissionTexture;
        };

        sampler2D _mainTexture, _normalTexture, _ARMTexture, _emissionTexture;
        half _normalIntensity, _AOIntensity, _smoothnessIntensity, _metallicIntensity, _emissionIntensity;
        float4 _emissionColor;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float4 armTex = tex2D(_ARMTexture, IN.uv_mainTexture);

            o.Albedo = tex2D(_mainTexture, IN.uv_mainTexture).rgb;
            o.Occlusion = armTex.r * _AOIntensity;
            o.Smoothness = (1 - armTex.g) * _smoothnessIntensity;
            o.Metallic = armTex.b * _metallicIntensity;

            float3 normalTex = UnpackNormal(tex2D(_normalTexture, IN.uv_normalTexture));
            float3 flatNormal = float3(0, 0, 1); // default flat normal
            o.Normal = normalize(lerp(flatNormal, normalTex, _normalIntensity));

            float3 emissionTex = tex2D(_emissionTexture, IN.uv_emissionTexture).rgb;
            float3 emissionTexGray = dot(emissionTex, float3(0.299, 0.587, 0.114));
            float3 emission = (emissionTexGray * float3(4.0, 4.0, 4.0)) * _emissionColor.rgb * _emissionIntensity;
            o.Emission = emission;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
