Shader "Unlit/Youtube04"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MipSampleLevel("MIP", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 worldPos : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _MipSampleLevel;

            v2f vert (MeshData IN)
            {
                v2f OUT;
                OUT.worldPos = mul(UNITY_MATRIX_M, IN.vertex);
                OUT.vertex = UnityObjectToClipPos(IN.vertex);
                OUT.uv = TRANSFORM_TEX(IN.uv, _MainTex);
                OUT.uv.x += _Time.y * 0.1;
                return OUT;
            }

            float4 frag(v2f IN) : SV_Target
            {
                float2 topDownProjection = IN.worldPos.xz* 10;


                //fixed4 col = tex2Dlod(_MainTex, float4(topDownProjection, _MipSampleLevel.xx));
                // fixed4 col = tex2Dlod(_MainTex, topDownProjection.xyxy);
                float4 col = tex2D(_MainTex, topDownProjection);
                return col;
            }
            ENDCG
        }
    }
}
