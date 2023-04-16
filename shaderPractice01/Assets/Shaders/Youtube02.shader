Shader "Unlit/Youtube02"
{
    Properties
    {
        // _MainTex ("Texture", 2D) = "white" {}
        _ColorA("Color A", Color) = (1,1,1,1)
        _ColorB("Color B", Color) = (1,1,1,1)
        _ColorStart("Color Start", Range(0,1)) = 0
        _ColorEnd("Color End", Range(0,1)) = 1
    }
        SubShader
    {
        Tags { "RenderType" = "Transparent" "Queue" = "Transparent"}

        Pass
        {
            Cull Off
            ZWrite Off
            ZTest LEqual
            Blend one one //Additive

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

			#define TAU 6.2831855

            float4 _ColorA;
            float4 _ColorB;
            float _ColorStart;
            float _ColorEnd;

            struct MeshData
            {
                float4 vertex : POSITION;
                float3 normals : NORMAL;
                float2 uv : TEXCOORD0;

            };

            struct v2f
            {
                float3 normal : TEXCOORD0;
                float2 uv : TEXCOORD1;
                float4 vertex : SV_POSITION;

                float num : NUM;
            };


            v2f vert (MeshData IN)
            {
                v2f OUT;
                OUT.vertex = UnityObjectToClipPos(IN.vertex);
                OUT.normal = UnityObjectToWorldNormal(IN.normals);
                OUT.uv = IN.uv;
                OUT.num = IN.vertex.y;

                return OUT;
            }

            float InverseLerp(float a, float b, float v)
            {
                return (v - a) / (b - a);
            }

            float4 frag(v2f IN) : SV_Target
            {


                float xOffset = cos(IN.uv.x * TAU * 8)*0.01;
				float t = cos((IN.uv.y + xOffset - _Time.y * 0.1) * TAU * 5) * 0.5 + 0.5;
                t *= 1 - IN.uv.y;

                float topBottomRemover = (abs(IN.normal.y) < 0.999);
                float waves = t * topBottomRemover;

                float4 gradiant = lerp(_ColorA, _ColorB, IN.uv.y);

                return gradiant * waves;
            }
            ENDCG
        }
    }
}
