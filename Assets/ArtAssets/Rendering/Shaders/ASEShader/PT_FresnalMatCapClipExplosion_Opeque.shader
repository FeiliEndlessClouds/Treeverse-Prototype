// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/VFX/FresnalMatCapClipExplosion"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[ASEBegin][HDR]_TintColor("TintColor", Color) = (1,1,1,1)
		[HDR]_BackFaceColor("BackFaceColor", Color) = (1,1,1,1)
		[Header(MainTex)]_MainTex("MainTex", 2D) = "white" {}
		[Header(AssignColor)]_ColorA("Color A", Color) = (1,1,1,0)
		_ColorB("Color B", Color) = (0.9960854,1,0.5235849,0)
		_ColorC("Color C", Color) = (1,0.6265537,0.08018869,0)
		[Header(GradientBlend)][Toggle]_UseGradient("Use Gradient", Float) = 0
		_GradientBlendIntensity("Gradient Blend Intensity", Range( 0 , 1)) = 1
		_GradientUVOffset("Gradient UV Offset", Range( -1 , 1)) = 0
		[Toggle]_GradientUorV("Gradient UorV", Float) = 0
		[Toggle]_InvertGradient("Invert Gradient", Float) = 0
		[Toggle]_UseOriginColor("Use OriginColor", Float) = 0
		[HDR][Header(Fresnel)]_FresnalColor("FresnalColor", Color) = (1,1,1,1)
		_Bias("Bias", Range( -1 , 1)) = 1
		_Scale("Scale", Range( 0 , 10)) = 1
		_Power("Power", Range( 0 , 10)) = 10
		_PosterizeStage("PosterizeStage", Range( 1 , 256)) = 128
		[Toggle(_INVERTFRESNEL_ON)] _InvertFresnel("Invert Fresnel", Float) = 0
		_MatCapTexIntensity("MatCapTex Intensity", Range( 0 , 1)) = 0
		_MatcapTex("MatcapTex", 2D) = "white" {}
		[Header(ClipA MatCap)]_ClipTexA("ClipTex A", 2D) = "white" {}
		[Toggle(_CLIPTEXUV_MATCAP_ON)] _ClipTexUV_MatCap("ClipTexUV_MatCap", Float) = 0
		_ClipTexARotation("ClipTexA Rotation", Range( 0 , 10)) = 0
		[Toggle]_InvertClipTex("Invert ClipTex", Float) = 0
		[Toggle]_ClipNullAlpha("Clip Null Alpha", Float) = 0
		_ClipStage("ClipStage", Range( 0 , 1)) = 0
		[HDR]_EdgeColor("EdgeColor", Color) = (1,1,1,1)
		_EdgeWidth("EdgeWidth", Range( 0 , 1)) = 0.1
		_EdgeSmooth("EdgeSmooth", Range( 0 , 2)) = 0.1
		[Header(ClipTex B)]_ClipTexB("ClipTex B", 2D) = "white" {}
		_ClipTexBBlendA("ClipTexB Blend A", Range( 0 , 2)) = 0
		[Header(Twist)][Normal]_TwistTex("TwistTex", 2D) = "bump" {}
		[Toggle(_TWISTTEXUSEPOLARUV_ON)] _TwistTexUsePolarUV("TwistTex Use Polar UV", Float) = 0
		[Toggle(_USEPATRICLECENTERUV_ON)] _UsePatricleCenterUV("Use Patricle Center UV", Float) = 0
		_TwistStage("TwistStage", Range( -2 , 2)) = 0.1
		[Header(TwistMask)][Toggle]_UseTwistMask("Use TwistMask", Float) = 0
		_TwistMaskTex("TwistMaskTex", 2D) = "white" {}
		[Toggle]_InvertTwistMskTex("InvertTwistMskTex", Float) = 0
		[Header(Flow Speed)]_FlowSpeedClipTwist("FlowSpeed Clip Twist ", Vector) = (0,0,0,0)
		[Header(Flow Speed)]_FlowSpeedMainTexVertexOffset("FlowSpeed MainTex VertexOffset", Vector) = (0,0,0,0)
		[Header(VertexOffset)][Toggle(_USEVERTEXOFFSET_ON)] _UseVertexOffset("Use Vertex Offset", Float) = 0
		_VertexOffsetScale("VertexOffset Scale", Range( 0 , 4)) = 1
		[Toggle]_VertexOffsetUsePositionUV("VertexOffset Use Position UV", Float) = 0
		[Toggle]_VertexOffsetPushorPull("VertexOffset Push or Pull", Range( 0 , 1)) = 0
		[Toggle]_VertexOffsetUseMaskTex("VertexOffset Use MaskTex", Float) = 0
		_VertexOffset("Vertex Offset", Range( -1 , 1)) = 0
		[Toggle(_USETRIPLANARSAMPLER_ON)] _UseTriplanarSampler("Use Triplanar Sampler", Float) = 0
		_TriUVWorldPosition("TriUV World Position", Range( 0 , 1)) = 1
		_VertexOffsetTex("VertexOffsetTex", 2D) = "white" {}
		[Toggle(_USEVERTEXALPHAMASKOFFSET_ON)] _UseVertexAlphaMaskOffset("Use Vertex Alpha Mask Offset", Float) = 0
		[Toggle(_USECUSTOMDATA_ON)] _UseCustomData("Use CustomData", Float) = 0
		[ASEEnd][Header(Shader Options)][Enum(UnityEngine.Rendering.CullMode)]_CullMode("Cull Mode", Range( 0 , 2)) = 2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

		
	}

	SubShader
	{
		LOD 0

		
		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Opaque" "Queue"="Geometry" }
		
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
			
			Blend One Zero, One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM
			
			#pragma multi_compile_instancing
			#define DISCARD_FRAGMENT
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
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_COLOR
			#pragma shader_feature_local _USEVERTEXALPHAMASKOFFSET_ON
			#pragma shader_feature_local _USEVERTEXOFFSET_ON
			#pragma shader_feature_local _USETRIPLANARSAMPLER_ON
			#pragma shader_feature_local _USECUSTOMDATA_ON
			#pragma shader_feature_local _CLIPTEXUV_MATCAP_ON
			#pragma shader_feature_local _USEPATRICLECENTERUV_ON
			#pragma shader_feature_local _TWISTTEXUSEPOLARUV_ON
			#pragma shader_feature_local _INVERTFRESNEL_ON


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_color : COLOR;
				float4 ase_texcoord2 : TEXCOORD2;
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
				
				float4 ase_color : COLOR;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				float4 ase_texcoord6 : TEXCOORD6;
				float4 ase_texcoord7 : TEXCOORD7;
				float4 ase_texcoord8 : TEXCOORD8;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)

			float4 _EdgeColor;
			float4 _ColorC;
			float4 _ColorB;
			float4 _ClipTexB_ST;
			float4 _ColorA;
			float4 _MainTex_ST;
			float4 _TwistMaskTex_ST;
			float4 _TwistTex_ST;
			float4 _FlowSpeedClipTwist;
			float4 _BackFaceColor;
			float4 _ClipTexA_ST;
			half4 _FresnalColor;
			float4 _FlowSpeedMainTexVertexOffset;
			float4 _VertexOffsetTex_ST;
			float4 _TintColor;
			float _GradientUorV;
			float _UseGradient;
			float _UseOriginColor;
			float _MatCapTexIntensity;
			float _GradientUVOffset;
			float _GradientBlendIntensity;
			half _PosterizeStage;
			half _Bias;
			half _Scale;
			float _InvertGradient;
			float _ClipTexBBlendA;
			float _InvertClipTex;
			float _VertexOffsetPushorPull;
			float _VertexOffsetScale;
			float _VertexOffset;
			float _VertexOffsetUsePositionUV;
			float _TriUVWorldPosition;
			float _VertexOffsetUseMaskTex;
			float _ClipNullAlpha;
			float _ClipStage;
			float _EdgeSmooth;
			float _TwistStage;
			float _InvertTwistMskTex;
			float _UseTwistMask;
			half _ClipTexARotation;
			half _Power;
			float _EdgeWidth;
			float _CullMode;
			CBUFFER_END
			sampler2D _VertexOffsetTex;
			sampler2D _ClipTexA;
			sampler2D _TwistTex;
			sampler2D _TwistMaskTex;
			sampler2D _ClipTexB;
			sampler2D _MainTex;
			sampler2D _MatcapTex;


			inline float4 TriplanarSampling45_g507( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
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

				float lerpResult29_g507 = lerp( 1.0 , -1.0 , _VertexOffsetPushorPull);
				float2 uv_VertexOffsetTex = v.ase_texcoord.xy * _VertexOffsetTex_ST.xy + _VertexOffsetTex_ST.zw;
				float Time647 = _TimeParameters.x;
				float FlowSpeed_VertexOffset_U724 = ( Time647 * _FlowSpeedMainTexVertexOffset.z );
				float FlowSpeed_VertexOffset_V727 = ( Time647 * _FlowSpeedMainTexVertexOffset.w );
				float2 appendResult661 = (float2(FlowSpeed_VertexOffset_U724 , FlowSpeed_VertexOffset_V727));
				float2 temp_output_36_0_g507 = appendResult661;
				float3 ase_worldPos = mul(GetObjectToWorldMatrix(), v.vertex).xyz;
				float3 objToWorld50_g508 = mul( GetObjectToWorldMatrix(), float4( float3( 0,0,0 ), 1 ) ).xyz;
				float2 appendResult55_g508 = (float2(( ( ase_worldPos.x - v.ase_texcoord3.x ) - objToWorld50_g508.x ) , ( ( ase_worldPos.y - v.ase_texcoord3.y ) - objToWorld50_g508.y )));
				float2 lerpResult17_g507 = lerp( ( uv_VertexOffsetTex + temp_output_36_0_g507 ) , ( temp_output_36_0_g507 + (appendResult55_g508*_VertexOffsetTex_ST.xy + _VertexOffsetTex_ST.zw) ) , _VertexOffsetUsePositionUV);
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				float3 temp_cast_1 = (_TriUVWorldPosition).xxx;
				float4 triplanar45_g507 = TriplanarSampling45_g507( _VertexOffsetTex, temp_cast_1, ase_worldNormal, _VertexOffsetTex_ST.zw.x, _VertexOffsetTex_ST.xy, 1.0, 0 );
				#ifdef _USETRIPLANARSAMPLER_ON
				float staticSwitch50_g507 = triplanar45_g507.x;
				#else
				float staticSwitch50_g507 = tex2Dlod( _VertexOffsetTex, float4( lerpResult17_g507, 0, 0.0) ).r;
				#endif
				float3 temp_cast_2 = (( _VertexOffset + staticSwitch50_g507 )).xxx;
				float3 lerpResult30_g507 = lerp( temp_cast_2 , ( staticSwitch50_g507 * float3( 1,1,1 ) ) , _VertexOffsetUseMaskTex);
				#ifdef _USECUSTOMDATA_ON
				float staticSwitch518 = v.ase_texcoord1.w;
				#else
				float staticSwitch518 = (float)0;
				#endif
				float DataW1520 = staticSwitch518;
				#ifdef _USEVERTEXOFFSET_ON
				float3 staticSwitch34_g507 = ( v.ase_normal * lerpResult29_g507 * _VertexOffsetScale * lerpResult30_g507 * DataW1520 );
				#else
				float3 staticSwitch34_g507 = float3( 0,0,0 );
				#endif
				float3 temp_output_756_0 = staticSwitch34_g507;
				float VertexAlpha680 = v.ase_color.a;
				#ifdef _USEVERTEXALPHAMASKOFFSET_ON
				float3 staticSwitch758 = ( temp_output_756_0 * VertexAlpha680 );
				#else
				float3 staticSwitch758 = temp_output_756_0;
				#endif
				
				o.ase_texcoord7.xyz = ase_worldNormal;
				
				o.ase_color = v.ase_color;
				o.ase_texcoord3 = v.ase_texcoord1;
				o.ase_texcoord4.xy = v.ase_texcoord.xy;
				o.ase_texcoord5 = v.vertex;
				o.ase_texcoord6.xyz = v.ase_texcoord3.xyz;
				o.ase_texcoord8 = v.ase_texcoord2;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord4.zw = 0;
				o.ase_texcoord6.w = 0;
				o.ase_texcoord7.w = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = staticSwitch758;
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
				
				#ifdef TREEVERSE_LINEAR_FOG
					half fogFactor =  (1.0 - saturate( positionCS.z * unity_FogParams.z + unity_FogParams.w)) * step(0.001, -1.0 / unity_FogParams.z);
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
			, FRONT_FACE_TYPE ase_vface : FRONT_FACE_SEMANTIC ) : SV_Target
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
				float VertexAlpha680 = IN.ase_color.a;
				#ifdef _USEVERTEXALPHAMASKOFFSET_ON
				float staticSwitch762 = 1.0;
				#else
				float staticSwitch762 = VertexAlpha680;
				#endif
				#ifdef _USECUSTOMDATA_ON
				float staticSwitch511 = IN.ase_texcoord3.y;
				#else
				float staticSwitch511 = (float)0;
				#endif
				float DataY1507 = staticSwitch511;
				float EdgeWidth95_g487 = _EdgeWidth;
				float EdgeSmooth57_g487 = _EdgeSmooth;
				float temp_output_72_0_g487 = (( ( EdgeWidth95_g487 * -1.1 ) + -0.2 + ( EdgeSmooth57_g487 * -1.0 ) ) + (saturate( ( _ClipStage + DataY1507 ) ) - 0.0) * (1.1 - ( ( EdgeWidth95_g487 * -1.1 ) + -0.2 + ( EdgeSmooth57_g487 * -1.0 ) )) / (1.0 - 0.0));
				float2 uv_ClipTexA = IN.ase_texcoord4.xy * _ClipTexA_ST.xy + _ClipTexA_ST.zw;
				float2 texCoord628 = IN.ase_texcoord4.xy * float2( 1,1 ) + float2( 0,0 );
				float Time647 = _TimeParameters.x;
				float FlowSpeed_Twist_U651 = ( Time647 * _FlowSpeedClipTwist.z );
				float FlowSpeed_Twist_V652 = ( Time647 * _FlowSpeedClipTwist.w );
				float2 appendResult625 = (float2(FlowSpeed_Twist_U651 , FlowSpeed_Twist_V652));
				float2 temp_output_626_0 = ( appendResult625 + float2( 0,0 ) );
				float2 CenteredUV49_g473 = ( IN.ase_texcoord4.xy - ( _TwistTex_ST.zw + float2( 0.5,0.5 ) ) );
				float2 break627 = _TwistTex_ST.xy;
				float2 break33_g473 = CenteredUV49_g473;
				float2 appendResult44_g473 = (float2(( length( CenteredUV49_g473 ) * break627.y * 2.0 ) , ( atan2( break33_g473.y , break33_g473.x ) * ( 1.0 / TWO_PI ) * break627.x )));
				float2 appendResult68_g473 = (float2(temp_output_626_0));
				#ifdef _TWISTTEXUSEPOLARUV_ON
				float2 staticSwitch636 = ( appendResult44_g473 + appendResult68_g473 );
				#else
				float2 staticSwitch636 = ( texCoord628 + temp_output_626_0 );
				#endif
				float2 appendResult1_g474 = (float2(IN.ase_texcoord5.xyz.x , IN.ase_texcoord5.xyz.y));
				float2 appendResult2_g474 = (float2(IN.ase_texcoord6.xyz.x , IN.ase_texcoord6.xyz.y));
				#ifdef _USEPATRICLECENTERUV_ON
				float2 staticSwitch639 = ( temp_output_626_0 + (( appendResult1_g474 - appendResult2_g474 )*_TwistTex_ST.xy + _TwistTex_ST.zw) );
				#else
				float2 staticSwitch639 = staticSwitch636;
				#endif
				#ifdef _USECUSTOMDATA_ON
				float staticSwitch517 = IN.ase_texcoord3.z;
				#else
				float staticSwitch517 = (float)0;
				#endif
				float DataZ1519 = staticSwitch517;
				float2 uv_TwistMaskTex = IN.ase_texcoord4.xy * _TwistMaskTex_ST.xy + _TwistMaskTex_ST.zw;
				float4 tex2DNode52_g477 = tex2D( _TwistMaskTex, ( uv_TwistMaskTex + float2( 0,0 ) ) );
				float lerpResult61_g477 = lerp( tex2DNode52_g477.r , ( 1.0 - tex2DNode52_g477.r ) , _InvertTwistMskTex);
				float lerpResult62_g477 = lerp( 1.0 , lerpResult61_g477 , _UseTwistMask);
				float2 TwistOutputedUV644 = ( (UnpackNormalScale( tex2D( _TwistTex, staticSwitch639 ), 1.0f )).xy * ( _TwistStage + DataZ1519 ) * lerpResult62_g477 );
				float3 ase_worldNormal = IN.ase_texcoord7.xyz;
				float cos464 = cos( ( _ClipTexARotation + DataZ1519 ) );
				float sin464 = sin( ( _ClipTexARotation + DataZ1519 ) );
				float2 rotator464 = mul( ( ( ( (mul( UNITY_MATRIX_V, float4( ase_worldNormal , 0.0 ) ).xyz).xy * 0.5 ) + 0.5 ) + TwistOutputedUV644 ) - ( float2( 0.5,0.5 ) + _ClipTexA_ST.zw ) , float2x2( cos464 , -sin464 , sin464 , cos464 )) + ( float2( 0.5,0.5 ) + _ClipTexA_ST.zw );
				#ifdef _CLIPTEXUV_MATCAP_ON
				float2 staticSwitch700 = rotator464;
				#else
				float2 staticSwitch700 = ( uv_ClipTexA + TwistOutputedUV644 );
				#endif
				float2 uv_ClipTexB = IN.ase_texcoord4.xy * _ClipTexB_ST.xy + _ClipTexB_ST.zw;
				#ifdef _USECUSTOMDATA_ON
				float staticSwitch736 = IN.ase_texcoord8.z;
				#else
				float staticSwitch736 = (float)0;
				#endif
				float DataZ2737 = staticSwitch736;
				float temp_output_122_0_g487 = saturate( ( saturate( ( tex2D( _ClipTexA, staticSwitch700 ).r - ( ( ( 1.0 - tex2D( _ClipTexB, uv_ClipTexB ).r ) - 1.0 ) + ( DataZ2737 + _ClipTexBBlendA ) ) ) ) * 1.0 ) );
				float lerpResult128_g487 = lerp( temp_output_122_0_g487 , ( 1.0 - temp_output_122_0_g487 ) , _InvertClipTex);
				float ClipTex89_g487 = lerpResult128_g487;
				float smoothstepResult40_g487 = smoothstep( temp_output_72_0_g487 , ( temp_output_72_0_g487 + EdgeSmooth57_g487 ) , ClipTex89_g487);
				float lerpResult132_g487 = lerp( smoothstepResult40_g487 , 1.0 , _ClipNullAlpha);
				float ClipAlpha687 = lerpResult132_g487;
				
				float4 lerpResult692 = lerp( _TintColor , _BackFaceColor , _BackFaceColor.a);
				float4 switchResult691 = (((ase_vface>0)?(_TintColor):(lerpResult692)));
				float2 uv_MainTex = IN.ase_texcoord4.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float3 temp_output_27_0_g485 = tex2D( _MainTex, uv_MainTex ).rgb;
				float temp_output_16_0_g486 = temp_output_27_0_g485.x;
				Gradient gradient2_g486 = NewGradient( 0, 4, 2, float4( 1, 1, 1, 0 ), float4( 0.7991835, 0.7991835, 0.7991835, 0.1176471 ), float4( 0.07750964, 0.07750964, 0.07750964, 0.8382391 ), float4( 0, 0, 0, 0.997055 ), 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
				float2 temp_cast_7 = (_GradientUVOffset).xx;
				float2 texCoord3_g486 = IN.ase_texcoord4.xy * float2( 1,1 ) + temp_cast_7;
				float lerpResult17_g486 = lerp( texCoord3_g486.x , texCoord3_g486.y , _GradientUorV);
				float lerpResult19_g486 = lerp( SampleGradient( gradient2_g486, lerpResult17_g486 ).r , ( 1.0 - SampleGradient( gradient2_g486, lerpResult17_g486 ).r ) , _InvertGradient);
				float clampResult9_g486 = clamp( ( ( -1.0 * _GradientBlendIntensity * lerpResult19_g486 ) + temp_output_16_0_g486 ) , 0.0 , 1.0 );
				float lerpResult21_g486 = lerp( temp_output_16_0_g486 , clampResult9_g486 , _UseGradient);
				float ColorAAlpha5_g485 = _ColorA.a;
				float temp_output_17_0_g485 = ( lerpResult21_g486 + ( -0.35 + ( ColorAAlpha5_g485 * 0.3 ) ) );
				float4 lerpResult21_g485 = lerp( _ColorB , _ColorA , temp_output_17_0_g485);
				float ColorBAlpha6_g485 = _ColorB.a;
				float ColorCAlpha9_g485 = _ColorC.a;
				float4 lerpResult18_g485 = lerp( _ColorC , lerpResult21_g485 , ( temp_output_17_0_g485 + ( 0.45 + ( ColorBAlpha6_g485 * 0.3 ) + ( ColorCAlpha9_g485 * -0.3 ) ) ));
				float3 InputRGB30_g485 = temp_output_27_0_g485;
				float4 lerpResult36_g485 = lerp( lerpResult18_g485 , float4( InputRGB30_g485 , 0.0 ) , _UseOriginColor);
				float4 temp_output_695_0 = lerpResult36_g485;
				float4 lerpResult672 = lerp( float4( 0.5,0.5,0.5,0 ) , tex2D( _MatcapTex, ( ( (mul( UNITY_MATRIX_V, float4( ase_worldNormal , 0.0 ) ).xyz).xy * 0.5 ) + 0.5 ) ) , _MatCapTexIntensity);
				float4 blendOpSrc673 = temp_output_695_0;
				float4 blendOpDest673 = lerpResult672;
				float4 switchResult757 = (((ase_vface>0)?(( saturate( (( blendOpDest673 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest673 ) * ( 1.0 - blendOpSrc673 ) ) : ( 2.0 * blendOpDest673 * blendOpSrc673 ) ) ))):(temp_output_695_0)));
				float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - WorldPosition );
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 lerpResult22_g509 = lerp( -ase_worldNormal , ase_worldNormal , ase_vface);
				float fresnelNdotV2_g509 = dot( lerpResult22_g509, ase_worldViewDir );
				float fresnelNode2_g509 = ( _Bias + _Scale * pow( 1.0 - fresnelNdotV2_g509, _Power ) );
				float temp_output_5_0_g509 = saturate( fresnelNode2_g509 );
				#ifdef _INVERTFRESNEL_ON
				float staticSwitch13_g509 = ( 1.0 - temp_output_5_0_g509 );
				#else
				float staticSwitch13_g509 = temp_output_5_0_g509;
				#endif
				float4 temp_cast_14 = (staticSwitch13_g509).xxxx;
				float div12_g509=256.0/float((int)_PosterizeStage);
				float4 posterize12_g509 = ( floor( temp_cast_14 * div12_g509 ) / div12_g509 );
				float4 lerpResult16_g509 = lerp( float4( switchResult757.rgb , 0.0 ) , ( _FresnalColor * 1.0 ) , ( _FresnalColor.a * posterize12_g509 ));
				float4 ClipEdgeColor685 = _EdgeColor;
				float clampResult102_g487 = clamp( ( temp_output_72_0_g487 + EdgeWidth95_g487 ) , -3.0 , 2.0 );
				float EgdeSmoothFixValue100_g487 = ( EdgeSmooth57_g487 * -0.2 );
				float smoothstepResult47_g487 = smoothstep( ( clampResult102_g487 + EgdeSmoothFixValue100_g487 ) , ( clampResult102_g487 + EdgeSmooth57_g487 + EgdeSmoothFixValue100_g487 ) , ClipTex89_g487);
				float ClipEdgeAlpha686 = ( ( 1.0 - smoothstepResult47_g487 ) * _EdgeColor.a );
				float4 lerpResult486 = lerp( lerpResult16_g509 , ClipEdgeColor685 , ClipEdgeAlpha686);
				
