Shader "Unlit/Hologram"
{
    Properties
    {
        _MainTex ("Albedo Texture", 2D) = "white" {}
        _TintColor("Tint Color", Color) = (1,1,1,1)
        _Transparency("Transparency", Range(0.0, 1.0)) = 0.25

        _CutoutThresh("cutout thresh", Float) = 1

        _SplitAmount("splitAmount", Range(-1,1)) = 0.5
        _GapSize("gapsize", Float) = 1
    }
    SubShader
    {
        //Tags { "Queue" = "Transparent" "RenderType"="Transparent" }
		Tags { "RenderType" = "Opaque" }

        LOD 100

        //ZWrite Off
		//Blend SrcAlpha OneMinusSrcAlpha 

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _TintColor;
            float _Transparency; 

            float _CutoutThresh;

            float _SplitAmount;
            float _GapSize;

            v2f vert (appdata v)
            {
                v2f o;


                if (v.vertex.x > _SplitAmount) {
                    v.vertex.x += _GapSize;
                }
                else {
                    v.vertex.x -= _GapSize;
                }

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv) + _TintColor;
				clip(col.b - _CutoutThresh);
				col.a = _Transparency;
                return col;
            }
            ENDCG
        }
    }
}
