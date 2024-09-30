Shader "Custom/TextturedWithDetail"
{
    Properties
    {
        _Tint ("Tint", Color) = (1, 1, 1, 1)    
        _MainTexture ("Texture", 2D) = "white" {}
        _DetailTexture ("DetailTexture", 2D) = "gray" {}
    }
    
    SubShader
    {
        Pass
        {
            CGPROGRAM

            #pragma vertex MyVertexProgram
            #pragma fragment MyFragmentProgram
            
			#include "UnityCG.cginc"

            float4 _Tint;
            sampler2D _MainTexture, _DetailTexture;
            float4 _MainTexture_ST, _DetailTexture_ST;

            struct VertexData
            {
                float4 position : POSITION;
                float2 uv : TEXCOORD0;
            };
            
            struct Interpolators
            {
                float4 position : POSITION;
                float2 uv : TEXCOORD0;
                float2 uvDetail : TEXCOORD1;
            };

            Interpolators MyVertexProgram(VertexData vertexData)
            {
                Interpolators i;
                i.position = UnityObjectToClipPos(vertexData.position);
                i.uv = TRANSFORM_TEX(vertexData.uv, _MainTexture);
                i.uvDetail = TRANSFORM_TEX(vertexData.uv, _DetailTexture);
                return i;
            }

            float4 MyFragmentProgram(Interpolators i) : SV_TARGET
            {
                float4 color = tex2D(_MainTexture, i.uv) * _Tint;
                color *= tex2D(_MainTexture, i.uvDetail) * unity_ColorSpaceDouble;
                return color;
            }
            
            ENDCG
        }
    }
}
