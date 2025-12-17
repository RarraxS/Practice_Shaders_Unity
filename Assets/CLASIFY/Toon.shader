Shader "Custom/Toon"
{
    Properties
    {
        _MainTex ("Albedo Texture", 2D) = "white" {}
        _Color ("Tint Color", Color) = (1,1,1,1)

        _RampTex ("Ramp Texture", 2D) = "gray" {}

        _OutlineColor ("Outline Color", Color) = (0,0,0,1)
        _OutlineWidth ("Outline Width", Range(0.0, 0.05)) = 0.02
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        //---------- OUTLINE PASS ----------
        Pass
        {
            Name "Outline"
            Cull Front
            ZWrite On

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

            v2f vert (appdata v)
            {
                v2f o;

                float3 norm = normalize(v.normal);
                float3 offset = norm * _OutlineWidth;

                v.vertex.xyz += offset;
                o.pos = UnityObjectToClipPos(v.vertex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return _OutlineColor;
            }
            ENDCG
        }

        // ---------- MAIN TOON PASS ----------
        CGPROGRAM
        #pragma surface surf ToonRamp fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _RampTex;

        fixed4 _Color;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldNormal;
            float3 worldPos;
        };

        // Iluminación Toon con rampa
        inline fixed4 LightingToonRamp (SurfaceOutput s, fixed3 lightDir, fixed atten)
        {
            float NdotL = dot(s.Normal, lightDir);
            float ramp = tex2D(_RampTex, float2(NdotL * 0.5 + 0.5, 0.5)).r;

            fixed4 col;
            col.rgb = s.Albedo * _LightColor0.rgb * ramp * atten;
            col.a = s.Alpha;
            return col;
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 tex = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = tex.rgb;
        }
        ENDCG
    }

    FallBack "Diffuse"
}