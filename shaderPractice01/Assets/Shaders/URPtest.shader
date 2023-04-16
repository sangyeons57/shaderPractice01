Shader "Unlit/URPtest"
{
    // ����Ƽ ���̴��� ������Ƽ ��(�������̽��� ����� ��)�Դϴ�. ������ ��������ϴ�. 
// �ֳ��ϸ� �����׸�Ʈ (�ȼ�) ���̴� �ڵ忡�� ��� Į�� �� ������ ���� �����Դϴ� 
    Properties
    {
		_MainTex("Main Texture", 2D) = "white"
    }

        // �����̴� ���� ���̴� �ڵ尡 ��� �ֽ��ϴ� 
	SubShader
    {
        // �����̴� �±״� ���� � ���ǿ��� �����̴� ���� �����ϴ��� �Ǵ� 
        //�н��� ����Ǵ����� �����մϴ�. (�׳� ������ ������ �±׶� ���Դϴ�.) 
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            // HLSL(High Level Shader Language) �ڵ� ���Դϴ�. SRP�� HLSL�� ����մϴ� 
            HLSLPROGRAM
            // ����� ���ؽ� ���̴��� �̸��� �����ϰ��
            #pragma vertex vert
            // ����� �����׸�Ʈ(�ȼ�) ���̴��� �̸��� �����մϴ�. 
            #pragma fragment frag

            // Core.hlsl ���Ͽ��� ���� ���Ǵ� HLSL ��ũ�γ� �Լ��� ���ǵǾ� �ֽ��ϴ�. 
            // �׸��� �̷��� #include�� ����ϸ� �ٸ� HLSL ���ϵ��� ������ �� �ֽ��ϴ�. 
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            // �� ����ü���� � ������ ��� �ִ��� ���ǵǾ� �ֽ��ϴ�. 
            // �� ���������� Attributes ����ü�� ���ؽ� ���̴��� ��ǲ ����ü�� ����ϰ� �ֽ��ϴ�. 
            struct Attributes 
			{
				// positionOS ������ ������Ʈ �����̽��� ���ؽ� �������� ������ �ֽ��ϴ� 
				float4 positionOS   : POSITION;

				float2 uv           : TEXCOORD0;
				half3 normal         : NORMAL;
			};

			struct Varyings
			{
				// �� ����ü�� ������ ������ �ݵ�� SV_POSITION �ø�ƽ�� ������ �־�� �մϴ�. 
				float4 positionHCS  : SV_POSITION;
				float2 uv           : UV;

				half3 normal        : TEXCOORD0;
			};

			TEXTURE2D(_MainTex);
			SAMPLER(sampler_MainTex);

			CBUFFER_START(unityPerMaterial)
				half4 _MainTex_ST;
			CBUFFER_END

			// ���ؽ� ���̴��� Varyings�� ��ҷ� ���ǵ˴ϴ�. 
			// ���ؽ� ���̴��� Ÿ���� �ݵ�� ����� �ִ� ����ü�� Ÿ�԰� ��ġ�ؾ� �մϴ�. 
			Varyings vert(Attributes IN)
			{
				//  Varyings ����ü�� ���(OUT) ������ ���ݴϴ�. 
				Varyings OUT;
				// TransformObjectToHClip �Լ��� ������Ʈ ��ǥ���� ���ؽ� �������� 
				// Ŭ�������̽��� ��ȯ���ݴϴ�. 
				OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
				OUT.uv = TRANSFORM_TEX(IN.uv, _MainTex);
				//OUT.normal = TransformObjectToWorldNormal(IN.normal);


				// output�� ������ �ݴϴ�. 
				return OUT;
			}

			// �����׸�Ʈ (�ȼ�) ���̴� �����Դϴ�. 
			half4 frag(Varyings IN) : SV_Target
			{
				// ���� �����ϰ� ������ �ݴϴ�. 
				 half4 color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv);
				 //half4 color = 0;
				//color.rgb = IN.normal * 0.5 + 0.5;
				return color;
			}
			ENDHLSL
		}
	}
}
