Shader "Custom/UVScrollComplex"
{
    Properties
    {
        _MainTex ("Main texture", 2D) = "white" {}
        _SecundaryTex ("Secundary texture", 2D) = "white" {}
        _ScrollX ("Scroll X", Range(-5, 5)) = 0
        _ScrollY ("Scroll Y", Range(-5, 5)) = 0
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex, _SecundaryTex;
        half _ScrollX, _ScrollY;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_SecundaryTex;
        };

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
