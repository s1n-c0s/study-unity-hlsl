Shader "Intro/01-basic"
{
    Properties
    {
        _Color("Test Color", Color)=(1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert // Run on every vert
            #pragma fragment frag // Run on every single pixel
            
            #include "UnityCG.cginc"

            struct appdata // Object Data or Mesh
            {
                float4 vertex : POSITION;
      
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                half2 someValue = half2(1,1);
                fixed4 col = 1;
                return col;
            }
            ENDCG
        }
    }
}
