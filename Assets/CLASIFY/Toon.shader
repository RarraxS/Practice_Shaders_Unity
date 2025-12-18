Shader "Custom/Toon"
{
    Properties
    {
        _MainTex("Albedo (RGB)", 2D) = "white" {}

        _RampTex("Ramp Texture", 2D) = "white" {}

        _OutlineColor("Outline Color", Color) = (1,1,1,1)
        _OutlineWidth("Outline Width", Range(-0.1, 0.1)) = 0.05
    }

        SubShader
        {
            Tags { "RenderType" = "Opaque" }

            Pass
            {
                Name "Outline"
                Cull Front
                ZWrite Off

                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #include "UnityCG.cginc"

                float _OutlineWidth;
                float4 _OutlineColor;

                struct appdata
                {
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
                };

                struct v2f
                {
                    float4 pos : SV_POSITION;
                };

                v2f vert(appdata v)
                {
                    v2f o;
                    float3 norm = normalize(v.normal);
                    v.vertex.xyz += norm * _OutlineWidth;
                    o.pos = UnityObjectToClipPos(v.vertex);
                    return o;
                }

                fixed4 frag(v2f i) : SV_Target
                {
                    return _OutlineColor;
                }
                ENDCG
            }


            CGPROGRAM
            #pragma surface surf ToonRamp fullforwardshadows

            sampler2D _MainTex;
            sampler2D _RampTex;

            struct Input
            {
                float2 uv_MainTex;
            };

            inline fixed4 LightingToonRamp(SurfaceOutput s, fixed3 lightDir, fixed atten)
            {
                float NdotL = dot(s.Normal, lightDir);
                float ramp = tex2D(_RampTex, float2(NdotL * 0.5 + 0.5, 0.5)).r;

                fixed4 c;
                c.rgb = s.Albedo * _LightColor0.rgb * ramp * atten;
                c.a = s.Alpha;
                return c;
            }

            void surf(Input IN, inout SurfaceOutput o)
            {
                fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
                o.Albedo = c.rgb;
                o.Alpha = c.a;
            }

            ENDCG
        }

            FallBack "Diffuse"
}