Shader "Custom/TextureSplatting"
{
    Properties
    {  
        _MainTexture ("SplatMap", 2D) = "white" {}
        [NoScaleOffset] _Texture1 ("Texture 1", 2D) = "white" {}
        [NoScaleOffset] _Texture2 ("Texture 2", 2D) = "white" {}
        [NoScaleOffset] _Texture3 ("Texture 3", 2D) = "white" {}
        [NoScaleOffset] _Texture4 ("Texture 4", 2D) = "white" {}
    }
    
    SubShader
    {
        Pass
        {
            CGPROGRAM

            #pragma vertex MyVertexProgram
            #pragma fragment MyFragmentProgram
            
			#include "UnityCG.cginc"

            sampler2D _MainTexture;
            float4 _MainTexture_ST;

            sampler2D _Texture1, _Texture2, _Texture3, _Texture4;

            struct VertexData
            {
                float4 position : POSITION;
                float2 uv : TEXCOORD0;
            };
            
            struct Interpolators
            {
                float4 position : POSITION;
                float2 uv : TEXCOORD0;
                float2 uvSplat : TEXCOORD1;
            };

            Interpolators MyVertexProgram(VertexData vertexData)
            {
                Interpolators i;
                i.position = UnityObjectToClipPos(vertexData.position);
                i.uv = TRANSFORM_TEX(vertexData.uv, _MainTexture);
                i.uvSplat = vertexData.uv;
                return i;
            }

            float4 MyFragmentProgram(Interpolators i) : SV_TARGET
            {
                float4 splat = tex2D(_MainTexture, i.uvSplat);
                return
                    tex2D(_Texture1, i.uv) * splat.r
                    + tex2D(_Texture2, i.uv) * splat.g
                    + tex2D(_Texture3, i.uv) * splat.b
                    + tex2D(_Texture4, i.uv) * (1 - splat.r - splat.g - splat.b);
            }
            
            ENDCG
        }
    }
}
