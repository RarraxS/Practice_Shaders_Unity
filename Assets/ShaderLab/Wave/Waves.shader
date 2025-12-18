Shader "Custom/Waves"
{
    Properties
    {
        _MainTex ("Main texture", 2D) = "white" {}
        _SecundaryTex ("Secundary texture", 2D) = "white" {}
        _ScrollX ("Scroll X", Range(-5, 5)) = 0
        _ScrollY ("Scroll Y", Range(-5, 5)) = 0

        _Freq("Frequency", Range(0, 5)) = 1
        _Speed ("Speed", Range(0, 100)) = 10
        _Amplitude ("Amplitude", Range(0, 10)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert vertex:vert

        sampler2D _MainTex, _SecundaryTex;
        half _ScrollX, _ScrollY, _Freq, _Speed, _Amplitude;

        struct appdata
        {
            float4 vertex: POSITION;
            float4 texcoord: TEXCOORD0;
            float3 normal: NORMAL;
        };

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_SecundaryTex;
        };

        void vert (inout appdata v, out Input o)
        {
            UNITY_INITIALIZE_OUTPUT(Input,o);

            float waveheigth = sin(_Time * _Speed + v.vertex.x * _Freq) * _Amplitude;

            v.vertex.y += waveheigth;
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            _ScrollX *= _Time;
            _ScrollY *= _Time;
            float2 newuv = IN.uv_MainTex + float2(_ScrollX, _ScrollY);
            fixed4 c = tex2D (_MainTex, newuv);

            float2 newuvSecundary = IN.uv_SecundaryTex + float2(_ScrollY, _ScrollX);
            fixed4 c2 = tex2D (_SecundaryTex, newuvSecundary);

            o.Albedo = c.rgb * c2.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
