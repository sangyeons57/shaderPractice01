Shader "Unlit/Youtube01"
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
        Tags { "RenderType" = "Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

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

                return OUT;
            }

            float InverseLerp(float a, float b, float v)
            {
                return (v - a) / (b - a);
            }

            float CorrectionOverValue(float num) 
            {
                if (num < 0) return 0;
                else if (num > 1) return 1;
                else return num;
            }

            float4 frag(v2f IN) : SV_Target
            {
                //float t = CorrectionOverValue(InverseLerp(_ColorStart, _ColorEnd, IN.uv.x));
                //float t = saturate(InverseLerp(_ColorStart, _ColorEnd, IN.uv.x));
				//t = frac(t);
                float t = smoothstep(_ColorStart, _ColorEnd, IN.uv.x);
				t = abs(frac(t * 5) * 2 - 1);
				float4 outColor = lerp(_ColorA, _ColorB, t);
                return outColor;
            }
            ENDCG
        }
    }
}












