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
		_XL_tex("XL_tex", 2D) = "white" {}
		_L_tex("L_tex", 2D) = "white" {}
		_Offset("Offset", Int) = 0

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
			uniform sampler2D _XL_tex;
			uniform int _Offset;
			uniform sampler2D _L_tex;

			
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

				int Offset146 = _Offset;
				int BarCount92 = ( 10 * 3 );
				float2 appendResult148 = (float2((float)( ( Offset146 % floor( BarCount92 ) ) / BarCount92 ) , 0.0));
				float2 texCoord56 = IN.texcoord.xy * float2( 1,1 ) + appendResult148;
				float temp_output_57_0 = ( texCoord56.x * BarCount92 );
				float BarUV_x119 = ( temp_output_57_0 % 1.0 );
				float2 texCoord244 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float BarIdx69 = floor( temp_output_57_0 );
				float temp_output_234_0 = ( -( cos( ( ( 0.0 + ( BarIdx69 * 0.05 ) ) * UNITY_PI ) ) - 1.0 ) / 2.0 );
				float temp_output_232_0 = ( ( 0.2 + 0.8 ) / 2.0 );
				float clampResult246 = clamp( temp_output_234_0 , 0.2 , temp_output_232_0 );
				float temp_output_250_0 = ( -( cos( ( ( 1.0 + ( BarIdx69 * 0.05 * -1 ) ) * UNITY_PI ) ) - 1.0 ) / 2.0 );
				float clampResult237 = clamp( temp_output_250_0 , temp_output_232_0 , 0.8 );
				float temp_output_251_0 = (0.0 + (texCoord244.y - clampResult246) * (1.0 - 0.0) / (clampResult237 - clampResult246));
				float2 appendResult236 = (float2(BarUV_x119 , (( temp_output_251_0 >= 0.0 && temp_output_251_0 <= 1.0 ) ? temp_output_251_0 :  0.0 )));
				float2 texCoord231 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float clampResult239 = clamp( temp_output_250_0 , temp_output_232_0 , 0.8 );
				float temp_output_240_0 = (0.0 + (texCoord231.y - clampResult239) * (1.0 - 0.0) / (1.0 - clampResult239));
				float2 appendResult253 = (float2(BarUV_x119 , (( temp_output_240_0 >= 0.0 && temp_output_240_0 <= 1.0 ) ? temp_output_240_0 :  0.0 )));
				float clampResult230 = clamp( temp_output_234_0 , 0.2 , temp_output_232_0 );
				float temp_output_247_0 = (0.0 + (texCoord231.y - 0.0) * (1.0 - 0.0) / (clampResult230 - 0.0));
				float2 appendResult252 = (float2(BarUV_x119 , (( temp_output_247_0 >= 0.0 && temp_output_247_0 <= 1.0 ) ? temp_output_247_0 :  0.0 )));
				
				half4 color = ( tex2D( _XL_tex, appendResult236 ) + tex2D( _L_tex, appendResult253 ) + tex2D( _L_tex, appendResult252 ) );
				
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
-2560;0;2560;1419;5045.462;-795.8698;1;True;True
Node;AmplifyShaderEditor.IntNode;53;-3001.195,-576.67;Inherit;False;Constant;_BarCount;BarCount;8;0;Create;True;0;0;0;False;0;False;10;0;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;64;-3001.671,-499.4496;Inherit;False;Constant;_LevelCount;LevelCount;8;0;Create;True;0;0;0;False;0;False;3;0;False;0;1;INT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-2853.492,-563.2979;Inherit;False;2;2;0;INT;0;False;1;INT;0;False;1;INT;0
Node;AmplifyShaderEditor.IntNode;195;-3003.096,-420.1694;Inherit;False;Property;_Offset;Offset;8;0;Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;92;-2729.85,-574.7738;Inherit;False;BarCount;-1;True;1;0;INT;0;False;1;INT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;146;-2865.418,-420.3723;Inherit;False;Offset;-1;True;1;0;INT;0;False;1;INT;0
Node;AmplifyShaderEditor.GetLocalVarNode;202;-3829.039,177.6958;Inherit;False;92;BarCount;1;0;OBJECT;;False;1;INT;0
Node;AmplifyShaderEditor.FloorOpNode;214;-3773.066,100.4529;Inherit;False;1;0;INT;0;False;1;INT;0
Node;AmplifyShaderEditor.GetLocalVarNode;197;-3822.696,14.03025;Inherit;False;146;Offset;1;0;OBJECT;;False;1;INT;0
Node;AmplifyShaderEditor.SimpleRemainderNode;203;-3656.671,19.88215;Inherit;False;2;0;INT;0;False;1;INT;10;False;1;INT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;198;-3476.097,17.13026;Inherit;False;2;0;INT;0;False;1;INT;10;False;1;INT;0
Node;AmplifyShaderEditor.DynamicAppendNode;148;-3341.94,31.38155;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;56;-3188.554,-18.72038;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-2909.196,24.62976;Inherit;False;2;2;0;FLOAT;0;False;1;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;71;-2800.493,138.0013;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;69;-2628.493,131.0014;Inherit;False;BarIdx;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;235;-4288.447,1297.731;Inherit;False;Constant;_2;-1;8;0;Create;True;0;0;0;False;0;False;-1;0;False;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;257;-4298.926,1191.26;Inherit;False;Constant;_Step1;Step;8;0;Create;True;0;0;0;False;0;False;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;79;-4745.163,1295.201;Inherit;False;69;BarIdx;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;224;-4742.905,1525.334;Inherit;False;Constant;_Float1;Float 1;9;0;Create;True;0;0;0;False;0;False;0.8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;242;-4128.056,1119.463;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;245;-4135.056,1254.463;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0.1;False;2;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;223;-4742.905,1451.334;Inherit;False;Constant;_Float0;Float 0;9;0;Create;True;0;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;229;-3996.054,1095.463;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;233;-3986.054,1230.463;Inherit;False;2;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;241;-4161.066,1568.497;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;234;-3853.444,1097.731;Inherit;False;InOutSine;-1;;57;6eeb75ced27e1014088c1df66c5d5726;0;1;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;232;-4039.063,1567.497;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;250;-3859.444,1228.731;Inherit;False;InOutSine;-1;;58;6eeb75ced27e1014088c1df66c5d5726;0;1;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;237;-3458.186,1227.266;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;230;-3482.092,1815.495;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;244;-3531.187,975.2752;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleRemainderNode;58;-2774.482,24.70517;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;246;-3458.186,1097.266;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;231;-3551.092,1392.503;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;239;-3478.092,1514.495;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;119;-2629.198,20.07566;Inherit;False;BarUV_x;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;247;-3292.204,1766.603;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;251;-3276.054,1118.463;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;240;-3291.96,1535.693;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;133;-3488.596,-684.0609;Inherit;True;Property;_L_tex;L_tex;5;0;Create;True;0;0;0;False;0;False;None;e884f18850429244e8e81f88feeced87;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;129;-3495.718,-881.2125;Inherit;True;Property;_XL_tex;XL_tex;4;0;Create;True;0;0;0;False;0;False;None;d40652b6855684246b90070687ee1a9a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;120;-4744.616,1373.342;Inherit;False;119;BarUV_x;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCCompareWithRange;255;-3055.7,1105.948;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCCompareWithRange;238;-3038.7,1492.948;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;130;-3272.299,-878.8944;Inherit;False;XLtex;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;134;-3266.177,-681.7428;Inherit;False;Ltex;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TFHCCompareWithRange;256;-3033.7,1767.948;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;236;-2741.195,1027.818;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;252;-2669.883,1741.266;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;131;-4742.437,1602.225;Inherit;False;130;XLtex;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;139;-4742.3,1679.163;Inherit;False;134;Ltex;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.DynamicAppendNode;253;-2706.971,1366.752;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;248;-2499.194,1005.78;Inherit;True;Property;_XLtex1;XLtex;6;0;Create;True;0;0;0;False;0;False;-1;d40652b6855684246b90070687ee1a9a;d40652b6855684246b90070687ee1a9a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;243;-2471.338,1369.573;Inherit;True;Property;_Ltex1;Ltex;5;0;Create;True;0;0;0;False;0;False;-1;f62c0c3a5ddcd844e905fb2632fdcb15;e884f18850429244e8e81f88feeced87;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;249;-2470.425,1712.961;Inherit;True;Property;_TextureSample1;Texture Sample 0;7;0;Create;True;0;0;0;False;0;False;-1;f62c0c3a5ddcd844e905fb2632fdcb15;e884f18850429244e8e81f88feeced87;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IntNode;9;-3004.22,-268.4402;Inherit;False;Property;_Frame;Frame;2;0;Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;3;-2999.613,-122.9392;Inherit;False;Property;_Rows;Rows;0;0;Create;True;0;0;0;False;0;False;1;0;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;18;-3011.973,-340.8731;Inherit;False;Property;_Horizontal;Horizontal;3;0;Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.TexturePropertyNode;135;-3488.53,-490.2541;Inherit;True;Property;_M_tex;M_tex;6;0;Create;True;0;0;0;False;0;False;None;1a905e3d3f65892468abba6ba912457c;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.Compare;21;-2858.973,-341.8731;Inherit;False;0;4;0;INT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;4;-3004.225,-194.4372;Inherit;False;Property;_Columns;Columns;1;0;Create;True;0;0;0;False;0;False;1;2;False;0;1;INT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;138;-3264.111,-293.936;Inherit;False;Stex;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TexturePropertyNode;137;-3486.53,-296.2541;Inherit;True;Property;_S_tex;S_tex;7;0;Create;True;0;0;0;False;0;False;None;25f9be7dfd9728845a09969173bd85d5;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleAddOpNode;254;-2142.134,1352.36;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;136;-3266.111,-487.936;Inherit;False;Mtex;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-1727.063,1328.442;Float;False;True;-1;2;ASEMaterialInspector;0;4;wwc/Wave;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;False;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;True;True;True;True;True;0;True;-9;False;False;False;False;False;False;False;True;True;0;True;-5;255;True;-8;255;True;-7;0;True;-4;0;True;-6;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;0;True;-11;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;63;0;53;0
WireConnection;63;1;64;0
WireConnection;92;0;63;0
WireConnection;146;0;195;0
WireConnection;214;0;202;0
WireConnection;203;0;197;0
WireConnection;203;1;214;0
WireConnection;198;0;203;0
WireConnection;198;1;202;0
WireConnection;148;0;198;0
WireConnection;56;1;148;0
WireConnection;57;0;56;1
WireConnection;57;1;202;0
WireConnection;71;0;57;0
WireConnection;69;0;71;0
WireConnection;242;0;79;0
WireConnection;242;1;257;0
WireConnection;245;0;79;0
WireConnection;245;1;257;0
WireConnection;245;2;235;0
WireConnection;229;1;242;0
WireConnection;233;1;245;0
WireConnection;241;0;223;0
WireConnection;241;1;224;0
WireConnection;234;1;229;0
WireConnection;232;0;241;0
WireConnection;250;1;233;0
WireConnection;237;0;250;0
WireConnection;237;1;232;0
WireConnection;237;2;224;0
WireConnection;230;0;234;0
WireConnection;230;1;223;0
WireConnection;230;2;232;0
WireConnection;58;0;57;0
WireConnection;246;0;234;0
WireConnection;246;1;223;0
WireConnection;246;2;232;0
WireConnection;239;0;250;0
WireConnection;239;1;232;0
WireConnection;239;2;224;0
WireConnection;119;0;58;0
WireConnection;247;0;231;2
WireConnection;247;2;230;0
WireConnection;251;0;244;2
WireConnection;251;1;246;0
WireConnection;251;2;237;0
WireConnection;240;0;231;2
WireConnection;240;1;239;0
WireConnection;255;0;251;0
WireConnection;255;3;251;0
WireConnection;238;0;240;0
WireConnection;238;3;240;0
WireConnection;130;0;129;0
WireConnection;134;0;133;0
WireConnection;256;0;247;0
WireConnection;256;3;247;0
WireConnection;236;0;120;0
WireConnection;236;1;255;0
WireConnection;252;0;120;0
WireConnection;252;1;256;0
WireConnection;253;0;120;0
WireConnection;253;1;238;0
WireConnection;248;0;131;0
WireConnection;248;1;236;0
WireConnection;243;0;139;0
WireConnection;243;1;253;0
WireConnection;249;0;139;0
WireConnection;249;1;252;0
WireConnection;21;0;18;0
WireConnection;138;0;137;0
WireConnection;254;0;248;0
WireConnection;254;1;243;0
WireConnection;254;2;249;0
WireConnection;136;0;135;0
WireConnection;0;0;254;0
ASEEND*/
//CHKSM=BCCAFA91685DC2ADBF028C0B9E763CDE1BDC75C2