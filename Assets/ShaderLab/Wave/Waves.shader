Shader "Custom/Waves"
{
    Properties
    {
        _MainTex ("Main texture", 2D) = "white" {}
        _SecundaryTex ("Secundary texture", 2D) = "white" {}

        _DirectionXA ("Direction X A", Range(-1, 1)) = 0
        _DirectionYA("Direction Y A", Range(-1, 1)) = 0
        _VelocityA ("Velocity A", Range(-0.5, 0.5)) = 0

        _DirectionXB ("Direction X B", Range(-1, 1)) = 0
        _DirectionYB ("Direction Y B", Range(-1, 1)) = 0
        _VelocityB ("Velocity B", Range(-0.5, 0.5)) = 0

        _Freq("Frequency", Range(0, 5)) = 1
        _Speed ("Speed", Range(0, 100)) = 10
        _Amplitude ("Amplitude", Range(0, 10)) = 1
        _HeightColor("Height Color", Color) = (0,0.6,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert vertex:vert

        sampler2D _MainTex, _SecundaryTex;
        half _DirectionXA, _DirectionYA, _VelocityA, _DirectionXB, _DirectionYB, _VelocityB, _Freq, _Speed, _Amplitude;
        fixed4 _HeightColor;


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
            float waveHeight;
        };

        void vert (inout appdata v, out Input o)
        {
            UNITY_INITIALIZE_OUTPUT(Input,o);

            float waveheigth = sin(_Time * _Speed + v.vertex.x * _Freq) * _Amplitude;
            v.vertex.y += waveheigth;

            o.waveHeight = waveheigth;
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            half x1Movement = _VelocityA * _Time * _DirectionXA *_Time;
            half y1Movement = _VelocityA * _Time * _DirectionYA *_Time;

            float2 newuv = IN.uv_MainTex + float2(x1Movement, y1Movement);
            fixed4 c = tex2D (_MainTex, newuv);

            half x2Movement = _VelocityB * _Time * _DirectionXB * _Time;
            half y2Movement = _VelocityB * _Time * _DirectionYB * _Time;

            float2 newuvSecundary = IN.uv_SecundaryTex + float2(x2Movement, y2Movement);
            fixed4 c2 = tex2D (_SecundaryTex, newuvSecundary);

            fixed3 totalColor = c * c2;

            float colorIntensity = saturate(IN.waveHeight);

            o.Albedo = totalColor * _HeightColor * colorIntensity + totalColor * 0.01;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
