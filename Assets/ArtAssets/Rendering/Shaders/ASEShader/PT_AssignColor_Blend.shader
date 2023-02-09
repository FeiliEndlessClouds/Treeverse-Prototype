// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/VFX/AssignColor_Blend"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[HDR]_TintColor("TintColor", Color) = (1,1,1,1)
		_MainTex("MainTex", 2D) = "white" {}
		[Header(BlackClip)]_BlackClip("BlackClip", Range( 0 , 1)) = 0.5
		[Toggle]_UseAlpha("Use Alpha", Float) = 0
		[Header(AssignColor)]_ColorA("Color A", Color) = (1,1,1,0)
		_ColorB("Color B", Color) = (0.9960854,1,0.5235849,0)
		_ColorC("Color C", Color) = (1,0.6265537,0.08018869,0)
		[Header(GradientBlend)][Toggle]_UseGradient("Use Gradient", Float) = 0
		_GradientBlendIntensity("Gradient Blend Intensity", Range( 0 , 1)) = 1
		_GradientUVOffset("Gradient UV Offset", Range( -1 , 1)) = 0
		[Toggle]_GradientUorV("Gradient UorV", Float) = 0
		[Toggle]_InvertGradient("Invert Gradient", Float) = 0
		[Toggle]_UseOriginColor("Use OriginColor", Float) = 0
		[Header(CustomDate)][Toggle]_UseCustomData("Use CustomData", Float) = 0
		[Toggle]_UseDataY1BlackClipStage("Use DataY1 BlackClip Stage", Float) = 0
		[Toggle]_DataX1MainTexFlowUorV("DataX1 MainTex Flow U or V", Float) = 0
		[Header(Shader Options)][Enum(UnityEngine.Rendering.CullMode)]_CullMode("Cull Mode", Range( 0 , 2)) = 2
		[Enum(Off,0,On,1)]_ZWriteMode("Z Write Mode", Float) = 0
		[ASEEnd][Enum(UnityEngine.Rendering.CompareFunction)]_ZTestMode("Z Test Mode", Float) = 4

		
	}

	SubShader
	{
		LOD 0

		
		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Transparent" "Queue"="Transparent" }
		
		Cull [_CullMode]
		AlphaToMask Off
		
		HLSLINCLUDE
		#pragma target 3.0

		#pragma prefer_hlslcc gles
		#pragma exclude_renderers d3d11_9x 

		ENDHLSL
		
		Pass
		{
			
			Name "Forward"
			
			Tags { "LightMode"="UniversalForward" }
			
			Blend SrcAlpha OneMinusSrcAlpha
			ZWrite [_ZWriteMode]
			ZTest [_ZTestMode]
			Offset 0,0
			ColorMask RGBA
			

			HLSLPROGRAM
			
			#pragma multi_compile_instancing
			#define _RECEIVE_SHADOWS_OFF 1
			#define ASE_SRP_VERSION 999999

			
			#pragma vertex vert
			#pragma fragment frag

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

			#if ASE_SRP_VERSION <= 70108
			#define REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR
			#endif

			#include "Packages/com.unity.shadergraph/ShaderGraphLibrary/Functions.hlsl"
			#define ASE_NEEDS_FRAG_COLOR


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif
				#ifdef ASE_FOG
				float fogFactor : TEXCOORD2;
				#endif
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)

			float4 _TintColor;
			float4 _ColorC;
			float4 _ColorB;
			float4 _ColorA;
			float4 _MainTex_ST;
			float _CullMode;
			half _BlackClip;
			float _UseOriginColor;
			float _UseGradient;
			float _InvertGradient;
			float _GradientUorV;
			float _GradientBlendIntensity;
			float _UseDataY1BlackClipStage;
			float _DataX1MainTexFlowUorV;
			float _UseCustomData;
			float _ZTestMode;
			float _ZWriteMode;
			float _GradientUVOffset;
			float _UseAlpha;
			CBUFFER_END
			sampler2D _MainTex;


			
			float4 SampleGradient( Gradient gradient, float time )
			{
				float3 color = gradient.colors[0].rgb;
				UNITY_UNROLL
				for (int c = 1; c < 8; c++)
				{
				float colorPos = saturate((time - gradient.colors[c-1].w) / ( 0.00001 + (gradient.colors[c].w - gradient.colors[c-1].w)) * step(c, gradient.colorsLength-1));
				color = lerp(color, gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), gradient.type));
				}
				#ifndef UNITY_COLORSPACE_GAMMA
				color = SRGBToLinear(color);
				#endif
				float alpha = gradient.alphas[0].x;
				UNITY_UNROLL
				for (int a = 1; a < 8; a++)
				{
				float alphaPos = saturate((time - gradient.alphas[a-1].y) / ( 0.00001 + (gradient.alphas[a].y - gradient.alphas[a-1].y)) * step(a, gradient.alphasLength-1));
				alpha = lerp(alpha, gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), gradient.type));
				}
				return float4(color, alpha);
			}
			
			
			VertexOutput VertexFunction ( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				o.ase_texcoord3 = v.ase_texcoord;
				o.ase_color = v.ase_color;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float4 positionCS = TransformWorldToHClip( positionWS );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				VertexPositionInputs vertexInput = (VertexPositionInputs)0;
				vertexInput.positionWS = positionWS;
				vertexInput.positionCS = positionCS;
				o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				#ifdef ASE_FOG
				o.fogFactor = ComputeFogFactor( positionCS.z );
				#endif
				#ifdef _CUSTOM_OUTPUT_POSITION
				o.clipPos = v.vertex;
				#else
				o.clipPos = positionCS;
				#endif
				return o;
			}

			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}

			half4 frag ( VertexOutput IN
			#ifdef _MRT_GBUFFER0
			,out half4 gbuffer:SV_Target1
			#endif
			 ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif
				float4 ShadowCoords = float4( 0, 0, 0, 0 );
				#ifdef PUSH_SELFSHADOW_TO_MAIN_LIGHT
				float selfShadowPush = 0.0;
				float3 pushRatio = _MainLightPosition.xyz * selfShadowPush;
				#else
				float3 pushRatio = 0.0;
				#endif

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition + pushRatio);
					#endif
				#endif
				float2 uv_MainTex = IN.ase_texcoord3.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float lerpResult282 = lerp( 0.0 , IN.ase_texcoord3.z , _UseCustomData);
				float2 appendResult218 = (float2(lerpResult282 , 0.0));
				float2 appendResult219 = (float2(0.0 , lerpResult282));
				float2 lerpResult284 = lerp( appendResult218 , appendResult219 , _DataX1MainTexFlowUorV);
				float4 tex2DNode10 = tex2D( _MainTex, ( uv_MainTex + lerpResult284 ) );
				float3 temp_output_27_0_g40 = tex2DNode10.rgb;
				float temp_output_16_0_g41 = temp_output_27_0_g40.x;
				Gradient gradient2_g41 = NewGradient( 0, 4, 2, float4( 1, 1, 1, 0 ), float4( 0.7991835, 0.7991835, 0.7991835, 0.1176471 ), float4( 0.07750964, 0.07750964, 0.07750964, 0.8382391 ), float4( 0, 0, 0, 0.997055 ), 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
				float2 temp_cast_2 = (_GradientUVOffset).xx;
				float2 texCoord3_g41 = IN.ase_texcoord3.xy * float2( 1,1 ) + temp_cast_2;
				float lerpResult17_g41 = lerp( texCoord3_g41.x , texCoord3_g41.y , _GradientUorV);
				float lerpResult19_g41 = lerp( SampleGradient( gradient2_g41, lerpResult17_g41 ).r , ( 1.0 - SampleGradient( gradient2_g41, lerpResult17_g41 ).r ) , _InvertGradient);
				float clampResult9_g41 = clamp( ( ( -1.0 * _GradientBlendIntensity * lerpResult19_g41 ) + temp_output_16_0_g41 ) , 0.0 , 1.0 );
				float lerpResult21_g41 = lerp( temp_output_16_0_g41 , clampResult9_g41 , _UseGradient);
				float ColorAAlpha5_g40 = _ColorA.a;
				float temp_output_17_0_g40 = ( lerpResult21_g41 + ( -0.35 + ( ColorAAlpha5_g40 * 0.3 ) ) );
				float4 lerpResult21_g40 = lerp( _ColorB , _ColorA , temp_output_17_0_g40);
				float ColorBAlpha6_g40 = _ColorB.a;
				float ColorCAlpha9_g40 = _ColorC.a;
				float4 lerpResult18_g40 = lerp( _ColorC , lerpResult21_g40 , ( temp_output_17_0_g40 + ( 0.45 + ( ColorBAlpha6_g40 * 0.3 ) + ( ColorCAlpha9_g40 * -0.3 ) ) ));
				float3 InputRGB30_g40 = temp_output_27_0_g40;
				float4 lerpResult36_g40 = lerp( lerpResult18_g40 , float4( InputRGB30_g40 , 0.0 ) , _UseOriginColor);
				
				float4 temp_output_8_0_g42 = tex2DNode10;
				float temp_output_10_0_g42 = (temp_output_8_0_g42).w;
				float3 desaturateInitialColor1_g42 = ( (temp_output_8_0_g42).xyz * temp_output_10_0_g42 );
				float desaturateDot1_g42 = dot( desaturateInitialColor1_g42, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar1_g42 = lerp( desaturateInitialColor1_g42, desaturateDot1_g42.xxx, 0.0 );
				float lerpResult280 = lerp( 0.0 , IN.ase_texcoord3.w , _UseCustomData);
				float DataY1223 = lerpResult280;
				float lerpResult286 = lerp( 0.0 , DataY1223 , _UseDataY1BlackClipStage);
				float lerpResult19_g42 = lerp( saturate( (0.0 + ((desaturateVar1_g42).x - 0.0) * (1.0 - 0.0) / (saturate( ( saturate( ( _BlackClip + lerpResult286 ) ) + 0.05 ) ) - 0.0)) ) , temp_output_10_0_g42 , _UseAlpha);
				
#ifdef DISCARD_FRAGMENT
				float DiscardValue = 1.0;
				float DiscardThreshold = 0;

				if(DiscardValue < DiscardThreshold)discard;
#endif
				float3 BakedAlbedo = 0;
				float3 BakedEmission = 0;
				float3 Color = ( lerpResult36_g40 * IN.ase_color * _TintColor ).rgb;
				float Alpha = ( IN.ase_color.a * lerpResult19_g42 * _TintColor.a );
				float AlphaClipThreshold = 0.5;
				float AlphaClipThresholdShadow = 0.5;

				#ifdef _ALPHATEST_ON
					clip( Alpha - AlphaClipThreshold );
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				#ifdef ASE_FOG
					Color = MixFog( Color, IN.fogFactor );
				#endif
				#ifdef _MRT_GBUFFER0
				gbuffer = float4(0.0, 0.0, 0.0, 0.0);
				#endif
				return half4( Color, Alpha );
			}

			ENDHLSL
		}

	
	}
	CustomEditorForRenderPipeline "CustomDrawersShaderEditor" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
	
	Fallback "Hidden/InternalErrorShader"
	
}
/*ASEBEGIN
Version=18935
343;319;2189;926;3251.722;1898.96;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;229;-1968.022,-966.9504;Inherit;False;1828.379;531.4844;;8;283;212;213;219;218;266;284;285;CtrlUVoffset;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;266;-1684.154,-824.6428;Inherit;False;649.0463;298.9839;Avoid Customedata 0 or 1;5;223;281;264;280;282;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;264;-1630.882,-784.1874;Half;False;Constant;_Zero;Zero;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;281;-1658.714,-618.1495;Inherit;False;Property;_UseCustomData;Use CustomData;16;2;[Header];[Toggle];Create;True;1;CustomDate;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;283;-1924.805,-813.8911;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;282;-1419.167,-777.6349;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;285;-914.2931,-568.3547;Inherit;False;Property;_DataX1MainTexFlowUorV;DataX1 MainTex Flow U or V;18;1;[Toggle];Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;218;-801.5679,-775.2845;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;219;-799.5679,-674.2849;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;280;-1413.894,-660.5201;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;230;-521.8633,-281.6145;Inherit;False;607.4227;298.8525;Comment;3;224;287;286;CrtlFloat;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;284;-594.0142,-755.5999;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;212;-547.5377,-916.9504;Inherit;False;0;10;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;223;-1239.686,-666.7354;Inherit;False;DataY1;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;287;-456.8409,-103.8457;Inherit;False;Property;_UseDataY1BlackClipStage;Use DataY1 BlackClip Stage;17;1;[Toggle];Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;213;-291.6423,-911.6833;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;224;-375.5952,-178.5687;Inherit;False;223;DataY1;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;10;-80.66913,-742.576;Inherit;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;0;False;0;False;-1;1a00ca6e281456e4ebe187d579d56d48;0ade146f21e68f84695f3fec91fdecb9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;286;-136.1902,-195.9194;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;297;-2409.879,-1464.031;Inherit;False;351.5083;335.5892;Comment;3;300;299;298;Shader Options;0.3799582,0,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;289;330.7494,-737.8452;Inherit;True;VFX_GraytoColor;5;;40;4dca6182a64a98847bdebf99782433f1;0;1;27;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;21;746.0893,-617.9832;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;276;701.7852,-1106.027;Inherit;False;Property;_TintColor;TintColor;0;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;4,4,4,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;288;298.6286,-229.925;Inherit;False;VFX_ClipBlack;2;;42;bca2b1ae1e5a4c544b8f204bdd345f7b;0;2;8;FLOAT4;0,0,0,0;False;18;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;1014.077,-742.3867;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;299;-2357.66,-1244.442;Inherit;False;Property;_ZTestMode;Z Test Mode;21;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;298;-2358.371,-1414.031;Inherit;False;Property;_CullMode;Cull Mode;19;2;[Header];[Enum];Create;True;1;Shader Options;2;CullBack;2;CullOff;0;1;UnityEngine.Rendering.CullMode;True;0;False;2;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;1032.489,-338.7217;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;300;-2359.879,-1330.98;Inherit;False;Property;_ZWriteMode;Z Write Mode;20;1;[Enum];Create;True;0;2;Off;0;On;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;301;1283.994,-743.3667;Float;False;False;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;1;New Amplify Shader;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;FullScreenPass;0;1;FullScreenPass;4;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;7;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=UniversalForwardOnly;True;2;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;290;1283.994,-743.3667;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;AdditionalPass;0;0;AdditionalPass;6;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;0;False;False;0;Hidden/InternalErrorShader;0;0;Standard;1;MRT Output;0;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;291;1283.994,-743.3667;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;ExtraPrePass;0;2;ExtraPrePass;6;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;0;False;False;0;Hidden/InternalErrorShader;0;0;Standard;1;MRT Output;0;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;295;1283.994,-743.3667;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;SceneSelectionPass;0;6;SceneSelectionPass;5;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=SceneSelectionPass;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;294;1283.994,-743.3667;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;DepthOnly;0;5;DepthOnly;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;False;False;True;False;False;False;False;0;False;-1;False;False;False;False;False;False;False;False;False;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;293;1283.994,-743.3667;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;ShadowCaster;0;4;ShadowCaster;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;296;1283.994,-743.3667;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;Meta;0;7;Meta;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;292;1282.994,-743.3667;Float;False;True;-1;2;;0;21;ASE/VFX/AssignColor_Blend;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;Forward;0;3;Forward;12;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;0;True;298;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;True;True;1;5;False;-1;10;False;-1;0;1;False;-1;10;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;True;2;True;300;True;3;True;299;True;False;0;False;-1;0;False;-1;True;1;LightMode=UniversalForward;False;False;0;Hidden/InternalErrorShader;0;0;Standard;18;Surface;1;637938927490883847;  Blend;0;0;Two Sided;1;0;Cast Shadows;0;637938927506356512;  Use Shadow Threshold;0;0;Receive Shadows;0;637938927519127853;GPU Instancing;1;0;LOD CrossFade;0;0;Built-in Fog;0;0;DOTS Instancing;0;0;Meta Pass;0;0;Extra Pre Pass;0;0;Full Screen Pass;0;0;Additional Pass;0;0;Scene Selectioin Pass;0;0;Vertex Position,InvertActionOnDeselection;1;0;Discard Fragment;0;0;Push SelfShadow to Main Light;0;0;2;MRT Output;0;0;Custom Output Position;0;0;8;False;False;False;True;False;False;False;False;False;;False;0
WireConnection;282;0;264;0
WireConnection;282;1;283;3
WireConnection;282;2;281;0
WireConnection;218;0;282;0
WireConnection;219;1;282;0
WireConnection;280;0;264;0
WireConnection;280;1;283;4
WireConnection;280;2;281;0
WireConnection;284;0;218;0
WireConnection;284;1;219;0
WireConnection;284;2;285;0
WireConnection;223;0;280;0
WireConnection;213;0;212;0
WireConnection;213;1;284;0
WireConnection;10;1;213;0
WireConnection;286;1;224;0
WireConnection;286;2;287;0
WireConnection;289;27;10;0
WireConnection;288;8;10;0
WireConnection;288;18;286;0
WireConnection;22;0;289;0
WireConnection;22;1;21;0
WireConnection;22;2;276;0
WireConnection;23;0;21;4
WireConnection;23;1;288;0
WireConnection;23;2;276;4
WireConnection;292;2;22;0
WireConnection;292;3;23;0
ASEEND*/
//CHKSM=977FA61F6316E1BD10C484631DF136B7B8747EB8