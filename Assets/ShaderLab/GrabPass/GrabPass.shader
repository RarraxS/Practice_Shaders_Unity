Shader "Unlit/GrabPass"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}

        _ScaleUVX("Scale UVs X", Range(0, 10)) = 1
        _ScaleUVY("Scale UVs Y", Range(0, 10)) = 1

        _FishEyeStrength("Fish Eye Strength", Range(0, 2)) = 0.5

        _TintColor("Final Multiply Color", Color) = (1,1,1,1)
    }

        SubShader
        {
            Tags { "Queue" = "Transparent" "RenderType" = "Transparent" }
            LOD 100

            GrabPass {}

            Pass
            {
                Blend SrcAlpha OneMinusSrcAlpha
                ZWrite Off

                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #pragma multi_compile_fog

                #include "UnityCG.cginc"

                struct appdata
                {
                    float4 vertex : POSITION;
                    float2 uv : TEXCOORD0;
                };

                struct v2f
                {
                    float2 uv : TEXCOORD0;
                    UNITY_FOG_COORDS(1)
                    float4 vertex : SV_POSITION;
                };

                sampler2D _MainTex, _GrabTexture;
                float4 _MainTex_ST;
                float _ScaleUVX, _ScaleUVY;
                float _FishEyeStrength;
                float4 _TintColor;

                v2f vert(appdata v)
                {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);

                    float2 uv = TRANSFORM_TEX(v.uv, _MainTex);

                    uv.x = sin(uv.x * _ScaleUVX);
                    uv.y = sin(uv.y * _ScaleUVY);

                    float2 center = float2(0.5, 0.5);
                    float2 delta = uv - center;
                    float dist = length(delta);
                    uv = center + delta * (1.0 + _FishEyeStrength * dist * dist);

                    o.uv = uv;
                    UNITY_TRANSFER_FOG(o, o.vertex);
                    return o;
                }

                fixed4 frag(v2f i) : SV_Target
                {
                    fixed4 mainTex = tex2D(_MainTex, i.uv);
                    fixed4 grabTex = tex2D(_GrabTexture, i.uv);

                    fixed4 col = mainTex * grabTex;
                    col *= _TintColor;

                    float alpha = dot(mainTex.rgb, float3(0.299, 0.587, 0.114));
                    col.a *= alpha;

                    UNITY_APPLY_FOG(i.fogCoord, col);
                    return col;
                }
                ENDCG
            }
        }
}
