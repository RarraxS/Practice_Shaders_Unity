Shader "Custom/WaveSimple"
{
    Properties
    {
        _MainTex ("Main texture", 2D) = "white" {}
        _Color ("Color", Color) = (1, 1, 1, 1)
        _Freq("Frequency", Range(0, 5)) = 1
        _Speed ("Speed", Range(0, 100)) = 10
        _Amplitude ("Amplitude", Range(0, 10)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert vertex:vert

        sampler2D _MainTex;
        fixed4 _Color;
        half _Freq, _Speed, _Amplitude;

        struct appdata
        {
            float4 vertex: POSITION;
            float4 texcoord: TEXCOORD0;
            float3 normal: NORMAL;
        };

        struct Input
        {
            float2 uv_MainTex;
        };

        void vert (inout appdata v, out Input o)
        {
            UNITY_INITIALIZE_OUTPUT(Input,o);

            float waveheigth = sin(_Time * _Speed + v.vertex.x * _Freq) * _Amplitude;

            v.vertex.y += waveheigth;
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