#ifdef DISCARD_FRAGMENT
				float DiscardValue = ( staticSwitch762 * ClipAlpha687 );
				float DiscardThreshold = 0.001;

				if(DiscardValue < DiscardThreshold)discard;
#endif
				float3 BakedAlbedo = 0;
				float3 BakedEmission = 0;
				float3 Color = ( switchResult691 * lerpResult486 * IN.ase_color ).rgb;
				float Alpha = 1;
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
					Color.rgb = lerp(Color.rgb, unity_FogColor.rgb, IN.fogFactor * unity_FogColor.a);
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
	CustomEditor "UnityEditor.ShaderGraphUnlitGUI"
	Fallback "Hidden/InternalErrorShader"
	
}
/*ASEBEGIN
Version=18935
597;364;1500;861;-2928.252;1103.51;2.047543;True;True
Node;AmplifyShaderEditor.CommentaryNode;728;-2539.809,-2160.646;Inherit;False;1176.008;1018.177;Comment;22;646;648;647;658;649;650;651;652;719;726;725;724;727;721;720;655;656;654;723;722;653;718;Flow Speed;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;646;-2335.487,-2109.736;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;648;-2489.809,-1922.248;Inherit;False;312.3809;240.363;Comment;1;657;_FlowSpeedA;0.3884525,0,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;647;-2148.264,-2110.646;Inherit;False;Time;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;658;-2144.535,-2030.843;Inherit;False;647;Time;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;657;-2441.523,-1874.963;Inherit;False;Property;_FlowSpeedClipTwist;FlowSpeed Clip Twist ;43;1;[Header];Create;True;1;Flow Speed;0;0;False;0;False;0,0,0,0;0,0,0.5,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;615;-2304.455,339.6488;Inherit;False;2992.559;931.6306;Comment;18;645;644;643;641;640;639;636;632;631;628;627;626;623;620;618;616;624;732;Twist;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;650;-1866.239,-1720.607;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;649;-1870.282,-1818.636;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;652;-1709.818,-1724.133;Inherit;False;FlowSpeed_Twist_V;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;651;-1708.37,-1817.487;Inherit;False;FlowSpeed_Twist_U;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;616;-2268.755,553.1368;Inherit;False;402.4792;206.6982;Comment;3;625;622;621;TimeFlow;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;622;-2237.31,673.9279;Inherit;False;652;FlowSpeed_Twist_V;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;621;-2238.627,595.9769;Inherit;False;651;FlowSpeed_Twist_U;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureTransformNode;623;-2048.908,436.6718;Inherit;False;641;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.CommentaryNode;576;-915.4239,-2570.447;Inherit;False;1532.237;674.33;ParticleSyatem CustomDate;14;517;519;518;520;510;511;508;506;507;505;509;589;591;613;;0.4858491,1,0.5259343,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;625;-1992.439,651.1669;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;627;-1818.068,411.4868;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;626;-1796.143,631.7828;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;628;-1515.371,598.1878;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexCoordVertexDataNode;613;-874.288,-2470.98;Inherit;True;1;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;618;-1977.994,948.3951;Inherit;False;645.9224;212.4607;Comment;2;635;633; For Paricle Sprite Sheet;1,1,1,1;0;0
Node;AmplifyShaderEditor.IntNode;591;-601.5125,-2155.46;Inherit;False;Constant;_Int1;Int 1;16;0;Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.StaticSwitch;517;-408.3393,-2154.704;Inherit;False;Property;_Keyword0;Keyword 0;56;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;511;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;632;-1617.829,389.6488;Inherit;False;VFX_Polar;-1;;473;dc3bcb6ec7e9c4241baaa261038f5919;0;4;69;FLOAT2;0,0;False;65;FLOAT;3;False;66;FLOAT;1;False;34;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureTransformNode;633;-1927.994,998.395;Inherit;False;641;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SimpleAddOpNode;631;-1297.979,607.5688;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;519;-166.3424,-2154.46;Inherit;False;DataZ1;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;636;-1135.708,432.0007;Inherit;False;Property;_TwistTexUsePolarUV;TwistTex Use Polar UV;36;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;635;-1694.068,1001.856;Inherit;False;VFX_PatrcleCenterUV;-1;;474;4e9e805f544695843b53ac34f69b5e40;0;3;7;FLOAT2;1,1;False;8;FLOAT2;0,0;False;10;FLOAT2;1,1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;620;-322.8474,827.0289;Inherit;False;219.1673;138.9515;Comment;1;638;_DataZ1;0.4952259,0,1,1;0;0
Node;AmplifyShaderEditor.StaticSwitch;639;-906.7188,923.069;Inherit;False;Property;_UsePatricleCenterUV;Use Patricle Center UV;37;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;638;-281.6694,867.5399;Inherit;False;519;DataZ1;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;641;-394.4255,595.7269;Inherit;True;Property;_TwistTex;TwistTex;35;2;[Header];[Normal];Create;True;1;Twist;0;0;False;0;False;-1;53b415222112ea94e960e1c7d7e05dc3;53b415222112ea94e960e1c7d7e05dc3;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;640;-103.4205,674.8239;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;733;-915.6479,-1840.122;Inherit;False;1532.237;674.33;ParticleSyatem CustomDate;14;747;746;745;744;743;742;741;740;739;738;737;736;735;734;;0.4858491,1,0.5259343,1;0;0
Node;AmplifyShaderEditor.FunctionNode;643;-24.1666,598.9049;Inherit;False;VFX_Twist;38;;477;84c8764698f118d4889e2fe2f9fd6acd;0;3;12;FLOAT3;0,0,0;False;49;FLOAT;0;False;56;FLOAT2;0,0;False;2;FLOAT2;0;FLOAT;54
Node;AmplifyShaderEditor.CommentaryNode;568;-1931.087,-216.2886;Inherit;False;186;128;Data;1;523;Make Random Rotation MatCap By Customdata;0.4009434,1,0.6175824,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;717;-2115.5,-435.6792;Inherit;False;350;166;Comment;1;467;Y2;1,0,0,1;0;0
Node;AmplifyShaderEditor.IntNode;734;-630.7366,-1425.135;Inherit;False;Constant;_Int2;Int 2;16;0;Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;644;447.1044,597.8918;Inherit;False;TwistOutputedUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;735;-883.6897,-1740.655;Inherit;True;2;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;410;-1787.594,-935.1348;Inherit;False;VFX_MatCapUV;-1;;478;de666f160bf14ab4ea5b6d6d91e23e45;0;0;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;467;-2065.5,-385.6792;Half;False;Property;_ClipTexARotation;ClipTexA Rotation;25;0;Create;True;0;0;0;False;0;False;0;4.88;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;709;-1480.751,-335.4219;Inherit;False;0;422;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;523;-1909.087,-173.2886;Inherit;False;519;DataZ1;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;736;-413.3757,-1446.837;Inherit;False;Property;_Keyword0;Keyword 0;56;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;511;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;611;-1876.029,-686.3145;Inherit;False;Constant;_Vector0;Vector 0;19;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureTransformNode;609;-1919.13,-552.9145;Inherit;False;411;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.GetLocalVarNode;698;-1865.932,-820.5504;Inherit;False;644;TwistOutputedUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;522;-1683.219,-431.1887;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;699;-1566.473,-720.3323;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;737;-163.3582,-1446.593;Inherit;False;DataZ2;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;715;-1287.468,33.52464;Inherit;False;350;166;Comment;1;711;Z2;1,0,0,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;701;-1437.356,-903.2317;Inherit;False;0;411;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;422;-1250.18,-359.6882;Inherit;True;Property;_ClipTexB;ClipTex B;33;1;[Header];Create;True;1;ClipTex B;0;0;False;0;False;-1;67de55b069370c742b5483227026a041;3313b5d760a88c0499a0a3306d53c25b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;610;-1669.029,-548.3145;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;711;-1237.468,83.52464;Inherit;False;Property;_ClipTexBBlendA;ClipTexB Blend A;34;0;Create;True;0;0;0;False;0;False;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;712;-944.1509,-331.8599;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;748;-1091.063,-51.50313;Inherit;False;737;DataZ2;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;464;-1407.559,-561.5378;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;702;-1164.952,-835.9639;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.IntNode;589;-618.4129,-2518.16;Inherit;False;Constant;_Int0;Int 0;16;0;Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.StaticSwitch;700;-1034.497,-597.3159;Inherit;False;Property;_ClipTexUV_MatCap;ClipTexUV_MatCap;24;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;716;-656.7146,-266.9694;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;754;-844.3851,-1.101013;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;511;-430.9679,-2315.539;Inherit;False;Property;_UseCustomData;Use CustomData;56;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;714;-457.9509,-332.2598;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;411;-704.7316,-622.1545;Inherit;True;Property;_ClipTexA;ClipTex A;23;1;[Header];Create;True;1;ClipA MatCap;0;0;False;0;False;-1;9c0e9060fddbb9245b7123b85eb50997;64a82c8425a2309409962fa04d1af31f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;669;1788.671,-1080.312;Inherit;False;VFX_MatCapUV;-1;;480;de666f160bf14ab4ea5b6d6d91e23e45;0;0;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;718;-2451.089,-1607.569;Inherit;False;Property;_FlowSpeedMainTexVertexOffset;FlowSpeed MainTex VertexOffset;44;1;[Header];Create;True;1;Flow Speed;0;0;False;0;False;0,0,0,0;0,0,-0.2,-0.3;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;719;-2119.774,-1642.965;Inherit;False;647;Time;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;671;2013.528,-890.5839;Inherit;False;Property;_MatCapTexIntensity;MatCapTex Intensity;21;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;569;-616.9747,-799.9838;Inherit;False;226.4901;128.9802;Data;1;521;Data Y1;1,0.009225906,0,1;0;0
Node;AmplifyShaderEditor.SamplerNode;670;2001.107,-1108.618;Inherit;True;Property;_MatcapTex;MatcapTex;22;0;Create;True;0;0;0;False;0;False;-1;2db1ad595836c194fab5e08f7ce3c814;2b1094c4ee13321458a0be0e42e7bae0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;382;1085.372,-732.1473;Inherit;True;Property;_MainTex;MainTex;2;1;[Header];Create;True;1;MainTex;0;0;False;0;False;-1;67de55b069370c742b5483227026a041;3313b5d760a88c0499a0a3306d53c25b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;507;-165.4812,-2291.648;Inherit;False;DataY1;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;713;-289.9509,-459.2598;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;725;-1812.222,-1277.468;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;726;-1816.265,-1375.497;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;521;-579.8904,-762.9047;Inherit;False;507;DataY1;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;672;2339.622,-1121.263;Inherit;False;3;0;COLOR;0.5,0.5,0.5,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;542;-120.2872,-550.1951;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;518;-441.0321,-2040.685;Inherit;False;Property;_UseCustomData;UseCustomData;56;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Reference;511;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;724;-1656.353,-1378.348;Inherit;False;FlowSpeed_VertexOffset_U;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;727;-1655.801,-1280.994;Inherit;False;FlowSpeed_VertexOffset_V;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;695;1413.246,-726.4902;Inherit;False;VFX_GraytoColor Gradient;3;;485;4dca6182a64a98847bdebf99782433f1;0;1;27;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;488;3360.943,-349.8459;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;673;2363.633,-800.8716;Inherit;True;Overlay;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;683;87.66069,-577.9552;Inherit;False;VFX_ClipSmoothEdge;26;;487;69e070d297569514d918f7319aa4d435;0;3;62;FLOAT;0;False;24;FLOAT;0;False;87;FLOAT;1;False;4;FLOAT;22;FLOAT;28;COLOR;32;FLOAT;124
Node;AmplifyShaderEditor.CommentaryNode;696;2932.011,-1171.128;Inherit;False;714.2869;435.5011;Comment;4;592;678;692;691;TwoSideColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;664;3256.589,333.5614;Inherit;False;727;FlowSpeed_VertexOffset_V;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;663;3257.749,259.5764;Inherit;False;724;FlowSpeed_VertexOffset_U;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;520;-158.5322,-2036.213;Inherit;False;DataW1;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;731;3489.63,128.0188;Inherit;False;245;166;Comment;1;662;W1;1,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;682;2720.544,-414.1893;Inherit;False;610.2621;433.1005;Comment;2;689;501;ClipEdge;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;662;3539.63,178.0188;Inherit;False;520;DataW1;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;592;2982.649,-947.627;Inherit;False;Property;_TintColor;TintColor;0;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;1.286275,5.992157,0.1254902,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;686;424.3835,-545.2738;Inherit;True;ClipEdgeAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;678;2982.011,-1121.128;Inherit;False;Property;_BackFaceColor;BackFaceColor;1;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;0.3297004,1.184686,0.3297004,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;680;3593.886,-328.9898;Inherit;False;VertexAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;501;2802.862,-207.0349;Inherit;False;218.1572;138.9794;Comment;1;493;EdgeClipAlpha;1,0.4310504,0.03301889,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;685;436.9848,-456.6514;Inherit;False;ClipEdgeColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;661;3580.725,287.3946;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwitchByFaceNode;757;2690.92,-614.7196;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;687;425.1996,-627.9658;Inherit;False;ClipAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;493;2824.04,-157.035;Inherit;False;686;ClipEdgeAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;689;2814.233,-353.3112;Inherit;False;685;ClipEdgeColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;692;3240.288,-1068.863;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;500;3918.942,-917.0421;Inherit;False;236.1753;136.5808;Comment;1;498;ClipAlpha;1,0.2783019,0.2783019,1;0;0
Node;AmplifyShaderEditor.FunctionNode;693;3008.613,-637.6008;Inherit;False;VFX_Fresnel;14;;509;7bcd008f7aac81e4cba75f3fea21ab64;0;2;1;FLOAT3;0,0,0;False;18;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;756;3818.996,187.0866;Inherit;False;VFX_VertexOffset;45;;507;47bca5503be245c4783b3c6edf42a04a;0;3;40;FLOAT;1;False;36;FLOAT2;0,0;False;39;FLOAT3;1,1,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;763;3962.358,-1015.387;Inherit;False;Constant;_Float6;Float 6;26;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;681;3941.04,-1113.954;Inherit;False;680;VertexAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;760;3924.991,323.8804;Inherit;False;680;VertexAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;486;3464.997,-657.5956;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;762;4162.358,-1082.387;Inherit;False;Property;_Keyword1;Keyword 1;55;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;758;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwitchByFaceNode;691;3438.298,-945.8943;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;498;3966.417,-869.8772;Inherit;False;687;ClipAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;761;4128.588,308.6107;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;607;-2628.344,-2638.104;Inherit;False;292;132;Comment;1;608;Shader Options;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;505;392.8139,-2513.059;Inherit;False;DataX1;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;721;-1819.106,-1476.567;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;739;-424.7754,-1585.214;Inherit;False;Property;_UseCustomData;Use CustomData;58;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Reference;511;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;744;-125.8289,-1778.169;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;723;-1629.132,-1588.828;Inherit;False;FlowSpeed_Main_U;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;496;4377.095,-890.9281;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;624;-1558.32,805.798;Inherit;False;-1;;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;510;-432.2627,-2524.826;Inherit;False;Property;_Keyword0;Keyword 0;24;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;511;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;741;-441.2562,-1310.36;Inherit;False;Property;_UseCustomData;UseCustomData;59;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Reference;511;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;722;-1638.018,-1515.06;Inherit;False;FlowSpeed_Main_V;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;740;-168.9135,-1583.781;Inherit;False;DataY2;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;654;-1871.535,-2018.8;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;506;50.85343,-2513.987;Inherit;False;Property;_DataX1MainTexFlowUorV;DataX1 MainTex Flow U or V;57;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.IntNode;738;-618.637,-1787.835;Inherit;False;Constant;_Int3;Int 3;16;0;Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;655;-1729.742,-2024.382;Inherit;False;FlowSpeed_Clip_U;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;605;4150.53,-717.046;Inherit;False;Constant;_Float10;Float 10;45;0;Create;True;0;0;0;False;0;False;0.001;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;746;-140.2753,-1653.988;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;745;392.5899,-1782.734;Inherit;False;DataX2;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;656;-1725.625,-1923.526;Inherit;False;FlowSpeed_Clip_V;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;720;-1817.518,-1575.661;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;743;51.62936,-1783.662;Inherit;False;Property;_DataX2TwistFlowUorV;DataX2 Twist Flow U or V;58;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;608;-2609.344,-2592.104;Inherit;False;Property;_CullMode;Cull Mode;59;2;[Header];[Enum];Create;True;1;Shader Options;2;CullBack;2;CullOff;0;1;UnityEngine.Rendering.CullMode;True;0;False;2;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;508;-125.6048,-2508.494;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;759;3679.654,-412.1328;Inherit;False;Constant;_Float5;Float 5;26;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;489;3832.207,-671.3468;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;509;-122.406,-2401.958;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;742;-158.7562,-1305.888;Inherit;False;DataW2;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;758;4256.858,147.6974;Inherit;False;Property;_UseVertexAlphaMaskOffset;Use Vertex Alpha Mask Offset;55;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;747;-430.4868,-1794.501;Inherit;False;Property;_Keyword0;Keyword 0;24;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;511;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;653;-1873.123,-1919.706;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;645;453.0234,689.4388;Inherit;False;TwistMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;597;4234.596,-389.4315;Float;False;False;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;1;New Amplify Shader;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;FullScreenPass;0;1;FullScreenPass;4;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;7;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=UniversalForwardOnly;True;2;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;598;4234.596,-389.4315;Float;False;False;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;1;New Amplify Shader;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;ExtraPrePass;0;2;ExtraPrePass;6;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;0;False;False;0;Hidden/InternalErrorShader;0;0;Standard;1;MRT Output;0;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;596;4234.596,-389.4315;Float;False;False;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;1;New Amplify Shader;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;AdditionalPass;0;0;AdditionalPass;6;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;0;False;False;0;Hidden/InternalErrorShader;0;0;Standard;1;MRT Output;0;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;603;4234.596,-389.4315;Float;False;False;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;1;New Amplify Shader;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;Meta;0;7;Meta;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;600;4234.596,-389.4315;Float;False;False;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;1;New Amplify Shader;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;ShadowCaster;0;4;ShadowCaster;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;599;4543.729,-451.8986;Float;False;True;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;21;ASE/VFX/FresnalMatCapClipExplosion;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;Forward;0;3;Forward;12;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;0;True;608;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;True;1;1;False;-1;0;False;-1;1;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=UniversalForward;False;False;0;Hidden/InternalErrorShader;0;0;Standard;18;Surface;0;0;  Blend;0;0;Two Sided;1;0;Cast Shadows;0;637971223676819448;  Use Shadow Threshold;0;0;Receive Shadows;1;0;GPU Instancing;1;0;LOD CrossFade;0;0;Treeverse Linear Fog;0;0;DOTS Instancing;0;0;Meta Pass;0;0;Extra Pre Pass;0;0;Full Screen Pass;0;0;Additional Pass;0;0;Scene Selectioin Pass;0;0;Vertex Position,InvertActionOnDeselection;1;0;Discard Fragment;1;637971223718528944;Push SelfShadow to Main Light;0;0;2;MRT Output;0;0;Custom Output Position;0;0;8;False;False;False;True;False;False;False;False;False;;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;602;4234.596,-389.4315;Float;False;False;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;1;New Amplify Shader;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;SceneSelectionPass;0;6;SceneSelectionPass;5;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=SceneSelectionPass;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;601;4234.596,-389.4315;Float;False;False;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;1;New Amplify Shader;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;DepthOnly;0;5;DepthOnly;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;False;False;True;False;False;False;False;0;False;-1;False;False;False;False;False;False;False;False;False;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.CommentaryNode;732;-1608.32,755.798;Inherit;False;245;161;Comment;0;X2;1,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;730;3489.194,464.0389;Inherit;False;245.3916;163.8304;Comment;0;W2;1,0,0,1;0;0
WireConnection;647;0;646;0
WireConnection;650;0;658;0
WireConnection;650;1;657;4
WireConnection;649;0;658;0
WireConnection;649;1;657;3
WireConnection;652;0;650;0
WireConnection;651;0;649;0
WireConnection;625;0;621;0
WireConnection;625;1;622;0
WireConnection;627;0;623;0
WireConnection;626;0;625;0
WireConnection;517;1;591;0
WireConnection;517;0;613;3
WireConnection;632;69;626;0
WireConnection;632;65;627;0
WireConnection;632;66;627;1
WireConnection;632;34;623;1
WireConnection;631;0;628;0
WireConnection;631;1;626;0
WireConnection;519;0;517;0
WireConnection;636;1;631;0
WireConnection;636;0;632;0
WireConnection;635;7;633;0
WireConnection;635;8;633;1
WireConnection;635;10;626;0
WireConnection;639;1;636;0
WireConnection;639;0;635;0
WireConnection;641;1;639;0
WireConnection;640;0;638;0
WireConnection;643;12;641;0
WireConnection;643;49;640;0
WireConnection;644;0;643;0
WireConnection;736;1;734;0
WireConnection;736;0;735;3
WireConnection;522;0;467;0
WireConnection;522;1;523;0
WireConnection;699;0;410;0
WireConnection;699;1;698;0
WireConnection;737;0;736;0
WireConnection;422;1;709;0
WireConnection;610;0;611;0
WireConnection;610;1;609;1
WireConnection;712;0;422;1
WireConnection;464;0;699;0
WireConnection;464;1;610;0
WireConnection;464;2;522;0
WireConnection;702;0;701;0
WireConnection;702;1;698;0
WireConnection;700;1;702;0
WireConnection;700;0;464;0
WireConnection;716;0;712;0
WireConnection;754;0;748;0
WireConnection;754;1;711;0
WireConnection;511;1;589;0
WireConnection;511;0;613;2
WireConnection;714;0;716;0
WireConnection;714;1;754;0
WireConnection;411;1;700;0
WireConnection;670;1;669;0
WireConnection;507;0;511;0
WireConnection;713;0;411;1
WireConnection;713;1;714;0
WireConnection;725;0;719;0
WireConnection;725;1;718;4
WireConnection;726;0;719;0
WireConnection;726;1;718;3
WireConnection;672;1;670;0
WireConnection;672;2;671;0
WireConnection;542;0;713;0
WireConnection;518;1;591;0
WireConnection;518;0;613;4
WireConnection;724;0;726;0
WireConnection;727;0;725;0
WireConnection;695;27;382;0
WireConnection;673;0;695;0
WireConnection;673;1;672;0
WireConnection;683;62;521;0
WireConnection;683;24;542;0
WireConnection;520;0;518;0
WireConnection;686;0;683;28
WireConnection;680;0;488;4
WireConnection;685;0;683;32
WireConnection;661;0;663;0
WireConnection;661;1;664;0
WireConnection;757;0;673;0
WireConnection;757;1;695;0
WireConnection;687;0;683;22
WireConnection;692;0;592;0
WireConnection;692;1;678;0
WireConnection;692;2;678;4
WireConnection;693;1;757;0
WireConnection;756;40;662;0
WireConnection;756;36;661;0
WireConnection;486;0;693;0
WireConnection;486;1;689;0
WireConnection;486;2;493;0
WireConnection;762;1;681;0
WireConnection;762;0;763;0
WireConnection;691;0;592;0
WireConnection;691;1;692;0
WireConnection;761;0;756;0
WireConnection;761;1;760;0
WireConnection;505;0;506;0
WireConnection;721;0;719;0
WireConnection;721;1;718;2
WireConnection;739;1;738;0
WireConnection;739;0;735;2
WireConnection;744;0;747;0
WireConnection;723;0;720;0
WireConnection;496;0;762;0
WireConnection;496;1;498;0
WireConnection;510;1;589;0
WireConnection;510;0;613;1
WireConnection;741;1;734;0
WireConnection;741;0;735;4
WireConnection;722;0;721;0
WireConnection;740;0;739;0
WireConnection;654;0;658;0
WireConnection;654;1;657;1
WireConnection;506;1;508;0
WireConnection;506;0;509;0
WireConnection;655;0;654;0
WireConnection;746;1;747;0
WireConnection;745;0;743;0
WireConnection;656;0;653;0
WireConnection;720;0;719;0
WireConnection;720;1;718;1
WireConnection;743;1;744;0
WireConnection;743;0;746;0
WireConnection;508;0;510;0
WireConnection;489;0;691;0
WireConnection;489;1;486;0
WireConnection;489;2;488;0
WireConnection;509;1;510;0
WireConnection;742;0;741;0
WireConnection;758;1;756;0
WireConnection;758;0;761;0
WireConnection;747;1;738;0
WireConnection;747;0;735;1
WireConnection;653;0;658;0
WireConnection;653;1;657;2
WireConnection;645;0;643;54
WireConnection;599;21;496;0
WireConnection;599;22;605;0
WireConnection;599;2;489;0
WireConnection;599;5;758;0
ASEEND*/
//CHKSM=1D22B2269C6425088E8B31CDC77C797A79154D2D