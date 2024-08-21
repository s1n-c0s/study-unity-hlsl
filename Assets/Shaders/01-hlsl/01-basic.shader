Shader "Custom/AnimatedWaterShaderWithHeight"
{
    Properties
    {
        _Color("Water Color", Color) = (0, 0.5, 1, 1)
        _WaveSpeed("Wave Speed", Range(0.1, 2)) = 1
        _WaveScale("Wave Scale", Range(0.01, 1)) = 0.1
        _WaveFrequency("Wave Frequency", Range(0.1, 2)) = 1
        _WaveHeight("Wave Height", Range(0, 1)) = 0.1
        _ReflectionTex("Reflection Texture", 2D) = "white" {}
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
            };

            sampler2D _ReflectionTex;
            float4 _Color;
            float _WaveSpeed;
            float _WaveScale;
            float _WaveFrequency;
            float _WaveHeight;

            v2f vert(appdata v)
            {
                v2f o;

                // Calculate wave displacement
                float waveX = sin(v.vertex.x * _WaveFrequency + _Time.y * _WaveSpeed) * _WaveHeight;
                float waveZ = sin(v.vertex.z * _WaveFrequency + _Time.y * _WaveSpeed) * _WaveHeight;
                float displacement = waveX + waveZ;

                // Apply displacement to vertex position
                v.vertex.y += displacement;

                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;

                // Calculate world position for further use in fragment shader
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // Sample the reflection texture
                fixed4 reflection = tex2D(_ReflectionTex, i.uv);

                // Mix the reflection with the water color
                fixed4 color = lerp(_Color, reflection, 0.5);

                return color;
            }
            ENDCG
        }
    }
}
