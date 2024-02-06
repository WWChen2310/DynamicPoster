// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "wwc/Wave"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		
		_StencilComp ("Stencil Comparison", Float) = 8
		_Stencil ("Stencil ID", Float) = 0
		_StencilOp ("Stencil Operation", Float) = 0
		_StencilWriteMask ("Stencil Write Mask", Float) = 255
		_StencilReadMask ("Stencil Read Mask", Float) = 255

		_ColorMask ("Color Mask", Float) = 15

		[Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
		_Columns("Columns", Int) = 1
		_Stex("Stex", 2D) = "white" {}
		_Mtex("Mtex", 2D) = "white" {}
		_Ltex("Ltex", 2D) = "white" {}
		_XLtex("XLtex", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }
		
		Stencil
		{
			Ref [_Stencil]
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
			CompFront [_StencilComp]
			PassFront [_StencilOp]
			FailFront Keep
			ZFailFront Keep
			CompBack Always
			PassBack Keep
			FailBack Keep
			ZFailBack Keep
		}


		Cull Off
		Lighting Off
		ZWrite Off
		ZTest [unity_GUIZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha
		ColorMask [_ColorMask]

		
		Pass
		{
			Name "Default"
		CGPROGRAM
			
			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			#include "UnityCG.cginc"
			#include "UnityUI.cginc"

			#pragma multi_compile __ UNITY_UI_CLIP_RECT
			#pragma multi_compile __ UNITY_UI_ALPHACLIP
			
			
			
			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				half2 texcoord  : TEXCOORD0;
				float4 worldPosition : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				
			};
			
			uniform fixed4 _Color;
			uniform fixed4 _TextureSampleAdd;
			uniform float4 _ClipRect;
			uniform sampler2D _MainTex;
			uniform int _Columns;
			uniform sampler2D _Stex;
			uniform float4 _Stex_ST;
			uniform sampler2D _Mtex;
			uniform float4 _Mtex_ST;
			uniform sampler2D _Ltex;
			uniform float4 _Ltex_ST;
			uniform sampler2D _XLtex;
			uniform float4 _XLtex_ST;

			
			v2f vert( appdata_t IN  )
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID( IN );
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				UNITY_TRANSFER_INSTANCE_ID(IN, OUT);
				OUT.worldPosition = IN.vertex;
				
				
				OUT.worldPosition.xyz +=  float3( 0, 0, 0 ) ;
				OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

				OUT.texcoord = IN.texcoord;
				
				OUT.color = IN.color * _Color;
				return OUT;
			}

			fixed4 frag(v2f IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				float2 texCoord13_g4 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_2_0_g4 = (float)_Columns;
				float temp_output_11_0_g4 = ( texCoord13_g4.x * temp_output_2_0_g4 * 3 );
				float level20_g4 = floor( temp_output_11_0_g4 );
				float temp_output_50_15 = level20_g4;
				float2 uv_Stex = IN.texcoord.xy * _Stex_ST.xy + _Stex_ST.zw;
				float2 uv_Mtex = IN.texcoord.xy * _Mtex_ST.xy + _Mtex_ST.zw;
				float2 uv_Ltex = IN.texcoord.xy * _Ltex_ST.xy + _Ltex_ST.zw;
				float2 uv_XLtex = IN.texcoord.xy * _XLtex_ST.xy + _XLtex_ST.zw;
				
				half4 color = ( temp_output_50_15 == 0.0 ? tex2D( _Stex, uv_Stex ) : ( temp_output_50_15 == 1.0 ? tex2D( _Mtex, uv_Mtex ) : ( temp_output_50_15 == 2.0 ? tex2D( _Ltex, uv_Ltex ) : tex2D( _XLtex, uv_XLtex ) ) ) );
				
				#ifdef UNITY_UI_CLIP_RECT
                color.a *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);
                #endif
				
				#ifdef UNITY_UI_ALPHACLIP
				clip (color.a - 0.001);
				#endif

				return color;
			}
		ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
-2560;0;2560;1371;3546.845;1462.162;1;True;True
Node;AmplifyShaderEditor.IntNode;4;-3184.833,-1120.351;Inherit;False;Property;_Columns;Columns;1;0;Create;True;0;0;0;False;0;False;1;2;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;3;-3183.221,-1007.853;Inherit;False;Property;_Rows;Rows;0;0;Create;True;0;0;0;False;0;False;1;0;False;0;1;INT;0
Node;AmplifyShaderEditor.FunctionNode;50;-3038.264,-1076.358;Inherit;False;WaveHelper;-1;;4;596e890aaa83027489028e677a92274a;0;2;2;FLOAT;1;False;5;FLOAT;1;False;2;FLOAT;15;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;44;-2566.556,-428.2451;Inherit;True;Property;_Ltex;Ltex;6;0;Create;True;0;0;0;False;0;False;-1;e884f18850429244e8e81f88feeced87;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;45;-2566.556,-238.2451;Inherit;True;Property;_XLtex;XLtex;7;0;Create;True;0;0;0;False;0;False;-1;d40652b6855684246b90070687ee1a9a;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;43;-2566.556,-618.2451;Inherit;True;Property;_Mtex;Mtex;5;0;Create;True;0;0;0;False;0;False;-1;1a905e3d3f65892468abba6ba912457c;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Compare;48;-2035.63,-502.3226;Inherit;False;0;4;0;FLOAT;0;False;1;FLOAT;2;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Compare;47;-2042.63,-676.3226;Inherit;False;0;4;0;FLOAT;0;False;1;FLOAT;1;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;42;-2566.256,-807.3523;Inherit;True;Property;_Stex;Stex;4;0;Create;True;0;0;0;False;0;False;-1;25f9be7dfd9728845a09969173bd85d5;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;15;-2601.438,-1036.95;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BreakToComponentsNode;41;-2740.089,-1037.537;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.IntNode;18;-2737.581,-1558.787;Inherit;False;Property;_Horizontal;Horizontal;3;0;Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.Compare;21;-2525.581,-1538.787;Inherit;False;0;4;0;INT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;9;-2774.828,-1434.354;Inherit;False;Property;_Frame;Frame;2;0;Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.Compare;46;-2039.556,-858.2451;Inherit;False;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-1483.631,-906.0242;Float;False;True;-1;2;ASEMaterialInspector;0;4;wwc/Wave;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;False;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;True;True;True;True;True;0;True;-9;False;False;False;False;False;False;False;True;True;0;True;-5;255;True;-8;255;True;-7;0;True;-4;0;True;-6;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;0;True;-11;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;50;2;4;0
WireConnection;50;5;3;0
WireConnection;44;1;50;0
WireConnection;45;1;50;0
WireConnection;43;1;50;0
WireConnection;48;0;50;15
WireConnection;48;2;44;0
WireConnection;48;3;45;0
WireConnection;47;0;50;15
WireConnection;47;2;43;0
WireConnection;47;3;48;0
WireConnection;42;1;50;0
WireConnection;15;0;41;0
WireConnection;15;1;41;1
WireConnection;41;0;50;0
WireConnection;21;0;18;0
WireConnection;46;0;50;15
WireConnection;46;2;42;0
WireConnection;46;3;47;0
WireConnection;0;0;46;0
ASEEND*/
//CHKSM=E76C5B5977CF4566F1921C1F91DB2BE062E89375