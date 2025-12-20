Shader "Custom/RimTexture"
{
    Properties
    {
        _mainTexture ("Main Texture", 2D) = "white" {}

        _normalTexture ("Normal Texture", 2D) = "bump" {}
        _normalIntensity ("Normal Intensity", Range(0, 10)) = 1.0

        _armTexture("ARM Texture", 2D) = "white" {}
        _ambientOclussionIntensity("Ambient Oclussion Intensity", Range(0, 1)) = 0.5
        _smoothnessIntensity ("Smoothness Intensity", Range(0, 1)) = 0.5
        _metallicIntensity ("Metallic Intensity", Range(0, 1)) = 0.5

        _emissionTexture ("Emission Texture", 2D) = "black" {}
        _emissionIntensity ("Emission Intensity", Range(0,2)) = 0.5
        _emissionColor ("Emission Color", Color) = (0,0,0,1)

        _rimColor ("Rim Color", Color) = (1, 1, 1, 1)
        _rimIntensity ("Rim Intensity", Range(0, 10)) = 1.0
        _rimPower ("Rim Power", Range(0, 10)) = 1.0
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Standard

        struct Input {
            float2 uv_mainTexture;
            float2 uv_normalTexture;
            float2 uv_armTexture;
            float2 uv_emissionTexture;
            float3 viewDir;
        };

        sampler2D _mainTexture, _normalTexture, _armTexture, _emissionTexture;
        half _normalIntensity, _ambientOclussionIntensity, _smoothnessIntensity, _metallicIntensity, _emissionIntensity;
        float4 _emissionColor, _rimColor;
        float _rimPower, _rimIntensity;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float4 armTex = tex2D(_armTexture, IN.uv_mainTexture);

            o.Albedo = tex2D(_mainTexture, IN.uv_mainTexture).rgb;
            o.Occlusion = armTex.r * _ambientOclussionIntensity;
            o.Smoothness = (1 - armTex.g) * _smoothnessIntensity;
            o.Metallic = armTex.b * _metallicIntensity;

            float3 normalTex = UnpackNormal(tex2D(_normalTexture, IN.uv_normalTexture));
            float3 flatNormal = float3(0, 0, 1);
            o.Normal = normalize(lerp(flatNormal, normalTex, _normalIntensity));

            float3 emissionTex = tex2D(_emissionTexture, IN.uv_emissionTexture).rgb;
            float3 emissionTexGray = dot(emissionTex, float3(0.299, 0.587, 0.114));
            float3 emission = (emissionTexGray * float3(4.0, 4.0, 4.0)) * _emissionColor.rgb * _emissionIntensity;
            o.Emission = emission;

            float3 rim = 1.0 - saturate(dot(IN.viewDir, o.Normal));
            rim = pow(rim, _rimPower);
            rim = _rimColor.rgb * rim * _rimIntensity;

            o.Emission = emission + rim;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
