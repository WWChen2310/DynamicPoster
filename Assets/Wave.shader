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
		_Offset("Offset", Range( 0 , 1)) = 0

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
			uniform float _Offset;
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

				float Offset146 = _Offset;
				float2 appendResult148 = (float2(Offset146 , 0.0));
				float2 texCoord56 = IN.texcoord.xy * float2( 1,1 ) + appendResult148;
				int BarCount92 = ( 10 * 3 );
				float temp_output_57_0 = ( texCoord56.x * BarCount92 );
				float BarUV_x119 = ( temp_output_57_0 % 1.0 );
				float2 texCoord103 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float BarIdx69 = floor( temp_output_57_0 );
				float temp_output_89_0 = ( -( cos( ( ( 0.0 + ( BarIdx69 * 0.05 ) ) * UNITY_PI ) ) - 1.0 ) / 2.0 );
				float temp_output_155_0 = ( ( 0.0 + 1.0 ) / 2.0 );
				float clampResult99 = clamp( temp_output_89_0 , 0.0 , temp_output_155_0 );
				float temp_output_90_0 = ( -( cos( ( ( 1.0 + ( BarIdx69 * 0.05 * -1 ) ) * UNITY_PI ) ) - 1.0 ) / 2.0 );
				float clampResult100 = clamp( temp_output_90_0 , temp_output_155_0 , 1.0 );
				float clampResult78 = clamp( (0.0 + (texCoord103.y - clampResult99) * (1.0 - 0.0) / (clampResult100 - clampResult99)) , 0.0 , 1.0 );
				float2 appendResult61 = (float2(BarUV_x119 , clampResult78));
				float2 texCoord116 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float clampResult112 = clamp( temp_output_90_0 , temp_output_155_0 , 1.0 );
				float clampResult114 = clamp( (0.0 + (texCoord116.y - clampResult112) * (1.0 - 0.0) / (1.0 - clampResult112)) , 0.0 , 1.0 );
				float2 appendResult122 = (float2(BarUV_x119 , clampResult114));
				float clampResult111 = clamp( temp_output_89_0 , 0.0 , temp_output_155_0 );
				float clampResult128 = clamp( (0.0 + (texCoord116.y - 0.0) * (1.0 - 0.0) / (clampResult111 - 0.0)) , 0.0 , 1.0 );
				float2 appendResult142 = (float2(BarUV_x119 , clampResult128));
				float4 temp_output_102_0 = ( tex2D( _XL_tex, appendResult61 ) + tex2D( _L_tex, appendResult122 ) + tex2D( _L_tex, appendResult142 ) );
				
				half4 color = temp_output_102_0;
				
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
-2560;0;2560;1371;4720.904;-372.481;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;145;-2981.418,-422.3723;Inherit;False;Property;_Offset;Offset;8;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;146;-2719.418,-423.3723;Inherit;False;Offset;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;147;-4193.426,60.48968;Inherit;False;146;Offset;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;64;-4021.671,262.5504;Inherit;False;Constant;_LevelCount;LevelCount;8;0;Create;True;0;0;0;False;0;False;3;0;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;53;-4021.195,185.33;Inherit;False;Constant;_BarCount;BarCount;8;0;Create;True;0;0;0;False;0;False;10;0;False;0;1;INT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-3873.492,198.7021;Inherit;False;2;2;0;INT;0;False;1;INT;0;False;1;INT;0
Node;AmplifyShaderEditor.DynamicAppendNode;148;-4022.939,64.08186;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;92;-3747.85,193.2262;Inherit;False;BarCount;-1;True;1;0;INT;0;False;1;INT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;56;-3767.553,66.97995;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-3488.195,110.3301;Inherit;False;2;2;0;FLOAT;0;False;1;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;71;-3379.492,223.7017;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;69;-3268.492,219.7018;Inherit;False;BarIdx;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-4009.57,805.0764;Inherit;False;Constant;_Step;Step;8;0;Create;True;0;0;0;False;0;False;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;79;-4146.569,895.0765;Inherit;False;69;BarIdx;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;87;-3964.96,988.3442;Inherit;False;Constant;_1;-1;8;0;Create;True;0;0;0;False;0;False;-1;0;False;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;193;-4033.624,1148.05;Inherit;False;Constant;_uv_ymin;uv_y min;9;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;194;-4049.624,1439.05;Inherit;False;Constant;_uv_ymax;uv_y max;9;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-3811.569,945.0764;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0.1;False;2;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-3804.569,810.0764;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;154;-3869.579,1258.111;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;80;-3679.569,920.0765;Inherit;False;2;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;82;-3672.569,786.0764;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;155;-3747.579,1257.111;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;89;-3561.96,787.3442;Inherit;False;InOutSine;-1;;21;6eeb75ced27e1014088c1df66c5d5726;0;1;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;90;-3567.96,918.3443;Inherit;False;InOutSine;-1;;22;6eeb75ced27e1014088c1df66c5d5726;0;1;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;100;-3166.702,916.8799;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleRemainderNode;58;-3353.481,110.4055;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;103;-3239.703,664.8886;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;99;-3166.702,786.8798;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;112;-3186.608,1204.109;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;111;-3190.608,1505.109;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;116;-3259.608,1082.117;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;129;-3494.718,-881.2125;Inherit;True;Property;_XL_tex;XL_tex;4;0;Create;True;0;0;0;False;0;False;None;d40652b6855684246b90070687ee1a9a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TFHCRemapNode;113;-3000.475,1225.306;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;77;-2984.569,808.0764;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;127;-3000.719,1456.217;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;133;-3488.596,-684.0609;Inherit;True;Property;_L_tex;L_tex;5;0;Create;True;0;0;0;False;0;False;None;e884f18850429244e8e81f88feeced87;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;119;-3208.197,105.776;Inherit;False;BarUV_x;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;121;-2552.623,1076.277;Inherit;False;119;BarUV_x;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;120;-2602.024,716.2166;Inherit;False;119;BarUV_x;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;128;-2829.718,1455.217;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;140;-2551.711,1419.665;Inherit;False;119;BarUV_x;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;114;-2829.474,1224.306;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;78;-2806.569,807.0764;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;134;-3266.177,-681.7428;Inherit;False;Ltex;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;130;-3272.299,-878.8944;Inherit;False;XLtex;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.DynamicAppendNode;61;-2429.71,721.4316;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;122;-2380.309,1081.492;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;131;-2394.726,643.0384;Inherit;False;130;XLtex;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;139;-2350.919,987.4373;Inherit;False;134;Ltex;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;141;-2350.007,1330.825;Inherit;False;134;Ltex;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.DynamicAppendNode;142;-2379.398,1424.88;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;62;-2207.709,695.3932;Inherit;True;Property;_XLtex;XLtex;4;0;Create;True;0;0;0;False;0;False;-1;d40652b6855684246b90070687ee1a9a;d40652b6855684246b90070687ee1a9a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;126;-2179.853,1059.187;Inherit;True;Property;_Ltex;Ltex;4;0;Create;True;0;0;0;False;0;False;-1;f62c0c3a5ddcd844e905fb2632fdcb15;e884f18850429244e8e81f88feeced87;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;143;-2178.941,1402.575;Inherit;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;0;False;0;False;-1;f62c0c3a5ddcd844e905fb2632fdcb15;e884f18850429244e8e81f88feeced87;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IntNode;3;-2828.613,92.06079;Inherit;False;Property;_Rows;Rows;0;0;Create;True;0;0;0;False;0;False;1;0;False;0;1;INT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;136;-3266.111,-487.936;Inherit;False;Mtex;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.IntNode;18;-2824.973,-282.8731;Inherit;False;Property;_Horizontal;Horizontal;3;0;Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;149;-1422.085,928.2905;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Compare;21;-2612.973,-262.8731;Inherit;False;0;4;0;INT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;138;-3264.111,-293.936;Inherit;False;Stex;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.Compare;150;-1533.678,633.9189;Inherit;False;5;4;0;FLOAT;0;False;1;FLOAT;0.3333333;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;102;-1626.723,910.1562;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;151;-1816.678,612.9189;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;137;-3486.53,-296.2541;Inherit;True;Property;_S_tex;S_tex;7;0;Create;True;0;0;0;False;0;False;None;25f9be7dfd9728845a09969173bd85d5;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.IntNode;165;-4037.409,2514.273;Inherit;False;Constant;_Int1;Int 1;9;0;Create;True;0;0;0;False;0;False;1;0;False;0;1;INT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;167;-3248.438,2194.279;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;156;-3998.4,1917.238;Inherit;False;Constant;_Float0;Float 0;8;0;Create;True;0;0;0;False;0;False;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;157;-3953.79,2100.506;Inherit;False;Constant;_Int0;Int 0;8;0;Create;True;0;0;0;False;0;False;-1;0;False;0;1;INT;0
Node;AmplifyShaderEditor.GetLocalVarNode;158;-4135.398,2007.238;Inherit;False;69;BarIdx;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;159;-3793.399,1922.238;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;160;-3800.399,2057.238;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0.1;False;2;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;162;-3661.399,1898.238;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;163;-3550.79,1899.506;Inherit;False;InOutSine;-1;;23;6eeb75ced27e1014088c1df66c5d5726;0;1;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;164;-3556.79,2030.506;Inherit;False;InOutSine;-1;;24;6eeb75ced27e1014088c1df66c5d5726;0;1;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;9;-2862.22,-158.4402;Inherit;False;Property;_Frame;Frame;2;0;Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.TexturePropertyNode;135;-3488.53,-490.2541;Inherit;True;Property;_M_tex;M_tex;6;0;Create;True;0;0;0;False;0;False;None;1a905e3d3f65892468abba6ba912457c;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleAddOpNode;161;-3668.399,2032.238;Inherit;False;2;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;179;-2590.854,1828.378;Inherit;False;119;BarUV_x;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;169;-3179.438,2617.271;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;177;-2818.304,2336.468;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;175;-2989.549,2568.379;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;180;-2541.453,2188.439;Inherit;False;119;BarUV_x;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;174;-2973.399,1920.238;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;173;-2989.305,2337.468;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;172;-3228.533,1777.05;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;171;-3155.532,1899.042;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;170;-3175.438,2316.271;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;176;-2818.548,2567.379;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;4;-2830.225,-20.43719;Inherit;False;Property;_Columns;Columns;1;0;Create;True;0;0;0;False;0;False;1;2;False;0;1;INT;0
Node;AmplifyShaderEditor.ClampOpNode;168;-3155.532,2029.042;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;181;-2540.541,2531.827;Inherit;False;119;BarUV_x;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;183;-2338.837,2442.987;Inherit;False;134;Ltex;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.DynamicAppendNode;184;-2368.229,2537.042;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;185;-2369.14,2193.654;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;186;-2383.557,1755.2;Inherit;False;130;XLtex;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.DynamicAppendNode;187;-2418.541,1833.593;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;188;-2167.771,2514.737;Inherit;True;Property;_TextureSample1;Texture Sample 1;4;0;Create;True;0;0;0;False;0;False;-1;f62c0c3a5ddcd844e905fb2632fdcb15;e884f18850429244e8e81f88feeced87;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;189;-2168.683,2171.349;Inherit;True;Property;_TextureSample2;Texture Sample 2;4;0;Create;True;0;0;0;False;0;False;-1;f62c0c3a5ddcd844e905fb2632fdcb15;e884f18850429244e8e81f88feeced87;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;190;-2196.54,1807.555;Inherit;True;Property;_TextureSample3;Texture Sample 3;4;0;Create;True;0;0;0;False;0;False;-1;d40652b6855684246b90070687ee1a9a;d40652b6855684246b90070687ee1a9a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;191;-3858.409,2370.273;Inherit;False;2;2;0;INT;0;False;1;INT;0;False;1;INT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;192;-3736.409,2369.273;Inherit;False;2;0;INT;0;False;1;INT;2;False;1;INT;0
Node;AmplifyShaderEditor.IntNode;166;-4035.878,2263.977;Inherit;False;Constant;_Int2;Int 2;9;0;Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.GetLocalVarNode;182;-2339.75,2099.599;Inherit;False;134;Ltex;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.ClampOpNode;178;-2795.399,1919.238;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-1208.766,955.0303;Float;False;True;-1;2;ASEMaterialInspector;0;4;wwc/Wave;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;False;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;True;True;True;True;True;0;True;-9;False;False;False;False;False;False;False;True;True;0;True;-5;255;True;-8;255;True;-7;0;True;-4;0;True;-6;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;0;True;-11;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;146;0;145;0
WireConnection;63;0;53;0
WireConnection;63;1;64;0
WireConnection;148;0;147;0
WireConnection;92;0;63;0
WireConnection;56;1;148;0
WireConnection;57;0;56;1
WireConnection;57;1;92;0
WireConnection;71;0;57;0
WireConnection;69;0;71;0
WireConnection;83;0;79;0
WireConnection;83;1;86;0
WireConnection;83;2;87;0
WireConnection;81;0;79;0
WireConnection;81;1;86;0
WireConnection;154;0;193;0
WireConnection;154;1;194;0
WireConnection;80;1;83;0
WireConnection;82;1;81;0
WireConnection;155;0;154;0
WireConnection;89;1;82;0
WireConnection;90;1;80;0
WireConnection;100;0;90;0
WireConnection;100;1;155;0
WireConnection;100;2;194;0
WireConnection;58;0;57;0
WireConnection;99;0;89;0
WireConnection;99;1;193;0
WireConnection;99;2;155;0
WireConnection;112;0;90;0
WireConnection;112;1;155;0
WireConnection;112;2;194;0
WireConnection;111;0;89;0
WireConnection;111;1;193;0
WireConnection;111;2;155;0
WireConnection;113;0;116;2
WireConnection;113;1;112;0
WireConnection;77;0;103;2
WireConnection;77;1;99;0
WireConnection;77;2;100;0
WireConnection;127;0;116;2
WireConnection;127;2;111;0
WireConnection;119;0;58;0
WireConnection;128;0;127;0
WireConnection;114;0;113;0
WireConnection;78;0;77;0
WireConnection;134;0;133;0
WireConnection;130;0;129;0
WireConnection;61;0;120;0
WireConnection;61;1;78;0
WireConnection;122;0;121;0
WireConnection;122;1;114;0
WireConnection;142;0;140;0
WireConnection;142;1;128;0
WireConnection;62;0;131;0
WireConnection;62;1;61;0
WireConnection;126;0;139;0
WireConnection;126;1;122;0
WireConnection;143;0;141;0
WireConnection;143;1;142;0
WireConnection;136;0;135;0
WireConnection;149;0;102;0
WireConnection;21;0;18;0
WireConnection;138;0;137;0
WireConnection;150;0;151;1
WireConnection;102;0;62;0
WireConnection;102;1;126;0
WireConnection;102;2;143;0
WireConnection;159;0;158;0
WireConnection;159;1;156;0
WireConnection;160;0;158;0
WireConnection;160;1;156;0
WireConnection;160;2;157;0
WireConnection;162;1;159;0
WireConnection;163;1;162;0
WireConnection;164;1;161;0
WireConnection;161;1;160;0
WireConnection;169;0;163;0
WireConnection;169;1;166;0
WireConnection;177;0;173;0
WireConnection;175;0;167;2
WireConnection;175;2;169;0
WireConnection;174;0;172;2
WireConnection;174;1;171;0
WireConnection;174;2;168;0
WireConnection;173;0;167;2
WireConnection;173;1;170;0
WireConnection;171;0;163;0
WireConnection;171;1;166;0
WireConnection;170;0;164;0
WireConnection;170;2;165;0
WireConnection;176;0;175;0
WireConnection;168;0;164;0
WireConnection;168;2;165;0
WireConnection;184;0;181;0
WireConnection;184;1;176;0
WireConnection;185;0;180;0
WireConnection;185;1;177;0
WireConnection;187;0;179;0
WireConnection;187;1;178;0
WireConnection;188;0;183;0
WireConnection;188;1;184;0
WireConnection;189;0;182;0
WireConnection;189;1;185;0
WireConnection;190;0;186;0
WireConnection;190;1;187;0
WireConnection;191;0;166;0
WireConnection;191;1;165;0
WireConnection;192;0;191;0
WireConnection;178;0;174;0
WireConnection;0;0;102;0
ASEEND*/
//CHKSM=63DF4F5516E0A1C2CE2F9A39743D175441753BA1