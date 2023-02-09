// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/VFX/AssignColorClipTwist_Blend"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[ASEBegin][HDR]_TintColor("TintColor", Color) = (1,1,1,1)
		[Header(MainTex)]_MainTex("MainTex", 2D) = "white" {}
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
		[Header(Clip)]_ClipTex("ClipTex", 2D) = "white" {}
		[Toggle]_InvertClipTex("Invert ClipTex", Float) = 0
		[Toggle]_ClipNullAlpha("Clip Null Alpha", Float) = 0
		_ClipStage("ClipStage", Range( 0 , 1)) = 0
		[HDR]_EdgeColor("EdgeColor", Color) = (1,1,1,1)
		_EdgeWidth("EdgeWidth", Range( 0 , 1)) = 0.1
		_EdgeSmooth("EdgeSmooth", Range( 0 , 2)) = 0.1
		[Toggle]_ClipFlowFollowMainTex("ClipFlow Follow MainTex", Float) = 0
		[Toggle]_ClipEdgeBlendMainTex("ClipEdge Blend MainTex", Float) = 0
		[Toggle(_CLIPTEXUSEPOLARUV_ON)] _ClipTexUsePolarUV("ClipTex Use Polar UV", Float) = 0
		[Toggle]_MaskBlendClipTex("Mask Blend ClipTex", Range( 0 , 1)) = 0
		[Toggle]_TwistClipTex("TwistClipTex", Float) = 0
		[Header(Twist)]_TwistTex("TwistTex", 2D) = "bump" {}
		[Toggle(_USEPATRICLECENTERUV_ON)] _UsePatricleCenterUV("Use Patricle Center UV", Float) = 0
		[Toggle(_TWISTTEXUSEPOLARUV_ON)] _TwistTexUsePolarUV("TwistTex Use Polar UV", Float) = 0
		_TwistStage("TwistStage", Range( -2 , 2)) = 0.1
		[Header(TwistMask)][Toggle]_UseTwistMask("Use TwistMask", Float) = 0
		_TwistMaskTex("TwistMaskTex", 2D) = "white" {}
		[Toggle]_InvertTwistMskTex("InvertTwistMskTex", Float) = 0
		[Header(Use NormalSelfTwist)][Toggle(_USENORMALSELFTWIST_ON)] _UseNormalSelfTwist("Use NormalSelfTwist", Float) = 0
		_SelfTwistUV("SelfTwist UV", Vector) = (1,1,0,0)
		_NormalSelfTwisStage("NormalSelfTwis Stage ", Range( 0 , 2)) = 1
		[Header(Flow Speed)]_FlowSpeedClipTwist("FlowSpeed Clip Twist ", Vector) = (0,0,0,0)
		_FlowSpeedMainTwistMask("FlowSpeed Main TwistMask", Vector) = (0,0,0,0)
		[Header(Mask)]_MaskTex("MaskTex", 2D) = "white" {}
		[Toggle]_InvertMask("Invert Mask", Float) = 0
		[Toggle]_MaskNullAlpha("Mask Null Alpha", Float) = 0
		_MaskBlendStage("Mask Blend Stage", Range( -1 , 1)) = 0
		[Header(VertexOffset)][Toggle(_USEVERTEXOFFSET_ON)] _UseVertexOffset("Use Vertex Offset", Float) = 0
		_VertexOffsetScale("VertexOffset Scale", Range( 0 , 4)) = 1
		[Toggle]_VertexOffsetUsePositionUV("VertexOffset Use Position UV", Float) = 0
		[Toggle]_VertexOffsetPushorPull("VertexOffset Push or Pull", Range( 0 , 1)) = 0
		[Toggle]_VertexOffsetUseMaskTex("VertexOffset Use MaskTex", Float) = 0
		_VertexOffset("Vertex Offset", Range( -1 , 1)) = 0
		[Toggle(_USETRIPLANARSAMPLER_ON)] _UseTriplanarSampler("Use Triplanar Sampler", Float) = 0
		_TriUVWorldPosition("TriUV World Position", Range( 0 , 1)) = 1
		_VertexOffsetTex("VertexOffsetTex", 2D) = "white" {}
		[Header(CustomDate)][Toggle]_UseCustomData("Use CustomData", Range( 0 , 1)) = 0
		[Toggle]_DataX1("DataX1 MainTex Flow U or V", Float) = 0
		[Toggle]_DataX2("DataX2 ClipTex Flow U or V", Float) = 0
		[Toggle]_DataY2("DataY2 TwistTex Flow U or V", Float) = 0
		[Header(Shader Options)][Enum(UnityEngine.Rendering.CullMode)]_CullMode("Cull Mode", Range( 0 , 2)) = 2
		[Enum(Off,0,On,1)]_ZWriteMode("Z Write Mode", Float) = 0
		[ASEEnd][Enum(UnityEngine.Rendering.CompareFunction)]_ZTestMode("Z Test Mode", Float) = 4
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

		
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
			
			Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
			ZWrite [_ZWriteMode]
			ZTest [_ZTestMode]
			Offset 0,0
			ColorMask RGBA
			

			HLSLPROGRAM
			
			#pragma multi_compile_instancing
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
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_POSITION
			#define ASE_NEEDS_FRAG_COLOR
			#pragma shader_feature_local _USEVERTEXOFFSET_ON
			#pragma shader_feature_local _USETRIPLANARSAMPLER_ON
			#pragma shader_feature_local _USENORMALSELFTWIST_ON
			#pragma shader_feature_local _USEPATRICLECENTERUV_ON
			#pragma shader_feature_local _TWISTTEXUSEPOLARUV_ON
			#pragma shader_feature_local _CLIPTEXUSEPOLARUV_ON


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
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
				
				float fogFactor : TEXCOORD2;
				
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				float4 ase_texcoord6 : TEXCOORD6;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)

			float4 _ColorC;
			float4 _TwistMaskTex_ST;
			float4 _SelfTwistUV;
			float4 _EdgeColor;
			float4 _FlowSpeedClipTwist;
			float4 _TwistTex_ST;
			float4 _MainTex_ST;
			float4 _ColorA;
			float4 _ColorB;
			float4 _MaskTex_ST;
			float4 _ClipTex_ST;
			float4 _TintColor;
			float4 _FlowSpeedMainTwistMask;
			float4 _VertexOffsetTex_ST;
			float _ClipFlowFollowMainTex;
			float _DataX2;
			float _MaskBlendStage;
			float _UseAlpha;
			float _MaskBlendClipTex;
			float _InvertClipTex;
			half _BlackClip;
			float _GradientUVOffset;
			float _UseOriginColor;
			float _UseGradient;
			float _InvertGradient;
			float _TwistClipTex;
			float _ClipEdgeBlendMainTex;
			float _GradientBlendIntensity;
			float _GradientUorV;
			float _CullMode;
			float _InvertTwistMskTex;
			float _EdgeWidth;
			float _ZWriteMode;
			float _ZTestMode;
			float _VertexOffsetPushorPull;
			float _VertexOffsetScale;
			float _VertexOffset;
			float _VertexOffsetUsePositionUV;
			float _TriUVWorldPosition;
			float _InvertMask;
			float _VertexOffsetUseMaskTex;
			float _UseCustomData;
			float _DataY2;
			float _NormalSelfTwisStage;
			float _TwistStage;
			float _ClipNullAlpha;
			float _UseTwistMask;
			float _DataX1;
			float _ClipStage;
			float _EdgeSmooth;
			float _MaskNullAlpha;
			CBUFFER_END
			sampler2D _VertexOffsetTex;
			sampler2D _MaskTex;
			sampler2D _MainTex;
			sampler2D _TwistTex;
			sampler2D _TwistMaskTex;
			sampler2D _ClipTex;


			inline float4 TriplanarSampling45_g417( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
			{
				float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
				projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
				float3 nsign = sign( worldNormal );
				half4 xNorm; half4 yNorm; half4 zNorm;
				xNorm = tex2Dlod( topTexMap, float4(tiling * worldPos.zy * float2(  nsign.x, 1.0 ), 0, 0) );
				yNorm = tex2Dlod( topTexMap, float4(tiling * worldPos.xz * float2(  nsign.y, 1.0 ), 0, 0) );
				zNorm = tex2Dlod( topTexMap, float4(tiling * worldPos.xy * float2( -nsign.z, 1.0 ), 0, 0) );
				return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
			}
			
			
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

				float lerpResult29_g417 = lerp( 1.0 , -1.0 , _VertexOffsetPushorPull);
				float2 uv_VertexOffsetTex = v.ase_texcoord.xy * _VertexOffsetTex_ST.xy + _VertexOffsetTex_ST.zw;
				float Time437 = _TimeParameters.x;
				float FlowSpeed_Forth_U457 = ( Time437 * _FlowSpeedMainTwistMask.z );
				float FlowSpeed_Forth_V458 = ( Time437 * _FlowSpeedMainTwistMask.w );
				float2 appendResult596 = (float2(FlowSpeed_Forth_U457 , FlowSpeed_Forth_V458));
				float2 temp_output_36_0_g417 = appendResult596;
				float3 ase_worldPos = mul(GetObjectToWorldMatrix(), v.vertex).xyz;
				float3 objToWorld50_g418 = mul( GetObjectToWorldMatrix(), float4( float3( 0,0,0 ), 1 ) ).xyz;
				float2 appendResult55_g418 = (float2(( ( ase_worldPos.x - v.ase_texcoord3.x ) - objToWorld50_g418.x ) , ( ( ase_worldPos.y - v.ase_texcoord3.y ) - objToWorld50_g418.y )));
				float2 lerpResult17_g417 = lerp( ( uv_VertexOffsetTex + temp_output_36_0_g417 ) , ( temp_output_36_0_g417 + (appendResult55_g418*_VertexOffsetTex_ST.xy + _VertexOffsetTex_ST.zw) ) , _VertexOffsetUsePositionUV);
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				float3 temp_cast_1 = (_TriUVWorldPosition).xxx;
				float4 triplanar45_g417 = TriplanarSampling45_g417( _VertexOffsetTex, temp_cast_1, ase_worldNormal, _VertexOffsetTex_ST.zw.x, _VertexOffsetTex_ST.xy, 1.0, 0 );
				#ifdef _USETRIPLANARSAMPLER_ON
				float staticSwitch50_g417 = triplanar45_g417.x;
				#else
				float staticSwitch50_g417 = tex2Dlod( _VertexOffsetTex, float4( lerpResult17_g417, 0, 0.0) ).r;
				#endif
				float3 temp_cast_2 = (( _VertexOffset + staticSwitch50_g417 )).xxx;
				float2 uv_MaskTex = v.ase_texcoord.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
				float4 tex2DNode3_g408 = tex2Dlod( _MaskTex, float4( uv_MaskTex, 0, 0.0) );
				float lerpResult9_g408 = lerp( tex2DNode3_g408.r , ( 1.0 - tex2DNode3_g408.r ) , _InvertMask);
				float MaskAlpha355 = lerpResult9_g408;
				float3 temp_cast_3 = (MaskAlpha355).xxx;
				float3 lerpResult30_g417 = lerp( temp_cast_2 , ( staticSwitch50_g417 * temp_cast_3 ) , _VertexOffsetUseMaskTex);
				float UseCustomData633 = _UseCustomData;
				float lerpResult645 = lerp( 0.0 , v.ase_texcoord1.w , UseCustomData633);
				float DataW1239 = lerpResult645;
				#ifdef _USEVERTEXOFFSET_ON
				float3 staticSwitch34_g417 = ( v.ase_normal * lerpResult29_g417 * _VertexOffsetScale * lerpResult30_g417 * DataW1239 );
				#else
				float3 staticSwitch34_g417 = float3( 0,0,0 );
				#endif
				
				o.ase_texcoord3.xy = v.ase_texcoord.xy;
				o.ase_texcoord3.zw = v.ase_texcoord2.xy;
				o.ase_texcoord4 = v.vertex;
				o.ase_texcoord5.xyz = v.ase_texcoord3.xyz;
				o.ase_texcoord6 = v.ase_texcoord1;
				o.ase_color = v.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord5.w = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = staticSwitch34_g417;
				#ifndef VERTEX_OPERATION_HIDE_PASS_ONLY
					#ifdef ASE_ABSOLUTE_VERTEX_POS
						v.vertex.xyz = vertexValue;
					#else
						v.vertex.xyz += vertexValue;
					#endif
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
				
				#ifdef TREEVERSE_LINEAR_FOG
					float fz = UNITY_Z_0_FAR_FROM_CLIPSPACE(positionCS.z);
					real fogFactor =  saturate( fz * unity_FogParams.z + unity_FogParams.w);
					fogFactor = lerp(1.0, fogFactor, unity_FogColor.a * step(0.001, -1.0 / unity_FogParams.z));
				#else
					half fogFactor = 0.0;
				#endif
				
				o.fogFactor = fogFactor;

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
				float2 uv_TwistTex = IN.ase_texcoord3.xy * _TwistTex_ST.xy + _TwistTex_ST.zw;
				float Time437 = _TimeParameters.x;
				float FlowSpeed_Twist_U453 = ( Time437 * _FlowSpeedClipTwist.z );
				float FlowSpeed_Twist_V454 = ( Time437 * _FlowSpeedClipTwist.w );
				float2 appendResult481 = (float2(FlowSpeed_Twist_U453 , FlowSpeed_Twist_V454));
				float UseCustomData633 = _UseCustomData;
				float lerpResult634 = lerp( 0.0 , IN.ase_texcoord3.zw.y , UseCustomData633);
				float2 appendResult508 = (float2(lerpResult634 , 0.0));
				float2 appendResult507 = (float2(0.0 , lerpResult634));
				float2 lerpResult680 = lerp( appendResult508 , appendResult507 , _DataY2);
				float2 DataY2TwistFlow511 = lerpResult680;
				float2 temp_output_512_0 = ( appendResult481 + DataY2TwistFlow511 );
				float2 CenteredUV49_g275 = ( IN.ase_texcoord3.xy - ( _TwistTex_ST.zw + float2( 0.5,0.5 ) ) );
				float2 break563 = _TwistTex_ST.xy;
				float2 break33_g275 = CenteredUV49_g275;
				float2 appendResult44_g275 = (float2(( length( CenteredUV49_g275 ) * break563.y * 2.0 ) , ( atan2( break33_g275.y , break33_g275.x ) * ( 1.0 / TWO_PI ) * break563.x )));
				float2 appendResult68_g275 = (float2(temp_output_512_0));
				#ifdef _TWISTTEXUSEPOLARUV_ON
				float2 staticSwitch555 = ( appendResult44_g275 + appendResult68_g275 );
				#else
				float2 staticSwitch555 = ( uv_TwistTex + temp_output_512_0 );
				#endif
				float2 appendResult1_g396 = (float2(IN.ase_texcoord4.xyz.x , IN.ase_texcoord4.xyz.y));
				float2 appendResult2_g396 = (float2(IN.ase_texcoord5.xyz.x , IN.ase_texcoord5.xyz.y));
				#ifdef _USEPATRICLECENTERUV_ON
				float2 staticSwitch719 = ( temp_output_512_0 + (( appendResult1_g396 - appendResult2_g396 )*_TwistTex_ST.xy + _TwistTex_ST.zw) );
				#else
				float2 staticSwitch719 = staticSwitch555;
				#endif
				float3 tex2DNode539 = UnpackNormalScale( tex2D( _TwistTex, staticSwitch719 ), 1.0f );
				float2 appendResult769 = (float2(_SelfTwistUV.x , _SelfTwistUV.y));
				float2 appendResult771 = (float2(_SelfTwistUV.z , _SelfTwistUV.w));
				float2 texCoord760 = IN.ase_texcoord3.xy * appendResult769 + ( appendResult771 + temp_output_512_0 );
				float3 unpack758 = UnpackNormalScale( tex2D( _TwistTex, texCoord760 ), _NormalSelfTwisStage );
				unpack758.z = lerp( 1, unpack758.z, saturate(_NormalSelfTwisStage) );
				#ifdef _USENORMALSELFTWIST_ON
				float3 staticSwitch762 = BlendNormal( unpack758 , tex2DNode539 );
				#else
				float3 staticSwitch762 = tex2DNode539;
				#endif
				float lerpResult643 = lerp( 0.0 , IN.ase_texcoord6.z , UseCustomData633);
				float DataZ1238 = lerpResult643;
				float2 uv_TwistMaskTex = IN.ase_texcoord3.xy * _TwistMaskTex_ST.xy + _TwistMaskTex_ST.zw;
				float FlowSpeed_Forth_U457 = ( Time437 * _FlowSpeedMainTwistMask.z );
				float FlowSpeed_Forth_V458 = ( Time437 * _FlowSpeedMainTwistMask.w );
				float2 appendResult483 = (float2(FlowSpeed_Forth_U457 , FlowSpeed_Forth_V458));
				float4 tex2DNode52_g407 = tex2D( _TwistMaskTex, ( uv_TwistMaskTex + appendResult483 ) );
				float lerpResult61_g407 = lerp( tex2DNode52_g407.r , ( 1.0 - tex2DNode52_g407.r ) , _InvertTwistMskTex);
				float lerpResult62_g407 = lerp( 1.0 , lerpResult61_g407 , _UseTwistMask);
				float2 TwistOutputedUV323 = ( (staticSwitch762).xy * ( _TwistStage + DataZ1238 ) * lerpResult62_g407 );
				float lerpResult639 = lerp( 0.0 , IN.ase_texcoord6.x , UseCustomData633);
				float2 appendResult218 = (float2(lerpResult639 , 0.0));
				float2 appendResult219 = (float2(0.0 , lerpResult639));
				float2 lerpResult686 = lerp( appendResult218 , appendResult219 , _DataX1);
				float FlowSpeed_Main_U455 = ( Time437 * _FlowSpeedMainTwistMask.x );
				float FlowSpeed_Main_V456 = ( Time437 * _FlowSpeedMainTwistMask.y );
				float2 appendResult471 = (float2(FlowSpeed_Main_U455 , FlowSpeed_Main_V456));
				float4 tex2DNode10 = tex2D( _MainTex, ( uv_MainTex + TwistOutputedUV323 + lerpResult686 + appendResult471 ) );
				float lerpResult641 = lerp( 0.0 , IN.ase_texcoord6.y , UseCustomData633);
				float DataY1223 = lerpResult641;
				float EdgeWidth95_g410 = _EdgeWidth;
				float EdgeSmooth57_g410 = _EdgeSmooth;
				float temp_output_72_0_g410 = (( ( EdgeWidth95_g410 * -1.1 ) + -0.2 + ( EdgeSmooth57_g410 * -1.0 ) ) + (saturate( ( _ClipStage + DataY1223 ) ) - 0.0) * (1.1 - ( ( EdgeWidth95_g410 * -1.1 ) + -0.2 + ( EdgeSmooth57_g410 * -1.0 ) )) / (1.0 - 0.0));
				float clampResult102_g410 = clamp( ( temp_output_72_0_g410 + EdgeWidth95_g410 ) , -3.0 , 2.0 );
				float EgdeSmoothFixValue100_g410 = ( EdgeSmooth57_g410 * -0.2 );
				float2 uv_ClipTex = IN.ase_texcoord3.xy * _ClipTex_ST.xy + _ClipTex_ST.zw;
				float2 lerpResult673 = lerp( float2( 0,0 ) , TwistOutputedUV323 , _TwistClipTex);
				float2 MainTexUVFlowByData375 = lerpResult686;
				float2 lerpResult684 = lerp( float2( 0,0 ) , MainTexUVFlowByData375 , _ClipFlowFollowMainTex);
				float lerpResult631 = lerp( 0.0 , IN.ase_texcoord3.zw.x , UseCustomData633);
				float2 appendResult502 = (float2(lerpResult631 , 0.0));
				float2 appendResult503 = (float2(0.0 , lerpResult631));
				float2 lerpResult678 = lerp( appendResult502 , appendResult503 , _DataX2);
				float2 DataX2ClipFlow510 = lerpResult678;
				float FlowSpeed_Clip_U451 = ( Time437 * _FlowSpeedClipTwist.x );
				float FlowSpeed_Clip_V452 = ( Time437 * _FlowSpeedClipTwist.y );
				float2 appendResult525 = (float2(FlowSpeed_Clip_U451 , FlowSpeed_Clip_V452));
				float2 temp_output_378_0 = ( lerpResult673 + lerpResult684 + DataX2ClipFlow510 + appendResult525 );
				float2 CenteredUV49_g409 = ( IN.ase_texcoord3.xy - ( _ClipTex_ST.zw + float2( 0.5,0.5 ) ) );
				float2 break584 = _ClipTex_ST.xy;
				float2 break33_g409 = CenteredUV49_g409;
				float2 appendResult44_g409 = (float2(( length( CenteredUV49_g409 ) * break584.y * 2.0 ) , ( atan2( break33_g409.y , break33_g409.x ) * ( 1.0 / TWO_PI ) * break584.x )));
				float2 appendResult68_g409 = (float2(temp_output_378_0));
				#ifdef _CLIPTEXUSEPOLARUV_ON
				float2 staticSwitch692 = ( appendResult44_g409 + appendResult68_g409 );
				#else
				float2 staticSwitch692 = ( uv_ClipTex + temp_output_378_0 );
				#endif
				float2 uv_MaskTex = IN.ase_texcoord3.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
				float4 tex2DNode3_g408 = tex2D( _MaskTex, uv_MaskTex );
				float lerpResult9_g408 = lerp( tex2DNode3_g408.r , ( 1.0 - tex2DNode3_g408.r ) , _InvertMask);
				float MaskAlpha355 = lerpResult9_g408;
				float lerpResult654 = lerp( 1.0 , saturate( ( MaskAlpha355 + _MaskBlendStage ) ) , _MaskBlendClipTex);
				float temp_output_122_0_g410 = saturate( ( tex2D( _ClipTex, staticSwitch692 ).r * lerpResult654 ) );
				float lerpResult128_g410 = lerp( temp_output_122_0_g410 , ( 1.0 - temp_output_122_0_g410 ) , _InvertClipTex);
				float ClipTex89_g410 = lerpResult128_g410;
				float smoothstepResult47_g410 = smoothstep( ( clampResult102_g410 + EgdeSmoothFixValue100_g410 ) , ( clampResult102_g410 + EdgeSmooth57_g410 + EgdeSmoothFixValue100_g410 ) , ClipTex89_g410);
				float ClipEdgeAlpha293 = ( ( 1.0 - smoothstepResult47_g410 ) * _EdgeColor.a );
				float4 ClipEdgeColor294 = _EdgeColor;
				float ClipEdgeBlendMainTex663 = _ClipEdgeBlendMainTex;
				float4 lerpResult660 = lerp( tex2DNode10 , ( tex2DNode10 + ( ClipEdgeAlpha293 * ClipEdgeColor294 * tex2DNode10.r * tex2DNode10.a ) ) , ClipEdgeBlendMainTex663);
				float3 temp_output_27_0_g411 = lerpResult660.rgb;
				float temp_output_16_0_g412 = temp_output_27_0_g411.x;
				Gradient gradient2_g412 = NewGradient( 0, 4, 2, float4( 1, 1, 1, 0 ), float4( 0.7991835, 0.7991835, 0.7991835, 0.1176471 ), float4( 0.07750964, 0.07750964, 0.07750964, 0.8382391 ), float4( 0, 0, 0, 0.997055 ), 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
				float2 temp_cast_2 = (_GradientUVOffset).xx;
				float2 texCoord3_g412 = IN.ase_texcoord3.xy * float2( 1,1 ) + temp_cast_2;
				float lerpResult17_g412 = lerp( texCoord3_g412.x , texCoord3_g412.y , _GradientUorV);
				float lerpResult19_g412 = lerp( SampleGradient( gradient2_g412, lerpResult17_g412 ).r , ( 1.0 - SampleGradient( gradient2_g412, lerpResult17_g412 ).r ) , _InvertGradient);
				float clampResult9_g412 = clamp( ( ( -1.0 * _GradientBlendIntensity * lerpResult19_g412 ) + temp_output_16_0_g412 ) , 0.0 , 1.0 );
				float lerpResult21_g412 = lerp( temp_output_16_0_g412 , clampResult9_g412 , _UseGradient);
				float ColorAAlpha5_g411 = _ColorA.a;
				float temp_output_17_0_g411 = ( lerpResult21_g412 + ( -0.35 + ( ColorAAlpha5_g411 * 0.3 ) ) );
				float4 lerpResult21_g411 = lerp( _ColorB , _ColorA , temp_output_17_0_g411);
				float ColorBAlpha6_g411 = _ColorB.a;
				float ColorCAlpha9_g411 = _ColorC.a;
				float4 lerpResult18_g411 = lerp( _ColorC , lerpResult21_g411 , ( temp_output_17_0_g411 + ( 0.45 + ( ColorBAlpha6_g411 * 0.3 ) + ( ColorCAlpha9_g411 * -0.3 ) ) ));
				float3 InputRGB30_g411 = temp_output_27_0_g411;
				float4 lerpResult36_g411 = lerp( lerpResult18_g411 , float4( InputRGB30_g411 , 0.0 ) , _UseOriginColor);
				float4 temp_output_601_0 = lerpResult36_g411;
				float3 lerpResult129_g415 = lerp( temp_output_601_0.rgb , ClipEdgeColor294.rgb , ClipEdgeAlpha293);
				float4 lerpResult665 = lerp( float4( lerpResult129_g415 , 0.0 ) , temp_output_601_0 , ClipEdgeBlendMainTex663);
				
				float4 temp_output_8_0_g416 = lerpResult660;
				float temp_output_10_0_g416 = (temp_output_8_0_g416).w;
				float3 desaturateInitialColor1_g416 = ( (temp_output_8_0_g416).xyz * temp_output_10_0_g416 );
				float desaturateDot1_g416 = dot( desaturateInitialColor1_g416, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar1_g416 = lerp( desaturateInitialColor1_g416, desaturateDot1_g416.xxx, 0.0 );
				float lerpResult19_g416 = lerp( saturate( (0.0 + ((desaturateVar1_g416).x - 0.0) * (1.0 - 0.0) / (saturate( ( saturate( ( _BlackClip + 0.0 ) ) + 0.05 ) ) - 0.0)) ) , temp_output_10_0_g416 , _UseAlpha);
				float ClipBlackAlpha491 = lerpResult19_g416;
				float smoothstepResult40_g410 = smoothstep( temp_output_72_0_g410 , ( temp_output_72_0_g410 + EdgeSmooth57_g410 ) , ClipTex89_g410);
				float lerpResult132_g410 = lerp( smoothstepResult40_g410 , 1.0 , _ClipNullAlpha);
				float ClipAlpha292 = lerpResult132_g410;
				float lerpResult609 = lerp( MaskAlpha355 , (float)1 , _MaskNullAlpha);
				float VertexAlpha350 = IN.ase_color.a;
				
#ifdef DISCARD_FRAGMENT
				float DiscardValue = 1.0;
				float DiscardThreshold = 0;

				if(DiscardValue < DiscardThreshold)discard;
#endif
				float3 BakedAlbedo = 0;
				float3 BakedEmission = 0;
				float3 Color = ( lerpResult665 * IN.ase_color * _TintColor ).rgb;
				float Alpha = ( ClipBlackAlpha491 * ClipAlpha292 * lerpResult609 * _TintColor.a * VertexAlpha350 );
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

				#ifdef TREEVERSE_LINEAR_FOG
					Color.rgb = lerp(unity_FogColor.rgb, Color.rgb, IN.fogFactor);
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
	CustomEditor "UnityEditor.ShaderGraph.PBRMasterGUI"
	Fallback "Hidden/InternalErrorShader"
	
}
/*ASEBEGIN
Version=18935
2149.667;439;2327;1192;8235.684;474.5016;3.464859;True;True
Node;AmplifyShaderEditor.CommentaryNode;740;-4428.083,-608.1194;Inherit;False;556.6309;168.6472;Comment;2;629;633;Use CustomDate;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;629;-4378.083,-555.4722;Inherit;False;Property;_UseCustomData;Use CustomData;57;2;[Header];[Toggle];Create;True;1;CustomDate;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;473;-3416.707,-1552.423;Inherit;False;1177.795;1029.757;Comment;21;468;467;457;458;466;436;464;456;459;435;460;461;437;465;462;463;454;453;452;455;451;Time to UV;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;628;-3972.07,-296.106;Inherit;False;2111.844;509.7973;Comment;11;510;503;502;504;511;507;508;506;591;647;682;UV3 CustomData;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;435;-3212.385,-1472.913;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;633;-4102.452,-558.1194;Inherit;False;UseCustomData;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;647;-3700.168,-212.4078;Inherit;False;465.9121;394.1233;Comment;4;632;635;634;631;Use CustomDate;0.4662542,0,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;635;-3653.785,40.22818;Inherit;False;633;UseCustomData;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;437;-3025.161,-1473.823;Inherit;False;Time;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;467;-3366.707,-1285.426;Inherit;False;312.3809;240.363;Comment;1;438;_FlowSpeedA;0.3884525,0,1,1;0;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;591;-3911.934,-106.4254;Inherit;False;2;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;682;-2760.177,-217.782;Inherit;False;543.6907;373.1591;Comment;4;678;680;681;679;_DataX2Y2;0.4746089,0,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;634;-3429.923,-1.884006;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;506;-3178.281,31.79305;Inherit;False;Constant;_Float13;Float 13;28;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;436;-3021.432,-1394.02;Inherit;False;437;Time;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;438;-3316.707,-1235.426;Inherit;False;Property;_FlowSpeedClipTwist;FlowSpeed Clip Twist ;40;1;[Header];Create;True;1;Flow Speed;0;0;False;0;False;0,0,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;507;-3007.682,81.79338;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;508;-3008.182,-20.50668;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;462;-2720.136,-1077.785;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;461;-2724.179,-1175.814;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;681;-2726.973,43.9839;Inherit;False;Property;_DataY2;DataY2 TwistTex Flow U or V;60;1;[Toggle];Create;False;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;741;-5033.09,686.7302;Inherit;False;3535.353;969.9045;Comment;21;447;323;743;552;739;486;539;284;719;555;578;482;541;512;540;738;563;562;517;478;764;Twist;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;454;-2559.716,-1081.311;Inherit;False;FlowSpeed_Twist_V;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;478;-4715.173,921.0566;Inherit;False;402.4792;206.6982;Comment;3;481;479;480;TimeFlow;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;680;-2411.928,0.224438;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;453;-2555.266,-1182.665;Inherit;False;FlowSpeed_Twist_U;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;480;-4685.045,963.8968;Inherit;False;453;FlowSpeed_Twist_U;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;517;-4577.292,1179.482;Inherit;False;268.7864;136.0776;Comment;1;513;DataY2 Flow;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;468;-3365.232,-971.9154;Inherit;False;338.3809;246.8541;Comment;1;450;_FlowSpeedB;0.4255471,0,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;511;-2188.915,-4.772183;Inherit;False;DataY2TwistFlow;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;479;-4685.028,1041.847;Inherit;False;454;FlowSpeed_Twist_V;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;513;-4537.7,1228.18;Inherit;False;511;DataY2TwistFlow;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;481;-4438.857,1019.086;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;450;-3315.232,-921.9154;Inherit;False;Property;_FlowSpeedMainTwistMask;FlowSpeed Main TwistMask;41;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureTransformNode;562;-4468.326,802.8915;Inherit;False;539;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.CommentaryNode;738;-4275.823,1337.543;Inherit;False;645.9224;212.4607;Comment;2;724;737; For Paricle Sprite Sheet;1,1,1,1;0;0
Node;AmplifyShaderEditor.BreakToComponentsNode;563;-4242.385,776.8066;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;512;-4256.86,989.3022;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;466;-2734.023,-657.6661;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;540;-4006.474,906.508;Inherit;False;0;539;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;465;-2734.284,-760.4544;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;765;-4188.926,351.4543;Inherit;False;Property;_SelfTwistUV;SelfTwist UV;38;0;Create;True;0;0;0;False;0;False;1,1,0,0;2,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;229;-1985.155,-1173.679;Inherit;False;1716.571;728.8047;;11;239;213;212;324;223;219;218;238;592;646;688;UV2 CustomData;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;771;-3857.911,448.3241;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;458;-2571.297,-658.2637;Inherit;False;FlowSpeed_Forth_V;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;541;-3758.697,965.0883;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;457;-2571.631,-749.4754;Inherit;False;FlowSpeed_Forth_U;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;482;-3025.598,1384.821;Inherit;False;402.4792;206.6982;Comment;3;485;484;483;TimeFlow;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;578;-4091.717,747.1685;Inherit;False;VFX_Polar;-1;;275;dc3bcb6ec7e9c4241baaa261038f5919;0;4;69;FLOAT2;0,0;False;65;FLOAT;3;False;66;FLOAT;1;False;34;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;646;-1707.956,-1076.081;Inherit;False;468.2543;597.831;Comment;8;645;644;643;642;641;640;638;639;Use Custom Date;0.4509578,0,1,1;0;0
Node;AmplifyShaderEditor.TextureTransformNode;724;-4225.824,1387.543;Inherit;False;539;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.CommentaryNode;763;-3457.942,342.3661;Inherit;False;1185.879;308.3527;Comment;5;760;758;757;752;762;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;485;-3004.521,1509.011;Inherit;False;458;FlowSpeed_Forth_V;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;555;-3596.426,789.5202;Inherit;False;Property;_TwistTexUsePolarUV;TwistTex Use Polar UV;31;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;642;-1663.711,-773.5165;Inherit;False;633;UseCustomData;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;769;-3576.348,353.0431;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;770;-3547.348,475.0431;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;592;-1930.625,-1037.154;Inherit;False;1;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;484;-3007.71,1434.821;Inherit;False;457;FlowSpeed_Forth_U;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;737;-3991.898,1391.004;Inherit;False;VFX_PatrcleCenterUV;-1;;396;4e9e805f544695843b53ac34f69b5e40;0;3;7;FLOAT2;1,1;False;8;FLOAT2;0,0;False;10;FLOAT2;1,1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;643;-1425.271,-782.6978;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;483;-2753.154,1493.799;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;760;-3350.852,392.3661;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.5,0.5;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;719;-3335.722,986.1689;Inherit;False;Property;_UsePatricleCenterUV;Use Patricle Center UV;30;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;752;-3407.942,512.4298;Inherit;False;Property;_NormalSelfTwisStage;NormalSelfTwis Stage ;39;0;Create;True;0;0;0;False;0;False;1;1.657;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;758;-3071.277,392.7127;Inherit;True;Property;_TextureSample0;Texture Sample 0;29;0;Create;True;1;Twist;0;0;False;0;False;-1;53b415222112ea94e960e1c7d7e05dc3;c8096cd4cc55f334982cdd1e401f0b4a;True;0;True;bump;Auto;True;Instance;539;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;284;-2836.928,1191.596;Inherit;False;219.1673;138.9515;Comment;1;241;_DataZ1;0.4952259,0,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;238;-1152.891,-764.5329;Inherit;False;DataZ1;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;486;-2343.028,1516.841;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;539;-3061.204,962.816;Inherit;True;Property;_TwistTex;TwistTex;29;1;[Header];Create;True;1;Twist;0;0;False;0;False;-1;53b415222112ea94e960e1c7d7e05dc3;4f4c6b9ef7eb74e449de35a67aa4b631;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;638;-1670.48,-1008.909;Inherit;False;633;UseCustomData;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;757;-2772.197,396.7188;Inherit;True;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;688;-1050.394,-680.276;Inherit;False;751.9122;209;Comment;3;687;686;375;DataX1 MainTex Flow U or V;0.4206057,0,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;241;-2795.75,1232.107;Inherit;False;238;DataZ1;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;764;-2263.373,1376.835;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;632;-3662.835,-119.4284;Inherit;False;633;UseCustomData;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;639;-1423.048,-1049.626;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;219;-1116.389,-972.9268;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;687;-1000.394,-588.1844;Inherit;False;Property;_DataX1;DataX1 MainTex Flow U or V;58;1;[Toggle];Create;False;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;762;-2479.631,397.8718;Inherit;False;Property;_UseNormalSelfTwist;Use NormalSelfTwist;37;0;Create;True;0;0;0;False;1;Header(Use NormalSelfTwist);False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;218;-1124.108,-1067.296;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;504;-3182.627,-181.8855;Inherit;False;Constant;_Float5;Float 5;28;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;739;-2289.261,1021.905;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;631;-3442.251,-163.7727;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;552;-2261.529,1049.495;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;743;-2236.826,943.9224;Inherit;False;VFX_Twist;32;;407;84c8764698f118d4889e2fe2f9fd6acd;0;3;12;FLOAT3;0,0,0;False;49;FLOAT;0;False;56;FLOAT2;0,0;False;2;FLOAT2;0;FLOAT;54
Node;AmplifyShaderEditor.DynamicAppendNode;502;-3013.928,-243.9854;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;503;-3010.928,-142.9855;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;679;-2724.205,-121.5177;Inherit;False;Property;_DataX2;DataX2 ClipTex Flow U or V;59;1;[Toggle];Create;False;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;742;-1403.492,507.3073;Inherit;False;3014.571;1615.598;Comment;23;685;333;522;583;521;545;535;378;366;584;655;652;586;579;546;585;230;365;544;659;294;293;292;Clip;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;460;-2750.02,-1282.884;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;686;-735.6136,-630.276;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;459;-2748.433,-1381.977;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;522;-1108.959,1882.906;Inherit;False;403;208;Comment;3;525;524;523;TimeFlow;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;333;-1353.492,1205.666;Inherit;False;586.1172;248.1698;Comment;3;327;673;674;TwistClipTex;0.4636889,0,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;451;-2533.275,-1385.582;Inherit;False;FlowSpeed_Clip_U;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;452;-2559.521,-1281.704;Inherit;False;FlowSpeed_Clip_V;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;685;-1298.018,1493.854;Inherit;False;531.4069;243.1427;Comment;3;684;377;683;ClipFlow Follow MainTex;0.4644604,0,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;323;-1738.737,939.5189;Inherit;False;TwistOutputedUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;678;-2413.876,-163.9346;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;375;-566.482,-628.0228;Inherit;False;MainTexUVFlowByData;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;674;-1241.679,1350.563;Inherit;False;Property;_TwistClipTex;TwistClipTex;28;1;[Toggle];Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;683;-1243.6,1620.997;Inherit;False;Property;_ClipFlowFollowMainTex;ClipFlow Follow MainTex;24;1;[Toggle];Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;510;-2181.151,-167.4085;Inherit;False;DataX2ClipFlow;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;327;-1293.153,1269.836;Inherit;False;323;TwistOutputedUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;671;2625.764,-203.6852;Inherit;True;VFX_Mask;42;;408;364b953953898644d9a77bfcd0eeace1;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;524;-1092.959,2005.906;Inherit;False;452;FlowSpeed_Clip_V;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;377;-1248.018,1543.855;Inherit;False;375;MainTexUVFlowByData;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;523;-1094.959,1932.906;Inherit;False;451;FlowSpeed_Clip_U;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureTransformNode;583;-989.6048,954.4341;Inherit;False;544;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;355;2860.92,-207.5764;Inherit;False;MaskAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;673;-971.4969,1291.359;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;684;-948.6113,1548.168;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;521;-936.4216,1772.106;Inherit;False;510;DataX2ClipFlow;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;525;-849.9594,1987.906;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;378;-563.1132,1320.999;Inherit;False;4;4;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;366;51.98574,1414.559;Inherit;False;355;MaskAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;545;-505.6609,803.1089;Inherit;False;0;544;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;640;-1666.269,-891.9187;Inherit;False;633;UseCustomData;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;535;-39.41153,1484.842;Inherit;False;Property;_MaskBlendStage;Mask Blend Stage;46;0;Create;True;0;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;584;-738.7086,961.2508;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.CommentaryNode;652;-160.125,944.0758;Inherit;False;563.316;209;Comment;1;692;ClipTex Use Polar UV;0.4417157,0,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;546;-265.3232,808.6091;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;586;234.7123,1415.883;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;641;-1431.347,-915.5142;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;579;-486.2002,1016.134;Inherit;False;VFX_Polar;-1;;409;dc3bcb6ec7e9c4241baaa261038f5919;0;4;69;FLOAT2;0,0;False;65;FLOAT;3;False;66;FLOAT;1;False;34;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;463;-2721.145,-966.6181;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;464;-2729.231,-863.5364;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;655;499.5829,1295.683;Inherit;False;559.3164;235.3157;Comment;2;653;654;Mask Blend ClipTex;0.3710442,0,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;455;-2559.695,-966.0244;Inherit;False;FlowSpeed_Main_U;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;653;542.9391,1401.997;Inherit;False;Property;_MaskBlendClipTex;Mask Blend ClipTex;27;1;[Toggle];Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;365;352.2249,1334.036;Half;False;Constant;_Float9;Float 9;16;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;585;356.312,1416.883;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;230;640.6985,557.3073;Inherit;False;283.9373;168.493;Comment;1;224;_DataY1;0.456182,0,1,1;0;0
Node;AmplifyShaderEditor.StaticSwitch;692;21.13173,992.7626;Inherit;False;Property;_ClipTexUsePolarUV;ClipTex Use Polar UV;26;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;456;-2563.278,-865.2153;Inherit;False;FlowSpeed_Main_V;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;472;-938.7029,-1411.09;Inherit;False;403;208;Comment;3;471;469;470;TimeFlow;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;223;-1151.978,-849.0793;Inherit;False;DataY1;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;469;-924.7026,-1361.09;Inherit;False;455;FlowSpeed_Main_U;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;470;-922.7026,-1288.09;Inherit;False;456;FlowSpeed_Main_V;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;224;724.094,620.9391;Inherit;False;223;DataY1;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;654;860.7081,1356.09;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;544;458.722,759.5048;Inherit;True;Property;_ClipTex;ClipTex;16;1;[Header];Create;True;1;Clip;0;0;False;0;False;-1;3313b5d760a88c0499a0a3306d53c25b;71b994cee34fb884eb83dc2dd7c2d755;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;471;-679.7026,-1306.09;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;659;988.7039,745.5891;Inherit;False;VFX_ClipSmoothEdge;17;;410;69e070d297569514d918f7319aa4d435;0;3;62;FLOAT;0;False;24;FLOAT;0;False;87;FLOAT;1;False;4;FLOAT;22;FLOAT;28;COLOR;32;FLOAT;124
Node;AmplifyShaderEditor.GetLocalVarNode;324;-790.9997,-985.3266;Inherit;True;323;TwistOutputedUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;212;-795.0197,-1120.147;Inherit;False;0;10;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;213;-440.1674,-1117.411;Inherit;False;4;4;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;294;1383.581,847.6652;Inherit;False;ClipEdgeColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;293;1385.661,762.1223;Inherit;False;ClipEdgeAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;296;37.54325,-907.9866;Inherit;False;293;ClipEdgeAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;297;40.44144,-826.3002;Inherit;False;294;ClipEdgeColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;661;480.7153,-1251.377;Inherit;False;Property;_ClipEdgeBlendMainTex;ClipEdge Blend MainTex;25;1;[Toggle];Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;10;-245.0968,-1087.734;Inherit;True;Property;_MainTex;MainTex;1;1;[Header];Create;True;1;MainTex;0;0;False;0;False;-1;1a00ca6e281456e4ebe187d579d56d48;d7ce919dfcc637e4c9e4e2e4077c0834;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;276;328.6456,-955.8673;Inherit;False;4;4;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;663;717.8802,-1251.973;Inherit;False;ClipEdgeBlendMainTex;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;278;480.8983,-1010.513;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;664;460.4802,-862.3546;Inherit;False;663;ClipEdgeBlendMainTex;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;660;743.3239,-1091.107;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;601;1362.105,-712.5451;Inherit;True;VFX_GraytoColor Gradient;5;;411;4dca6182a64a98847bdebf99782433f1;0;1;27;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;298;1861.57,-594.8979;Inherit;False;293;ClipEdgeAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;299;1873.001,-510.5169;Inherit;False;294;ClipEdgeColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;644;-1656.831,-662.2408;Inherit;False;633;UseCustomData;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;288;2821.155,-616.3199;Inherit;False;589.7087;302.3228;Comment;5;350;490;488;489;21;VertexColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;667;2131.061,-837.4001;Inherit;False;663;ClipEdgeBlendMainTex;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;645;-1424.005,-646.7718;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;21;2841.364,-537.4343;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;617;3051.928,-250.714;Inherit;False;437.3711;292.5679;Comment;3;414;609;611;Mask Null Alpha;0.4016991,0,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;227;1328.217,-458.821;Inherit;True;VFX_ClipBlack;2;;416;bca2b1ae1e5a4c544b8f204bdd345f7b;0;2;8;FLOAT4;0,0,0,0;False;18;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;714;2089.942,-610.3402;Inherit;False;VFX_ClipEdge;-1;;415;1a8a8b88657c99948944543463522665;0;3;24;FLOAT3;0,0,0;False;135;FLOAT;0;False;136;FLOAT3;0,0,0;False;1;FLOAT3;140
Node;AmplifyShaderEditor.RegisterLocalVarNode;350;3015.781,-405.6501;Inherit;False;VertexAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;494;3113.511,-1023.388;Inherit;False;225.9434;235.1498;Comment;1;406;TintColor;0.410079,0,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;292;1387.079,677.5983;Inherit;False;ClipAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;595;4209.147,-191.6964;Inherit;False;458;FlowSpeed_Forth_V;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;611;3102.828,-70.94614;Inherit;False;Property;_MaskNullAlpha;Mask Null Alpha;45;1;[Toggle];Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;414;3148.931,-144.4554;Inherit;False;Constant;_Int0;Int 0;20;0;Create;True;0;0;0;False;0;False;1;0;False;0;1;INT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;491;1669.283,-463.0382;Inherit;False;ClipBlackAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;239;-1148.03,-680.5465;Inherit;False;DataW1;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;594;4207.024,-267.04;Inherit;False;457;FlowSpeed_Forth_U;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;665;2431.901,-747.4615;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;251;4432.188,-315.239;Inherit;False;239;DataW1;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;716;4428.971,-128.7024;Inherit;False;355;MaskAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;609;3301.299,-198.714;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;295;3632.984,-323.2997;Inherit;False;292;ClipAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;596;4469.283,-238.8632;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;492;3609.976,-399.6439;Inherit;False;491;ClipBlackAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;406;3136.661,-973.3875;Inherit;False;Property;_TintColor;TintColor;0;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;1.931927,5.59088,5.063991,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;620;-3810.292,-1549.744;Inherit;False;351.5083;335.5892;Comment;3;605;618;619;Shader Options;0.3799582,0,1,1;0;0
Node;AmplifyShaderEditor.WireNode;672;2758.003,-692.5626;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;616;3605.649,-148.9696;Inherit;False;350;VertexAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;490;3203.604,-405.4536;Inherit;False;VertexB;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;3923.222,-348.1472;Inherit;False;5;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;605;-3758.784,-1499.744;Inherit;False;Property;_CullMode;Cull Mode;61;2;[Header];[Enum];Create;True;1;Shader Options;2;CullBack;2;CullOff;0;1;UnityEngine.Rendering.CullMode;True;0;False;2;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;718;4643.135,-268.4309;Inherit;False;VFX_VertexOffset;47;;417;47bca5503be245c4783b3c6edf42a04a;0;3;40;FLOAT;1;False;36;FLOAT2;0,0;False;39;FLOAT3;1,1,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;489;3013.941,-482.8313;Inherit;False;VertexG;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;618;-3760.292,-1415.694;Inherit;False;Property;_ZWriteMode;Z Write Mode;62;1;[Enum];Create;True;0;2;Off;0;On;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;619;-3758.073,-1330.155;Inherit;False;Property;_ZTestMode;Z Test Mode;63;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;447;-1732.818,1036.519;Inherit;False;TwistMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;3635.299,-698.7161;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;488;3204.964,-483.941;Inherit;False;VertexR;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;626;4660.794,-690.5344;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;SceneSelectionPass;0;6;SceneSelectionPass;5;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=SceneSelectionPass;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;625;4660.794,-693.2109;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;DepthOnly;0;5;DepthOnly;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;False;False;True;False;False;False;False;0;False;-1;False;False;False;False;False;False;False;False;False;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;627;4660.794,-693.2109;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;Meta;0;7;Meta;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;622;4660.794,-690.5344;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;ExtraPrePass;0;2;ExtraPrePass;6;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;0;False;False;0;Hidden/InternalErrorShader;0;0;Standard;1;MRT Output;0;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;713;4786.589,-690.5344;Float;False;False;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;1;New Amplify Shader;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;FullScreenPass;0;1;FullScreenPass;4;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;7;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=UniversalForwardOnly;True;2;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;623;4940.241,-698.7952;Half;False;True;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;21;ASE/VFX/AssignColorClipTwist_Blend;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;Forward;0;3;Forward;12;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;0;True;605;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;True;1;5;False;-1;10;False;-1;1;1;False;-1;10;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;True;2;True;618;True;3;True;619;True;False;0;False;-1;0;False;-1;True;1;LightMode=UniversalForward;False;False;0;Hidden/InternalErrorShader;0;0;Standard;19;Surface;1;637938935973147955;  Blend;0;0;Two Sided;1;0;Cast Shadows;0;637938935950703661;  Use Shadow Threshold;0;0;Receive Shadows;1;0;GPU Instancing;1;0;LOD CrossFade;0;0;Treeverse Linear Fog;0;0;DOTS Instancing;0;0;Meta Pass;0;0;Extra Pre Pass;0;0;Full Screen Pass;0;0;Additional Pass;0;0;Scene Selectioin Pass;0;0;Vertex Position,InvertActionOnDeselection;1;0;Vertex Operation Hide Pass Only;0;0;Discard Fragment;0;0;Push SelfShadow to Main Light;0;0;2;MRT Output;0;0;Custom Output Position;0;0;8;False;False;False;True;False;False;False;False;False;;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;621;4660.794,-690.5344;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;AdditionalPass;0;0;AdditionalPass;6;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;0;False;False;0;Hidden/InternalErrorShader;0;0;Standard;1;MRT Output;0;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;624;4660.794,-693.2109;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;ShadowCaster;0;4;ShadowCaster;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
WireConnection;633;0;629;0
WireConnection;437;0;435;0
WireConnection;634;1;591;2
WireConnection;634;2;635;0
WireConnection;507;0;506;0
WireConnection;507;1;634;0
WireConnection;508;0;634;0
WireConnection;508;1;506;0
WireConnection;462;0;436;0
WireConnection;462;1;438;4
WireConnection;461;0;436;0
WireConnection;461;1;438;3
WireConnection;454;0;462;0
WireConnection;680;0;508;0
WireConnection;680;1;507;0
WireConnection;680;2;681;0
WireConnection;453;0;461;0
WireConnection;511;0;680;0
WireConnection;481;0;480;0
WireConnection;481;1;479;0
WireConnection;563;0;562;0
WireConnection;512;0;481;0
WireConnection;512;1;513;0
WireConnection;466;0;436;0
WireConnection;466;1;450;4
WireConnection;465;0;436;0
WireConnection;465;1;450;3
WireConnection;771;0;765;3
WireConnection;771;1;765;4
WireConnection;458;0;466;0
WireConnection;541;0;540;0
WireConnection;541;1;512;0
WireConnection;457;0;465;0
WireConnection;578;69;512;0
WireConnection;578;65;563;0
WireConnection;578;66;563;1
WireConnection;578;34;562;1
WireConnection;555;1;541;0
WireConnection;555;0;578;0
WireConnection;769;0;765;1
WireConnection;769;1;765;2
WireConnection;770;0;771;0
WireConnection;770;1;512;0
WireConnection;737;7;724;0
WireConnection;737;8;724;1
WireConnection;737;10;512;0
WireConnection;643;1;592;3
WireConnection;643;2;642;0
WireConnection;483;0;484;0
WireConnection;483;1;485;0
WireConnection;760;0;769;0
WireConnection;760;1;770;0
WireConnection;719;1;555;0
WireConnection;719;0;737;0
WireConnection;758;1;760;0
WireConnection;758;5;752;0
WireConnection;238;0;643;0
WireConnection;486;0;483;0
WireConnection;539;1;719;0
WireConnection;757;0;758;0
WireConnection;757;1;539;0
WireConnection;764;0;486;0
WireConnection;639;1;592;1
WireConnection;639;2;638;0
WireConnection;219;1;639;0
WireConnection;762;1;539;0
WireConnection;762;0;757;0
WireConnection;218;0;639;0
WireConnection;739;0;241;0
WireConnection;631;1;591;1
WireConnection;631;2;632;0
WireConnection;552;0;764;0
WireConnection;743;12;762;0
WireConnection;743;49;739;0
WireConnection;743;56;552;0
WireConnection;502;0;631;0
WireConnection;502;1;504;0
WireConnection;503;0;504;0
WireConnection;503;1;631;0
WireConnection;460;0;436;0
WireConnection;460;1;438;2
WireConnection;686;0;218;0
WireConnection;686;1;219;0
WireConnection;686;2;687;0
WireConnection;459;0;436;0
WireConnection;459;1;438;1
WireConnection;451;0;459;0
WireConnection;452;0;460;0
WireConnection;323;0;743;0
WireConnection;678;0;502;0
WireConnection;678;1;503;0
WireConnection;678;2;679;0
WireConnection;375;0;686;0
WireConnection;510;0;678;0
WireConnection;355;0;671;0
WireConnection;673;1;327;0
WireConnection;673;2;674;0
WireConnection;684;1;377;0
WireConnection;684;2;683;0
WireConnection;525;0;523;0
WireConnection;525;1;524;0
WireConnection;378;0;673;0
WireConnection;378;1;684;0
WireConnection;378;2;521;0
WireConnection;378;3;525;0
WireConnection;584;0;583;0
WireConnection;546;0;545;0
WireConnection;546;1;378;0
WireConnection;586;0;366;0
WireConnection;586;1;535;0
WireConnection;641;1;592;2
WireConnection;641;2;640;0
WireConnection;579;69;378;0
WireConnection;579;65;584;0
WireConnection;579;66;584;1
WireConnection;579;34;583;1
WireConnection;463;0;436;0
WireConnection;463;1;450;1
WireConnection;464;0;436;0
WireConnection;464;1;450;2
WireConnection;455;0;463;0
WireConnection;585;0;586;0
WireConnection;692;1;546;0
WireConnection;692;0;579;0
WireConnection;456;0;464;0
WireConnection;223;0;641;0
WireConnection;654;0;365;0
WireConnection;654;1;585;0
WireConnection;654;2;653;0
WireConnection;544;1;692;0
WireConnection;471;0;469;0
WireConnection;471;1;470;0
WireConnection;659;62;224;0
WireConnection;659;24;544;1
WireConnection;659;87;654;0
WireConnection;213;0;212;0
WireConnection;213;1;324;0
WireConnection;213;2;686;0
WireConnection;213;3;471;0
WireConnection;294;0;659;32
WireConnection;293;0;659;28
WireConnection;10;1;213;0
WireConnection;276;0;296;0
WireConnection;276;1;297;0
WireConnection;276;2;10;1
WireConnection;276;3;10;4
WireConnection;663;0;661;0
WireConnection;278;0;10;0
WireConnection;278;1;276;0
WireConnection;660;0;10;0
WireConnection;660;1;278;0
WireConnection;660;2;664;0
WireConnection;601;27;660;0
WireConnection;645;1;592;4
WireConnection;645;2;644;0
WireConnection;227;8;660;0
WireConnection;714;24;601;0
WireConnection;714;135;298;0
WireConnection;714;136;299;0
WireConnection;350;0;21;4
WireConnection;292;0;659;22
WireConnection;491;0;227;0
WireConnection;239;0;645;0
WireConnection;665;0;714;140
WireConnection;665;1;601;0
WireConnection;665;2;667;0
WireConnection;609;0;355;0
WireConnection;609;1;414;0
WireConnection;609;2;611;0
WireConnection;596;0;594;0
WireConnection;596;1;595;0
WireConnection;672;0;665;0
WireConnection;490;0;21;3
WireConnection;23;0;492;0
WireConnection;23;1;295;0
WireConnection;23;2;609;0
WireConnection;23;3;406;4
WireConnection;23;4;616;0
WireConnection;718;40;251;0
WireConnection;718;36;596;0
WireConnection;718;39;716;0
WireConnection;489;0;21;2
WireConnection;447;0;743;54
WireConnection;22;0;672;0
WireConnection;22;1;21;0
WireConnection;22;2;406;0
WireConnection;488;0;21;1
WireConnection;623;2;22;0
WireConnection;623;3;23;0
WireConnection;623;5;718;0
ASEEND*/
//CHKSM=7375189D4DD69D898AF47E6AF5DF7E9FBE99C1D7