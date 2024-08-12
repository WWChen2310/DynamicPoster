// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "wwc/line_shaderlab"
{
    Properties
    {
        _Tex1 ("Texture1", 2D) = "white" {}
        _Tex2 ("Texture2", 2D) = "white" {}
        _Tex3 ("Texture3", 2D) = "white" {}

        _BarCount ("BarCount", Int) = 10
        _LevelCount ("LevelCount", Int) = 3
        _Frame ("Frame", Int) = 0
    }

    FallBack "UI/Default"

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma fragment frag
            #pragma vertex vert

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            float link( float2 _st, float2 _p1, float2 _p2, float _width, float _spread)
            {
                _width = 1.0 / _width;
                float2 p2p1 = _p1 - _p2;
                float2 p1p2 = -(p2p1);
                float2 p2p = _st - _p2;
                float2 p1p = _st - _p1;
                float2 pp1 = -(p1p);
                float2 pd = normalize(float2(p2p1.y, -p2p1.x));
                float proj = dot(pd, pp1);
                float pr1 = dot(p2p1, p2p);
                float pr2 = dot(p1p2, p1p);

                if(pr1 > 0.0 && pr2 > 0.0) {
                    return pow(1.0 / abs(proj * _width), _spread);
                } else {
                    return 0.0;
                }
            }

            // float drawLine (vec2 p1, vec2 p2, vec2 uv, float a) {
            //     float r = 0.;
            //     float one_px = 1. / iResolution.x; //not really one px
    
            //     // get dist between points
            //     float d = distance(p1, p2);
    
            //     // get dist between current pixel and p1
            //     float duv = distance(p1, uv);

            //     //if point is on line, according to dist, it should match current uv 
            //     r = 1.-floor(1.-(a*one_px)+distance (mix(p1, p2, clamp(duv/d, 0., 1.)),  uv));
        
            //     return r;
            // }

            sampler2D _Tex1;
            float4 _Tex1_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _Tex1);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                // fixed4 col = tex2D(_Tex1, i.uv) * tex2D(_Tex1, i.uv).a;
                // float L = link(i.uv, float2(0.1,0.7), float2(0.9,0.7), 0.01, 10.0) + u_time;
                fixed4 col = fixed4(float3(L, L, L), 1.0) + u_time;
                return col;
            }
            ENDCG
        }
    }
}