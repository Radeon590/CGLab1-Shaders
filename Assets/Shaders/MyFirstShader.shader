Shader "Custom/MyFirstShader"
{
    Properties
    {
        _Tint ("Tint", Color) = (1, 1, 1, 1)    
        _MainTexture ("Texture", 2D) = "white" {}
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
            sampler2D _MainTexture;

            struct VertexData
            {
                float4 position : POSITION;
                float2 uv : TEXCOORD0;
            };
            
            struct Interpolators
            {
                float4 position : POSITION;
                float2 uv : TEXCOORD0;
            };

            Interpolators MyVertexProgram(VertexData vertexData)
            {
                Interpolators i;
                i.position = UnityObjectToClipPos(vertexData.position);
                i.uv = vertexData.uv;
                return i;
            }

            float4 MyFragmentProgram(Interpolators i) : SV_TARGET
            {
                return float4(i.uv, 1, 1) * _Tint;
            }
            
            ENDCG
        }
    }
}
