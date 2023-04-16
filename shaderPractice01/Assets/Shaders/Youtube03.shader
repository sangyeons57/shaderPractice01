Shader "Unlit/Youtube03"
{
    Properties
    {
        _colorA ("Color A", Color) = (1,1,1,1)
        _colorB ("Color B", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}
        _waveAmp("WaveAmp", Range(0,1)) = 0.1
    }
        SubShader
        {
            Tags { "RenderType" = "Opaque" }
            LOD 100

            Pass
            {

            CGPROGRAM
            #pragma vertex vert
			#pragma fragment frag

            #include "UnityCG.cginc"

			#define TAU 6.2831855


            sampler2D _MainTex;
    float4 _colorA;
    float4 _colorB;
    float _waveAmp;


            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            float GetWave(float2 uv) {
                float2 uvsCentered = uv * 2 - 1;
                float radialDistance = length(uvsCentered);
                float waves =  cos((radialDistance - _Time.y * 0.1 ) * TAU * 5) * 0.5 + 0.5;
                waves *= 1 - radialDistance;
                return waves;

            }


            v2f vert (MeshData IN)
            {
                v2f OUT;
				//float wave =  cos((IN.uv.y - _Time.y * 0.1 ) * TAU * 10);
                /*
                float wave2 = cos((IN.uv.x - _Time.y * 0.1) * TAU * 5);
                float wave = cos((IN.uv.y - _Time.y * 0.1) * TAU * 5);
                IN.vertex.y = wave * wave2 * _waveAmp;
                */
                //IN.vertex.y = GetWave(IN.uv) * _waveAmp;


                OUT.vertex = UnityObjectToClipPos(IN.vertex);
                OUT.uv = IN.uv;
                return OUT;
            }


            float Noise(float2 xy)
			{
				float2 noise = (frac(sin(dot(xy, float2(12.9898, 78.233) * 2.0)) * 43758.5453));
				return abs(noise.x + noise.y) * 0.5;
			}

            float SmoothNoise(float integer_x, float integer_y)
			{
				float corners = (Noise(float2(integer_x - 1, integer_y - 1)) + Noise(float2(integer_x + 1, integer_y + 1)) + Noise(float2(integer_x + 1, integer_y - 1)) + Noise(float2(integer_x - 1, integer_y + 1))) / 16.0f;
				float sides = (Noise(float2(integer_x, integer_y - 1)) + Noise(float2(integer_x, integer_y + 1)) + Noise(float2(integer_x + 1, integer_y)) + Noise(float2(integer_x - 1, integer_y))) / 8.0f;
				float center = Noise(float2(integer_x, integer_y)) / 4.0f;
				return corners + sides + center;
			}

            float CosineInterpolation(float x, float y, float fractional)
			{
				float ft = 3.141592f * fractional;
				float f = (1.0f - cos(ft)) * 0.5f;
				return x * (1.0f - f) + y * f;
			}

            float InterpolatedNoise(float x, float y)
			{
				float integer_x = x - frac(x), fractional_x = frac(x);
				float integer_y = y - frac(y), fractional_y = frac(y);

				float p1 = SmoothNoise(integer_x, integer_y);
				float p2 = SmoothNoise(integer_x + 1, integer_y);
				float p3 = SmoothNoise(integer_x, integer_y + 1);
				float p4 = SmoothNoise(integer_x + 1, integer_y + 1);

				p1 = CosineInterpolation(p1, p2, fractional_x);
				p2 = CosineInterpolation(p3, p4, fractional_x);

				return CosineInterpolation(p1, p2, fractional_y);
			}

            float CreatePerlinNoise(float x, float y)
			{
				float result = 0.0f;
				float amplitude = 0.0f;
				float frequency = 0.0f;
				float persistance = 0.1f;

				for (int i = 1; i <= 4; i++)
				{
					frequency += 20;
					amplitude += persistance;

					result += InterpolatedNoise(x * frequency, y * frequency) * amplitude;
				}

				return result;
			}

            fixed4 frag(v2f IN) : SV_Target
            {
                /*
                float waves =  cos((IN.uv.y - _Time.y * 0.1 ) * TAU * 10) * 0.5 + 0.1;
                float4 OUT = lerp(_colorA, _colorB, waves);
                */
                //return GetWave(IN.uv);
                float o = IN.uv.x;
				float a = CreatePerlinNoise(IN.uv.x, IN.uv.y);

				return a;

            }
            ENDCG
        }
    }
}
