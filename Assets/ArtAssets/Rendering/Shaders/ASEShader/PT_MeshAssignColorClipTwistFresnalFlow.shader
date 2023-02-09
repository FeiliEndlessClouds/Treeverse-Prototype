// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/VFX/PT_MeshAssignColorClipTwistFresnalFlow"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[HDR][Header(MainTex)]_TintColor("TintColor", Color) = (1,1,1,1)
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
		[HDR][Header(Fresnel)]_FresnalColor("FresnalColor", Color) = (1,1,1,1)
		_Bias("Bias", Range( -1 , 1)) = 1
		_Scale("Scale", Range( 0 , 10)) = 1
		_Power("Power", Range( 0 , 10)) = 10
		_PosterizeStage("PosterizeStage", Range( 1 , 256)) = 128
		[Toggle(_INVERTFRESNEL_ON)] _InvertFresnel("Invert Fresnel", Float) = 0
		_MainTexTwisStage("MainTex Twis Stage", Range( 0 , 1)) = 1
		[HDR][Header(FlowTex)]_FlowColor("FlowColor", Color) = (1,1,1,1)
		_FlowTex("FlowTex", 2D) = "white" {}
		[Toggle]_FlowTexUsePositionUV("FlowTex Use Position UV", Float) = 0
		_FlowTexTwisStage("FlowTex Twis Stage", Range( 0 , 1)) = 0
		[Header(Flow BlackClip)]_FlowTexBlackClipII("FlowTex BlackClip", Range( 0 , 1)) = 0.5
		[Toggle]_FlowTexUseAlpha("FlowTex Use Alpha ", Float) = 0
		[Header(Flow AssignColor)]_FlowTexColorA("FlowTex Color A", Color) = (1,1,1,0)
		_FlowTexColorB("FlowTex Color B", Color) = (0.9960854,1,0.5235849,0)
		_FlowTexColorC("FlowTex Color C", Color) = (1,0.6265537,0.08018869,0)
		[Toggle]_FlowTexUseOriginColor("Flow Tex Use OriginColor", Float) = 0
		[Header(Clip)]_ClipTex("ClipTex", 2D) = "white" {}
		_ClipTexTwisStage("ClipTex Twis Stage", Range( 0 , 1)) = 0
		[Toggle]_ClipTexUseWorldUV("ClipTex Use World UV", Float) = 0
		[Toggle]_InvertClipTex("Invert ClipTex", Float) = 0
		[Toggle]_ClipNullAlpha("Clip Null Alpha", Float) = 0
		_ClipStage("ClipStage", Range( 0 , 1)) = 0
		[HDR]_EdgeColor("EdgeColor", Color) = (1,1,1,1)
		_EdgeWidth("EdgeWidth", Range( 0 , 1)) = 0.1
		_EdgeSmooth("EdgeSmooth", Range( 0 , 2)) = 0.1
		[Toggle]_ClipFlowFollowMainTex("ClipFlow Follow MainTex", Float) = 0
		[Toggle]_ClipEdgeBlendMainTex("ClipEdge Blend MainTex", Float) = 0
		[Toggle]_MaskBlendClipTex("Mask Blend ClipTex", Range( 0 , 1)) = 0
		[Header(Twist)][Normal]_TwistTex("TwistTex", 2D) = "bump" {}
		[Toggle]_TwistUsePositionUV("Twist Use Position UV", Float) = 0
		_TwistStage("TwistStage", Range( -2 , 2)) = 0.1
		[Header(TwistMask)][Toggle]_UseTwistMask("Use TwistMask", Float) = 0
		_TwistMaskTex("TwistMaskTex", 2D) = "white" {}
		[Toggle]_InvertTwistMskTex("InvertTwistMskTex", Float) = 0
		_FlowSpeedClipTwist("FlowSpeed Clip Twist ", Vector) = (0,0,0,0)
		_FlowSpeedMainFlowTex("FlowSpeed Main FlowTex", Vector) = (0,0,0,0)
		[Toggle]_MaskNullAlpha("Mask Null Alpha", Float) = 0
		[Header(Mask)]_MaskTex("MaskTex", 2D) = "white" {}
		[Toggle]_InvertMask("Invert Mask", Float) = 0
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
		[Toggle]_DataY1("DataY1 Use ClipStage", Range( 0 , 1)) = 0
		[Toggle]_DataZ1("DataZ1 Use Twist Stage", Float) = 0
		[Toggle]_DataX2("DataX2 ClipTex Flow U or V", Float) = 0
		[Toggle]_DataY2("DataY2 TwistTex Flow U or V", Float) = 0
		[Toggle]_DataZ2("DataZ2 TwistTex Flow U or V", Float) = 0
		[Header(Shader Options)][Enum(UnityEngine.Rendering.CullMode)]_CullMode("Cull Mode", Range( 0 , 2)) = 2
		[Enum(Off,0,On,1)]_ZWriteMode("Z Write Mode", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)]_ZTestMode("Z Test Mode", Float) = 4
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
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_COLOR
			#pragma shader_feature_local _USEVERTEXOFFSET_ON
			#pragma shader_feature_local _USETRIPLANARSAMPLER_ON
			#pragma shader_feature_local _INVERTFRESNEL_ON


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord1 : TEXCOORD1;
				half4 ase_color : COLOR;
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
				float4 ase_color : COLOR;
				float4 ase_texcoord6 : TEXCOORD6;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)

			half4 _ClipTex_ST;
			half4 _EdgeColor;
			half4 _TintColor;
			half4 _FlowColor;
			half4 _FlowSpeedMainFlowTex;
			half4 _TwistMaskTex_ST;
			half4 _FlowTexColorC;
			half4 _FlowTexColorB;
			half4 _FlowTexColorA;
			half4 _FlowTex_ST;
			half4 _FlowSpeedClipTwist;
			half4 _MainTex_ST;
			half4 _ColorA;
			half4 _ColorB;
			half4 _TwistTex_ST;
			half4 _MaskTex_ST;
			half4 _FresnalColor;
			half4 _VertexOffsetTex_ST;
			half4 _ColorC;
			half _FlowTexUsePositionUV;
			half _UseAlpha;
			half _ClipEdgeBlendMainTex;
			half _GradientBlendIntensity;
			half _GradientUVOffset;
			half _GradientUorV;
			half _InvertGradient;
			half _UseGradient;
			half _UseOriginColor;
			half _Scale;
			half _Power;
			half _Bias;
			half _PosterizeStage;
			half _FlowTexUseAlpha;
			half _FlowTexBlackClipII;
			half _InvertClipTex;
			half _FlowTexTwisStage;
			half _FlowTexUseOriginColor;
			half _BlackClip;
			half _MaskBlendClipTex;
			half _CullMode;
			half _ClipTexUseWorldUV;
			half _ZWriteMode;
			half _ZTestMode;
			half _VertexOffsetPushorPull;
			half _VertexOffsetScale;
			half _VertexOffset;
			half _UseCustomData;
			half _DataZ2;
			half _VertexOffsetUsePositionUV;
			half _TriUVWorldPosition;
			half _InvertMask;
			half _VertexOffsetUseMaskTex;
			half _MainTexTwisStage;
			half _DataY2;
			half _TwistUsePositionUV;
			half _TwistStage;
			half _DataZ1;
			half _InvertTwistMskTex;
			half _UseTwistMask;
			half _DataX1;
			half _ClipStage;
			half _DataY1;
			half _EdgeWidth;
			half _EdgeSmooth;
			half _ClipNullAlpha;
			half _ClipTexTwisStage;
			half _ClipFlowFollowMainTex;
			half _DataX2;
			half _MaskBlendStage;
			half _MaskNullAlpha;
			CBUFFER_END
			sampler2D _VertexOffsetTex;
			sampler2D _MaskTex;
			sampler2D _MainTex;
			sampler2D _TwistTex;
			sampler2D _TwistMaskTex;
			sampler2D _ClipTex;
			sampler2D _FlowTex;


			inline float4 TriplanarSampling45_g407( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
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

				half lerpResult29_g407 = lerp( 1.0 , -1.0 , _VertexOffsetPushorPull);
				half2 uv_VertexOffsetTex = v.ase_texcoord.xy * _VertexOffsetTex_ST.xy + _VertexOffsetTex_ST.zw;
				half UseCustomData633 = _UseCustomData;
				half lerpResult846 = lerp( 0.0 , v.ase_texcoord2.z , UseCustomData633);
				half2 appendResult851 = (half2(lerpResult846 , 0.0));
				half2 appendResult850 = (half2(0.0 , lerpResult846));
				half2 lerpResult849 = lerp( appendResult851 , appendResult850 , _DataZ2);
				half2 DataZ2VertexoffsetTexFlow853 = lerpResult849;
				half2 temp_output_36_0_g407 = DataZ2VertexoffsetTexFlow853;
				float3 ase_worldPos = mul(GetObjectToWorldMatrix(), v.vertex).xyz;
				half3 objToWorld50_g408 = mul( GetObjectToWorldMatrix(), float4( float3( 0,0,0 ), 1 ) ).xyz;
				half2 appendResult55_g408 = (half2(( ( ase_worldPos.x - v.ase_texcoord3.x ) - objToWorld50_g408.x ) , ( ( ase_worldPos.y - v.ase_texcoord3.y ) - objToWorld50_g408.y )));
				half2 lerpResult17_g407 = lerp( ( uv_VertexOffsetTex + temp_output_36_0_g407 ) , ( temp_output_36_0_g407 + (appendResult55_g408*_VertexOffsetTex_ST.xy + _VertexOffsetTex_ST.zw) ) , _VertexOffsetUsePositionUV);
				half3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				half3 temp_cast_1 = (_TriUVWorldPosition).xxx;
				float4 triplanar45_g407 = TriplanarSampling45_g407( _VertexOffsetTex, temp_cast_1, ase_worldNormal, _VertexOffsetTex_ST.zw.x, _VertexOffsetTex_ST.xy, 1.0, 0 );
				#ifdef _USETRIPLANARSAMPLER_ON
				half staticSwitch50_g407 = triplanar45_g407.x;
				#else
				half staticSwitch50_g407 = tex2Dlod( _VertexOffsetTex, float4( lerpResult17_g407, 0, 0.0) ).r;
				#endif
				half3 temp_cast_2 = (( _VertexOffset + staticSwitch50_g407 )).xxx;
				float2 uv_MaskTex = v.ase_texcoord.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
				half4 tex2DNode3_g389 = tex2Dlod( _MaskTex, float4( uv_MaskTex, 0, 0.0) );
				half lerpResult9_g389 = lerp( tex2DNode3_g389.r , ( 1.0 - tex2DNode3_g389.r ) , _InvertMask);
				half MaskAlpha355 = lerpResult9_g389;
				half3 temp_cast_3 = (MaskAlpha355).xxx;
				half3 lerpResult30_g407 = lerp( temp_cast_2 , ( staticSwitch50_g407 * temp_cast_3 ) , _VertexOffsetUseMaskTex);
				half lerpResult645 = lerp( 0.0 , v.ase_texcoord1.w , UseCustomData633);
				half DataW1239 = lerpResult645;
				#ifdef _USEVERTEXOFFSET_ON
				half3 staticSwitch34_g407 = ( v.ase_normal * lerpResult29_g407 * _VertexOffsetScale * lerpResult30_g407 * DataW1239 );
				#else
				half3 staticSwitch34_g407 = float3( 0,0,0 );
				#endif
				
				o.ase_texcoord6.xyz = ase_worldNormal;
				
				o.ase_texcoord3.xy = v.ase_texcoord.xy;
				o.ase_texcoord4 = v.ase_texcoord2;
				o.ase_texcoord3.zw = v.ase_texcoord3.xy;
				o.ase_texcoord5 = v.ase_texcoord1;
				o.ase_color = v.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord6.w = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = staticSwitch34_g407;
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
				half2 uv_MainTex = IN.ase_texcoord3.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				half2 uv_TwistTex = IN.ase_texcoord3.xy * _TwistTex_ST.xy + _TwistTex_ST.zw;
				half Time437 = _TimeParameters.x;
				half FlowSpeed_Twist_U453 = ( Time437 * _FlowSpeedClipTwist.z );
				half FlowSpeed_Twist_V454 = ( Time437 * _FlowSpeedClipTwist.w );
				half2 appendResult481 = (half2(FlowSpeed_Twist_U453 , FlowSpeed_Twist_V454));
				half UseCustomData633 = _UseCustomData;
				half lerpResult634 = lerp( 0.0 , IN.ase_texcoord4.y , UseCustomData633);
				half2 appendResult508 = (half2(lerpResult634 , 0.0));
				half2 appendResult507 = (half2(0.0 , lerpResult634));
				half2 lerpResult680 = lerp( appendResult508 , appendResult507 , _DataY2);
				half2 DataY2TwistFlow511 = lerpResult680;
				half2 temp_output_512_0 = ( appendResult481 + DataY2TwistFlow511 );
				half3 objToWorld50_g387 = mul( GetObjectToWorldMatrix(), float4( float3( 0,0,0 ), 1 ) ).xyz;
				half2 appendResult55_g387 = (half2(( ( WorldPosition.x - IN.ase_texcoord3.zw.x ) - objToWorld50_g387.x ) , ( ( WorldPosition.y - IN.ase_texcoord3.zw.y ) - objToWorld50_g387.y )));
				half2 lerpResult790 = lerp( ( uv_TwistTex + temp_output_512_0 ) , ( temp_output_512_0 + (appendResult55_g387*_TwistTex_ST.xy + _TwistTex_ST.zw) ) , _TwistUsePositionUV);
				half lerpResult643 = lerp( 0.0 , IN.ase_texcoord5.z , UseCustomData633);
				half DataZ1238 = lerpResult643;
				half lerpResult676 = lerp( 0.0 , DataZ1238 , _DataZ1);
				half2 uv_TwistMaskTex = IN.ase_texcoord3.xy * _TwistMaskTex_ST.xy + _TwistMaskTex_ST.zw;
				half FlowSpeed_Forth_U457 = ( Time437 * _FlowSpeedMainFlowTex.z );
				half FlowSpeed_Forth_V458 = ( Time437 * _FlowSpeedMainFlowTex.w );
				half2 appendResult483 = (half2(FlowSpeed_Forth_U457 , FlowSpeed_Forth_V458));
				half4 tex2DNode52_g388 = tex2D( _TwistMaskTex, ( uv_TwistMaskTex + appendResult483 ) );
				half lerpResult61_g388 = lerp( tex2DNode52_g388.r , ( 1.0 - tex2DNode52_g388.r ) , _InvertTwistMskTex);
				half lerpResult62_g388 = lerp( 1.0 , lerpResult61_g388 , _UseTwistMask);
				half2 TwistOutputedUV323 = ( (UnpackNormalScale( tex2D( _TwistTex, lerpResult790 ), 1.0f )).xy * ( _TwistStage + lerpResult676 ) * lerpResult62_g388 );
				half lerpResult639 = lerp( 0.0 , IN.ase_texcoord5.x , UseCustomData633);
				half2 appendResult218 = (half2(lerpResult639 , 0.0));
				half2 appendResult219 = (half2(0.0 , lerpResult639));
				half2 lerpResult686 = lerp( appendResult218 , appendResult219 , _DataX1);
				half FlowSpeed_Main_U455 = ( Time437 * _FlowSpeedMainFlowTex.x );
				half FlowSpeed_Main_V456 = ( Time437 * _FlowSpeedMainFlowTex.y );
				half2 appendResult471 = (half2(FlowSpeed_Main_U455 , FlowSpeed_Main_V456));
				half4 tex2DNode10 = tex2D( _MainTex, ( uv_MainTex + ( _MainTexTwisStage * TwistOutputedUV323 ) + lerpResult686 + appendResult471 ) );
				half lerpResult641 = lerp( 0.0 , IN.ase_texcoord5.y , UseCustomData633);
				half DataY1223 = lerpResult641;
				half lerpResult648 = lerp( 0.0 , DataY1223 , _DataY1);
				half EdgeWidth95_g391 = _EdgeWidth;
				half EdgeSmooth57_g391 = _EdgeSmooth;
				half temp_output_72_0_g391 = (( ( EdgeWidth95_g391 * -1.1 ) + -0.2 + ( EdgeSmooth57_g391 * -1.0 ) ) + (saturate( ( _ClipStage + lerpResult648 ) ) - 0.0) * (1.1 - ( ( EdgeWidth95_g391 * -1.1 ) + -0.2 + ( EdgeSmooth57_g391 * -1.0 ) )) / (1.0 - 0.0));
				half clampResult102_g391 = clamp( ( temp_output_72_0_g391 + EdgeWidth95_g391 ) , -3.0 , 2.0 );
				half EgdeSmoothFixValue100_g391 = ( EdgeSmooth57_g391 * -0.2 );
				half2 uv_ClipTex = IN.ase_texcoord3.xy * _ClipTex_ST.xy + _ClipTex_ST.zw;
				half2 lerpResult673 = lerp( float2( 0,0 ) , TwistOutputedUV323 , _ClipTexTwisStage);
				half2 MainTexUVFlowByData375 = lerpResult686;
				half2 lerpResult684 = lerp( float2( 0,0 ) , MainTexUVFlowByData375 , _ClipFlowFollowMainTex);
				half lerpResult631 = lerp( 0.0 , IN.ase_texcoord4.x , UseCustomData633);
				half2 appendResult502 = (half2(lerpResult631 , 0.0));
				half2 appendResult503 = (half2(0.0 , lerpResult631));
				half2 lerpResult678 = lerp( appendResult502 , appendResult503 , _DataX2);
				half2 DataX2ClipFlow510 = lerpResult678;
				half FlowSpeed_Clip_U451 = ( Time437 * _FlowSpeedClipTwist.x );
				half FlowSpeed_Clip_V452 = ( Time437 * _FlowSpeedClipTwist.y );
				half2 appendResult525 = (half2(FlowSpeed_Clip_U451 , FlowSpeed_Clip_V452));
				half2 temp_output_378_0 = ( lerpResult673 + lerpResult684 + DataX2ClipFlow510 + appendResult525 );
				half3 objToWorld50_g390 = mul( GetObjectToWorldMatrix(), float4( float3( 0,0,0 ), 1 ) ).xyz;
				half2 appendResult55_g390 = (half2(( ( WorldPosition.x - IN.ase_texcoord3.zw.x ) - objToWorld50_g390.x ) , ( ( WorldPosition.y - IN.ase_texcoord3.zw.y ) - objToWorld50_g390.y )));
				half2 lerpResult797 = lerp( ( uv_ClipTex + temp_output_378_0 ) , ( temp_output_378_0 + (appendResult55_g390*_ClipTex_ST.xy + _ClipTex_ST.zw) ) , _ClipTexUseWorldUV);
				float2 uv_MaskTex = IN.ase_texcoord3.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
				half4 tex2DNode3_g389 = tex2D( _MaskTex, uv_MaskTex );
				half lerpResult9_g389 = lerp( tex2DNode3_g389.r , ( 1.0 - tex2DNode3_g389.r ) , _InvertMask);
				half MaskAlpha355 = lerpResult9_g389;
				half lerpResult654 = lerp( 1.0 , saturate( ( MaskAlpha355 + _MaskBlendStage ) ) , _MaskBlendClipTex);
				half temp_output_122_0_g391 = saturate( ( tex2D( _ClipTex, lerpResult797 ).r * lerpResult654 ) );
				half lerpResult128_g391 = lerp( temp_output_122_0_g391 , ( 1.0 - temp_output_122_0_g391 ) , _InvertClipTex);
				half ClipTex89_g391 = lerpResult128_g391;
				half smoothstepResult47_g391 = smoothstep( ( clampResult102_g391 + EgdeSmoothFixValue100_g391 ) , ( clampResult102_g391 + EdgeSmooth57_g391 + EgdeSmoothFixValue100_g391 ) , ClipTex89_g391);
				half ClipEdgeAlpha293 = ( ( 1.0 - smoothstepResult47_g391 ) * _EdgeColor.a );
				half4 ClipEdgeColor294 = _EdgeColor;
				half ClipEdgeBlendMainTex663 = _ClipEdgeBlendMainTex;
				half4 lerpResult660 = lerp( tex2DNode10 , ( tex2DNode10 + ( ClipEdgeAlpha293 * ClipEdgeColor294 * tex2DNode10.r * tex2DNode10.a ) ) , ClipEdgeBlendMainTex663);
				half3 temp_output_27_0_g394 = lerpResult660.rgb;
				half temp_output_16_0_g395 = temp_output_27_0_g394.x;
				Gradient gradient2_g395 = NewGradient( 0, 4, 2, float4( 1, 1, 1, 0 ), float4( 0.7991835, 0.7991835, 0.7991835, 0.1176471 ), float4( 0.07750964, 0.07750964, 0.07750964, 0.8382391 ), float4( 0, 0, 0, 0.997055 ), 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
				half2 temp_cast_2 = (_GradientUVOffset).xx;
				half2 texCoord3_g395 = IN.ase_texcoord3.xy * float2( 1,1 ) + temp_cast_2;
				half lerpResult17_g395 = lerp( texCoord3_g395.x , texCoord3_g395.y , _GradientUorV);
				half lerpResult19_g395 = lerp( SampleGradient( gradient2_g395, lerpResult17_g395 ).r , ( 1.0 - SampleGradient( gradient2_g395, lerpResult17_g395 ).r ) , _InvertGradient);
				half clampResult9_g395 = clamp( ( ( -1.0 * _GradientBlendIntensity * lerpResult19_g395 ) + temp_output_16_0_g395 ) , 0.0 , 1.0 );
				half lerpResult21_g395 = lerp( temp_output_16_0_g395 , clampResult9_g395 , _UseGradient);
				half ColorAAlpha5_g394 = _ColorA.a;
				half temp_output_17_0_g394 = ( lerpResult21_g395 + ( -0.35 + ( ColorAAlpha5_g394 * 0.3 ) ) );
				half4 lerpResult21_g394 = lerp( _ColorB , _ColorA , temp_output_17_0_g394);
				half ColorBAlpha6_g394 = _ColorB.a;
				half ColorCAlpha9_g394 = _ColorC.a;
				half4 lerpResult18_g394 = lerp( _ColorC , lerpResult21_g394 , ( temp_output_17_0_g394 + ( 0.45 + ( ColorBAlpha6_g394 * 0.3 ) + ( ColorCAlpha9_g394 * -0.3 ) ) ));
				half3 InputRGB30_g394 = temp_output_27_0_g394;
				half4 lerpResult36_g394 = lerp( lerpResult18_g394 , half4( InputRGB30_g394 , 0.0 ) , _UseOriginColor);
				half4 temp_output_601_0 = lerpResult36_g394;
				half3 lerpResult129_g396 = lerp( temp_output_601_0.rgb , ClipEdgeColor294.rgb , ClipEdgeAlpha293);
				half4 lerpResult665 = lerp( half4( lerpResult129_g396 , 0.0 ) , temp_output_601_0 , ClipEdgeBlendMainTex663);
				half2 uv_FlowTex = IN.ase_texcoord3.xy * _FlowTex_ST.xy + _FlowTex_ST.zw;
				half2 appendResult727 = (half2(FlowSpeed_Forth_U457 , FlowSpeed_Forth_V458));
				half2 temp_output_791_0 = ( ( _FlowTexTwisStage * TwistOutputedUV323 ) + appendResult727 );
				half3 objToWorld50_g393 = mul( GetObjectToWorldMatrix(), float4( float3( 0,0,0 ), 1 ) ).xyz;
				half2 appendResult55_g393 = (half2(( ( WorldPosition.x - IN.ase_texcoord3.zw.x ) - objToWorld50_g393.x ) , ( ( WorldPosition.y - IN.ase_texcoord3.zw.y ) - objToWorld50_g393.y )));
				half2 lerpResult751 = lerp( ( uv_FlowTex + temp_output_791_0 ) , ( temp_output_791_0 + (appendResult55_g393*_FlowTex_ST.xy + _FlowTex_ST.zw) ) , _FlowTexUsePositionUV);
				half4 tex2DNode713 = tex2D( _FlowTex, lerpResult751 );
				half3 temp_output_27_0_g399 = tex2DNode713.rgb;
				half ColorAAlpha5_g399 = _FlowTexColorA.a;
				half temp_output_17_0_g399 = ( (temp_output_27_0_g399).x + ( -0.35 + ( ColorAAlpha5_g399 * 0.3 ) ) );
				half4 lerpResult21_g399 = lerp( _FlowTexColorB , _FlowTexColorA , temp_output_17_0_g399);
				half ColorBAlpha6_g399 = _FlowTexColorB.a;
				half ColorCAlpha9_g399 = _FlowTexColorC.a;
				half4 lerpResult18_g399 = lerp( _FlowTexColorC , lerpResult21_g399 , ( temp_output_17_0_g399 + ( 0.45 + ( ColorBAlpha6_g399 * 0.3 ) + ( ColorCAlpha9_g399 * -0.3 ) ) ));
				half3 InputRGB30_g399 = temp_output_27_0_g399;
				half4 lerpResult36_g399 = lerp( lerpResult18_g399 , half4( InputRGB30_g399 , 0.0 ) , _FlowTexUseOriginColor);
				half4 temp_output_8_0_g400 = tex2DNode713;
				half temp_output_10_0_g400 = (temp_output_8_0_g400).w;
				half3 desaturateInitialColor1_g400 = ( (temp_output_8_0_g400).xyz * temp_output_10_0_g400 );
				half desaturateDot1_g400 = dot( desaturateInitialColor1_g400, float3( 0.299, 0.587, 0.114 ));
				half3 desaturateVar1_g400 = lerp( desaturateInitialColor1_g400, desaturateDot1_g400.xxx, 0.0 );
				half lerpResult19_g400 = lerp( saturate( (0.0 + ((desaturateVar1_g400).x - 0.0) * (1.0 - 0.0) / (saturate( ( saturate( ( _FlowTexBlackClipII + 0.0 ) ) + 0.05 ) ) - 0.0)) ) , temp_output_10_0_g400 , _FlowTexUseAlpha);
				half4 lerpResult728 = lerp( ( lerpResult665 * IN.ase_color * _TintColor ) , ( _FlowColor * lerpResult36_g399 ) , lerpResult19_g400);
				half lerpResult742 = lerp( 0.0 , IN.ase_texcoord4.w , UseCustomData633);
				half DataW2FresnalIntensity741 = lerpResult742;
				float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - WorldPosition );
				ase_worldViewDir = normalize(ase_worldViewDir);
				half3 ase_worldNormal = IN.ase_texcoord6.xyz;
				half3 lerpResult22_g406 = lerp( -ase_worldNormal , ase_worldNormal , ase_vface);
				half fresnelNdotV2_g406 = dot( lerpResult22_g406, ase_worldViewDir );
				half fresnelNode2_g406 = ( _Bias + _Scale * pow( 1.0 - fresnelNdotV2_g406, _Power ) );
				half temp_output_5_0_g406 = saturate( fresnelNode2_g406 );
				#ifdef _INVERTFRESNEL_ON
				half staticSwitch13_g406 = ( 1.0 - temp_output_5_0_g406 );
				#else
				half staticSwitch13_g406 = temp_output_5_0_g406;
				#endif
				half4 temp_cast_13 = (staticSwitch13_g406).xxxx;
				float div12_g406=256.0/float((int)_PosterizeStage);
				half4 posterize12_g406 = ( floor( temp_cast_13 * div12_g406 ) / div12_g406 );
				half4 lerpResult16_g406 = lerp( half4( lerpResult728.rgb , 0.0 ) , ( _FresnalColor * DataW2FresnalIntensity741 ) , ( _FresnalColor.a * posterize12_g406 ));
				
				half4 temp_output_8_0_g398 = lerpResult660;
				half temp_output_10_0_g398 = (temp_output_8_0_g398).w;
				half3 desaturateInitialColor1_g398 = ( (temp_output_8_0_g398).xyz * temp_output_10_0_g398 );
				half desaturateDot1_g398 = dot( desaturateInitialColor1_g398, float3( 0.299, 0.587, 0.114 ));
				half3 desaturateVar1_g398 = lerp( desaturateInitialColor1_g398, desaturateDot1_g398.xxx, 0.0 );
				half lerpResult19_g398 = lerp( saturate( (0.0 + ((desaturateVar1_g398).x - 0.0) * (1.0 - 0.0) / (saturate( ( saturate( ( _BlackClip + 0.0 ) ) + 0.05 ) ) - 0.0)) ) , temp_output_10_0_g398 , _UseAlpha);
				half ClipBlackAlpha491 = lerpResult19_g398;
				half smoothstepResult40_g391 = smoothstep( temp_output_72_0_g391 , ( temp_output_72_0_g391 + EdgeSmooth57_g391 ) , ClipTex89_g391);
				half lerpResult132_g391 = lerp( smoothstepResult40_g391 , 1.0 , _ClipNullAlpha);
				half ClipAlpha292 = lerpResult132_g391;
				half lerpResult609 = lerp( MaskAlpha355 , (float)1 , _MaskNullAlpha);
				half VertexAlpha350 = IN.ase_color.a;
				
#ifdef DISCARD_FRAGMENT
				float DiscardValue = 1.0;
				float DiscardThreshold = 0;

				if(DiscardValue < DiscardThreshold)discard;
#endif
				float3 BakedAlbedo = 0;
				float3 BakedEmission = 0;
				float3 Color = lerpResult16_g406.rgb;
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
	CustomEditor "ASEMaterialInspector"
	Fallback "Hidden/InternalErrorShader"
	
}
/*ASEBEGIN
Version=18935
437;379;1500;1000;-4607.901;1100.561;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;628;-4487.583,-423.372;Inherit;False;2484.94;842.0228;Comment;20;591;510;503;502;504;511;508;507;682;506;647;633;629;741;848;849;850;851;852;853;UV3 CustomData;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;473;-3416.707,-1552.423;Inherit;False;1177.795;1029.757;Comment;21;468;467;457;458;466;436;464;456;459;435;460;461;437;465;462;463;454;453;452;455;451;Time to UV;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;629;-3753.412,325.4605;Inherit;False;Property;_UseCustomData;Use CustomData;73;2;[Header];[Toggle];Create;True;1;CustomDate;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;435;-3212.385,-1472.913;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;647;-3751.68,-339.6738;Inherit;False;465.9121;629.8423;Comment;8;632;635;631;634;742;743;846;847;Use CustomDate;0.4662542,0,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;633;-3477.78,322.8134;Inherit;False;UseCustomData;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;591;-4342.447,-269.6914;Inherit;False;2;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;467;-3366.707,-1285.426;Inherit;False;312.3809;240.363;Comment;1;438;_FlowSpeedA;0.3884525,0,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;635;-3703.297,-108.0379;Inherit;False;633;UseCustomData;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;437;-3025.161,-1473.823;Inherit;False;Time;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;436;-3021.432,-1394.02;Inherit;False;437;Time;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;506;-3233.288,-102.3165;Inherit;False;Constant;_Float13;Float 13;28;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;468;-3365.232,-971.9154;Inherit;False;338.3809;246.8541;Comment;1;450;_FlowSpeedB;0.4255471,0,1,1;0;0
Node;AmplifyShaderEditor.Vector4Node;438;-3316.707,-1235.426;Inherit;False;Property;_FlowSpeedClipTwist;FlowSpeed Clip Twist ;56;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,-0.5;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;634;-3485.435,-150.1501;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;682;-2811.689,-345.048;Inherit;False;543.6907;373.1591;Comment;4;678;680;681;679;_DataX2Y2;0.4746089,0,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;229;-1985.155,-1173.679;Inherit;False;1716.571;728.8047;;10;239;213;212;223;219;218;238;592;646;688;UV2 CustomData;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;462;-2720.136,-1077.785;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;681;-2775.237,-75.16296;Inherit;False;Property;_DataY2;DataY2 TwistTex Flow U or V;78;1;[Toggle];Create;False;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;508;-3055.694,-147.7727;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;646;-1707.956,-1076.081;Inherit;False;468.2543;597.831;Comment;8;645;644;643;642;641;640;638;639;Use Custom Date;0.4509578,0,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;461;-2724.179,-1175.814;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;450;-3315.232,-921.9154;Inherit;False;Property;_FlowSpeedMainFlowTex;FlowSpeed Main FlowTex;57;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;507;-3059.194,-45.47266;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;478;-3976.826,822.8156;Inherit;False;402.4792;206.6982;Comment;3;481;479;480;TimeFlow;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;465;-2734.284,-760.4544;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;466;-2734.023,-657.6661;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;453;-2555.266,-1182.665;Inherit;False;FlowSpeed_Twist_U;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;642;-1663.711,-773.5165;Inherit;False;633;UseCustomData;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;680;-2463.44,-127.0416;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;592;-1919.878,-997.5308;Inherit;False;1;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;454;-2559.716,-1081.311;Inherit;False;FlowSpeed_Twist_V;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;479;-3946.681,943.6057;Inherit;False;454;FlowSpeed_Twist_V;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;457;-2567.631,-746.4754;Inherit;False;FlowSpeed_Forth_U;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;480;-3948.023,865.6558;Inherit;False;453;FlowSpeed_Twist_U;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;482;-2482.914,1513.195;Inherit;False;402.4792;206.6982;Comment;3;485;484;483;TimeFlow;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;643;-1425.271,-782.6978;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;458;-2571.297,-658.2637;Inherit;False;FlowSpeed_Forth_V;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;783;-3877.96,1248.707;Inherit;False;724.7943;329.7681;Comment;3;785;787;902;Position UV;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;511;-2253.417,-132.0382;Inherit;False;DataY2TwistFlow;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;517;-3844.091,1065.684;Inherit;False;268.7864;136.0776;Comment;1;513;Data2 Flow;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureTransformNode;785;-3814.349,1467.864;Inherit;False;539;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.TexCoordVertexDataNode;902;-3830.369,1319.626;Inherit;False;3;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;513;-3805.823,1114.382;Inherit;False;511;DataY2TwistFlow;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;484;-2465.026,1563.195;Inherit;False;457;FlowSpeed_Forth_U;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;238;-1152.891,-764.5329;Inherit;False;DataZ1;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;485;-2461.837,1637.385;Inherit;False;458;FlowSpeed_Forth_V;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;481;-3700.51,920.8447;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;284;-2568.308,1231.723;Inherit;False;495.1673;237.9516;Comment;3;241;676;675;_DataZ1;0.4952259,0,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;512;-3424.305,920.1089;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;483;-2210.47,1622.173;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;896;-3586.576,1422.593;Inherit;False;VFX_PositionUV;-1;;387;f9d906dc205907d44ab7c80e358e2575;0;4;39;FLOAT;0;False;40;FLOAT;0;False;29;FLOAT2;1,1;False;30;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;675;-2539.315,1361.596;Inherit;False;Property;_DataZ1;DataZ1 Use Twist Stage;76;1;[Toggle];Create;False;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;540;-3266.254,807.5322;Inherit;False;0;539;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;241;-2475.13,1287.234;Inherit;False;238;DataZ1;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;656;-1996.044,1583.887;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;789;-3001.903,1044.104;Inherit;False;Property;_TwistUsePositionUV;Twist Use Position UV;50;1;[Toggle];Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;676;-2243.785,1291.827;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;541;-2959.098,901.3516;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;638;-1670.48,-1008.909;Inherit;False;633;UseCustomData;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;787;-3306.166,1298.707;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;790;-2665.161,901.5788;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;688;-1050.394,-680.276;Inherit;False;751.9122;209;Comment;3;687;686;375;DataX1 MainTex Flow U or V;0.4206057,0,1,1;0;0
Node;AmplifyShaderEditor.WireNode;677;-2028.693,1282.369;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;639;-1423.048,-1049.626;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;486;-1972.268,1519.801;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;539;-2295.544,876.5376;Inherit;True;Property;_TwistTex;TwistTex;49;2;[Header];[Normal];Create;True;1;Twist;0;0;False;0;False;-1;53b415222112ea94e960e1c7d7e05dc3;53b415222112ea94e960e1c7d7e05dc3;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;687;-1000.394,-588.1844;Inherit;False;Property;_DataX1;DataX1 MainTex Flow U or V;74;1;[Toggle];Create;False;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;219;-1116.389,-972.9268;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;552;-1976.807,983.2256;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;218;-1124.108,-1067.296;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;808;-2020.35,959.1027;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;632;-3714.347,-246.6945;Inherit;False;633;UseCustomData;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;686;-735.6136,-630.276;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;690;-1925.285,879.7155;Inherit;False;VFX_Twist;51;;388;84c8764698f118d4889e2fe2f9fd6acd;0;3;12;FLOAT3;0,0,0;False;49;FLOAT;0;False;56;FLOAT2;0,0;False;2;FLOAT2;0;FLOAT;54
Node;AmplifyShaderEditor.RegisterLocalVarNode;375;-566.482,-628.0228;Inherit;False;MainTexUVFlowByData;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;504;-3227.139,-354.1515;Inherit;False;Constant;_Float5;Float 5;28;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;333;-842.2529,131.461;Inherit;False;586.1172;248.1698;Comment;3;327;673;805;TwistClipTex;0.4636889,0,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;685;-788.5564,429.9694;Inherit;False;531.4069;243.1427;Comment;3;684;377;683;ClipFlow Follow MainTex;0.4644604,0,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;323;-1454.013,873.2491;Inherit;False;TwistOutputedUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;631;-3493.763,-291.0388;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;327;-781.9133,195.6306;Inherit;False;323;TwistOutputedUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;503;-3062.44,-270.2515;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;459;-2748.433,-1381.977;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;502;-3065.44,-371.2514;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;377;-738.5564,479.9703;Inherit;False;375;MainTexUVFlowByData;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;679;-2775.717,-248.7838;Inherit;False;Property;_DataX2;DataX2 ClipTex Flow U or V;77;1;[Toggle];Create;False;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;460;-2750.02,-1282.884;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;805;-813.3864,283.3593;Inherit;False;Property;_ClipTexTwisStage;ClipTex Twis Stage;37;0;Create;True;0;0;0;False;0;False;0;0.552;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;683;-734.1382,557.1121;Inherit;False;Property;_ClipFlowFollowMainTex;ClipFlow Follow MainTex;46;1;[Toggle];Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;678;-2465.388,-291.2006;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;673;-460.2581,217.1537;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;684;-439.15,484.2833;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;522;-666.6143,777.4133;Inherit;False;403;208;Comment;3;525;524;523;TimeFlow;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;452;-2559.521,-1281.704;Inherit;False;FlowSpeed_Clip_V;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;451;-2533.275,-1385.582;Inherit;False;FlowSpeed_Clip_U;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;523;-652.614,827.4135;Inherit;False;451;FlowSpeed_Clip_U;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;510;-2253.772,-299.546;Inherit;False;DataX2ClipFlow;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;671;2625.764,-203.6852;Inherit;True;VFX_Mask;59;;389;364b953953898644d9a77bfcd0eeace1;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;801;-179.9264,271.6935;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;903;-280.2775,1316.664;Inherit;False;730.0854;320.9451;Comment;4;899;796;793;901;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;524;-650.614,900.4122;Inherit;False;452;FlowSpeed_Clip_V;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;802;-176.1559,532.1097;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;640;-1666.269,-891.9187;Inherit;False;633;UseCustomData;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;901;-221.9726,1366.664;Inherit;False;3;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;804;206.421,630.4804;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureTransformNode;793;-230.2775,1497.609;Inherit;False;544;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.GetLocalVarNode;521;-446.2578,698.4629;Inherit;False;510;DataX2ClipFlow;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;525;-407.6148,882.4123;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;355;2860.92,-207.5764;Inherit;False;MaskAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;803;208.6441,672.7162;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;899;34.20316,1416.611;Inherit;False;VFX_PositionUV;-1;;390;f9d906dc205907d44ab7c80e358e2575;0;4;39;FLOAT;0;False;40;FLOAT;0;False;29;FLOAT2;1,1;False;30;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;535;607.7774,1167.893;Inherit;False;Property;_MaskBlendStage;Mask Blend Stage;62;0;Create;True;0;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;378;343.0868,641.4337;Inherit;False;4;4;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;641;-1431.347,-915.5142;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;366;699.1747,1097.61;Inherit;False;355;MaskAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;545;322.6181,439.8966;Inherit;False;0;544;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;464;-2729.231,-863.5364;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;655;1146.772,978.7339;Inherit;False;559.3164;235.3157;Comment;2;653;654;Mask Blend ClipTex;0.3710442,0,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;546;630.6856,449.0584;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;223;-1151.978,-849.0793;Inherit;False;DataY1;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;796;297.808,1410.595;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;586;881.9012,1098.934;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;800;518.4208,756.0574;Inherit;False;Property;_ClipTexUseWorldUV;ClipTex Use World UV;38;1;[Toggle];Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;463;-2721.145,-966.6181;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;230;704.2316,44.72333;Inherit;False;558.9373;260.493;Comment;3;224;648;649;_DataY1;0.456182,0,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;649;741.4711,206.9886;Inherit;False;Property;_DataY1;DataY1 Use ClipStage;75;1;[Toggle];Create;False;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;797;830.5089,709.7109;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;455;-2559.695,-966.0244;Inherit;False;FlowSpeed_Main_U;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;736;-1018.338,-1746.69;Inherit;False;350;166;Comment;1;733;跟FlowTex共用扭曲，所以製作強度開關;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;585;1003.501,1099.934;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;365;999.4139,1017.087;Half;False;Constant;_Float9;Float 9;16;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;224;842.6277,122.355;Inherit;False;223;DataY1;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;472;-938.7029,-1411.09;Inherit;False;403;208;Comment;3;471;469;470;TimeFlow;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;456;-2564.278,-865.2153;Inherit;False;FlowSpeed_Main_V;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;653;1190.128,1085.048;Inherit;False;Property;_MaskBlendClipTex;Mask Blend ClipTex;48;1;[Toggle];Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;654;1507.897,1039.141;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;733;-968.3384,-1696.69;Inherit;False;Property;_MainTexTwisStage;MainTex Twis Stage;23;0;Create;True;0;0;0;False;0;False;1;0.14;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;470;-922.7026,-1288.09;Inherit;False;456;FlowSpeed_Main_V;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;648;1060.103,98.86841;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;469;-924.7026,-1361.09;Inherit;False;455;FlowSpeed_Main_U;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;544;1069.755,433.8779;Inherit;True;Property;_ClipTex;ClipTex;36;1;[Header];Create;True;1;Clip;0;0;False;0;False;-1;3313b5d760a88c0499a0a3306d53c25b;09ea7a6165896d04c9ac8d5c6251f156;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;324;-865.8466,-1560.191;Inherit;False;323;TwistOutputedUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;212;-909.7054,-1118.435;Inherit;False;0;10;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;735;-616.77,-1572.21;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;659;1635.893,428.6395;Inherit;False;VFX_ClipSmoothEdge;39;;391;69e070d297569514d918f7319aa4d435;0;3;62;FLOAT;0;False;24;FLOAT;0;False;87;FLOAT;1;False;4;FLOAT;22;FLOAT;28;COLOR;32;FLOAT;124
Node;AmplifyShaderEditor.DynamicAppendNode;471;-679.7026,-1306.09;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;213;-440.1674,-1117.411;Inherit;False;4;4;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;293;2032.85,445.1728;Inherit;False;ClipEdgeAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;294;2030.77,530.7156;Inherit;False;ClipEdgeColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;297;33.44024,-769.2905;Inherit;False;294;ClipEdgeColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;661;215.4009,-1291.832;Inherit;False;Property;_ClipEdgeBlendMainTex;ClipEdge Blend MainTex;47;1;[Toggle];Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;296;33.54256,-857.9782;Inherit;False;293;ClipEdgeAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;10;-245.0968,-1087.734;Inherit;True;Property;_MainTex;MainTex;1;0;Create;True;1;MainTex;0;0;False;0;False;-1;67de55b069370c742b5483227026a041;05effdef0317cfc4c80de3972033e091;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;725;2323.736,-1632.876;Inherit;False;458;FlowSpeed_Forth_V;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;276;335.9776,-974.9302;Inherit;False;4;4;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;721;2393.93,-1854.587;Inherit;False;323;TwistOutputedUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;782;2457.306,-1444.758;Inherit;False;686.3574;304.0732;Comment;4;776;898;777;905;Position UV;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;663;461.8137,-1292.428;Inherit;False;ClipEdgeBlendMainTex;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;715;2332.567,-1926.458;Inherit;False;Property;_FlowTexTwisStage;FlowTex Twis Stage;27;0;Create;True;0;0;0;False;0;False;0;0.48;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;724;2322.93,-1704.342;Inherit;False;457;FlowSpeed_Forth_U;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;905;2487.427,-1384.877;Inherit;False;3;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;278;523.4236,-1007.58;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureTransformNode;777;2492.472,-1240.912;Inherit;False;713;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;723;2642.17,-1922.88;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;664;460.4802,-862.3546;Inherit;False;663;ClipEdgeBlendMainTex;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;727;2641.921,-1682;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;791;2803.117,-1704.786;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;720;2563.776,-2059.206;Inherit;False;0;713;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;898;2696.466,-1362.858;Inherit;False;VFX_PositionUV;-1;;393;f9d906dc205907d44ab7c80e358e2575;0;4;39;FLOAT;0;False;40;FLOAT;0;False;29;FLOAT2;1,1;False;30;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;660;768.2524,-1064.712;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;752;3201.581,-1363.563;Inherit;False;Property;_FlowTexUsePositionUV;FlowTex Use Position UV;26;1;[Toggle];Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;299;1875.748,-510.5169;Inherit;False;294;ClipEdgeColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;776;2976.763,-1394.758;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;847;-3700.803,32.94864;Inherit;False;633;UseCustomData;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;601;1346.841,-882.3558;Inherit;True;VFX_GraytoColor Gradient;5;;394;4dca6182a64a98847bdebf99782433f1;0;1;27;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;298;1874.919,-588.2236;Inherit;False;293;ClipEdgeAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;722;2988.933,-1917.466;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;667;2033.821,-812.1857;Inherit;False;663;ClipEdgeBlendMainTex;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;852;-3188.584,108.8681;Inherit;False;Constant;_Float6;Float 6;28;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;846;-3482.941,-9.163555;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;751;3448.503,-1560.85;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;670;2089.942,-610.3402;Inherit;False;VFX_ClipEdge;-1;;396;1a8a8b88657c99948944543463522665;0;3;24;FLOAT3;0,0,0;False;135;FLOAT;0;False;136;FLOAT3;0,0,0;False;1;FLOAT3;140
Node;AmplifyShaderEditor.CommentaryNode;288;2821.155,-616.3199;Inherit;False;589.7087;302.3228;Comment;5;350;490;488;489;21;VertexColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;743;-3699.105,175.2225;Inherit;False;633;UseCustomData;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;851;-3010.99,63.41193;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;848;-2790.433,122.4069;Inherit;False;Property;_DataZ2;DataZ2 TwistTex Flow U or V;79;1;[Toggle];Create;False;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;713;3704.893,-1560.25;Inherit;True;Property;_FlowTex;FlowTex;25;0;Create;True;1;FlowTex;0;0;False;0;False;-1;d1bdf5c656989ac4fb3ac6012c6ea614;d1bdf5c656989ac4fb3ac6012c6ea614;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;494;3113.511,-1023.388;Inherit;False;225.9434;235.1498;Comment;1;406;TintColor;0.410079,0,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;665;2443.533,-908.4807;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;644;-1656.831,-662.2408;Inherit;False;633;UseCustomData;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;850;-3014.49,165.712;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;738;4138.924,-1508.736;Inherit;False;VFX_GraytoColor FlowTex;31;;399;2faa4ce8d8c52294984bb97eef0af6b7;0;1;27;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;21;2841.364,-537.4343;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;718;4353.352,-1740.117;Inherit;False;Property;_FlowColor;FlowColor;24;2;[HDR];[Header];Create;True;1;FlowTex;0;0;False;0;False;1,1,1,1;5.992157,5.992157,5.992157,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;406;3136.661,-973.3875;Inherit;False;Property;_TintColor;TintColor;0;2;[HDR];[Header];Create;True;1;MainTex;0;0;False;0;False;1,1,1,1;1,1,1,0.2;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;742;-3480.596,129.7304;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;849;-2439.684,85.05871;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;227;1328.217,-458.821;Inherit;True;VFX_ClipBlack;2;;398;bca2b1ae1e5a4c544b8f204bdd345f7b;0;2;8;FLOAT4;0,0,0,0;False;18;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;672;2760.877,-715.5557;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;617;3051.928,-250.714;Inherit;False;437.3711;292.5679;Comment;3;414;609;611;Mask Null Alpha;0.4016991,0,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;645;-1424.005,-646.7718;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;292;2034.268,360.6488;Inherit;False;ClipAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;739;4111.158,-1380.402;Inherit;False;VFX_ClipBlack FlowTex;28;;400;84cf6e801ccd7bb49a2bcb11c6eb9fca;0;2;8;FLOAT4;0,0,0,0;False;18;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;719;4670.923,-1567.557;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;239;-1148.03,-680.5465;Inherit;False;DataW1;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;853;-2274.051,80.18726;Inherit;False;DataZ2VertexoffsetTexFlow;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;350;3015.781,-405.6501;Inherit;False;VertexAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;741;-3269.947,248.9772;Inherit;False;DataW2FresnalIntensity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;3635.299,-698.7161;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.IntNode;414;3148.931,-144.4554;Inherit;False;Constant;_Int0;Int 0;20;0;Create;True;0;0;0;False;0;False;1;0;False;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;611;3102.828,-70.94614;Inherit;False;Property;_MaskNullAlpha;Mask Null Alpha;58;1;[Toggle];Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;491;1672.545,-464.1253;Inherit;False;ClipBlackAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;251;5227.015,-866.4548;Inherit;False;239;DataW1;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;295;3642.875,-319.3432;Inherit;False;292;ClipAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;492;3609.976,-399.6439;Inherit;False;491;ClipBlackAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;609;3301.299,-198.714;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;840;-2915.893,-2180.728;Inherit;False;918.6311;384.1204;Comment;6;831;832;829;828;830;836;PositionUV;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;620;-3810.292,-1549.744;Inherit;False;351.5083;335.5892;Comment;3;605;618;619;Shader Options;0.3799582,0,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;728;4779.704,-1057.564;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;866;5215.987,-703.4459;Inherit;False;355;MaskAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;854;5128.883,-785.5853;Inherit;False;853;DataZ2VertexoffsetTexFlow;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;616;3625.74,-151.2818;Inherit;False;350;VertexAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;747;4739.205,-1143.552;Inherit;False;741;DataW2FresnalIntensity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;836;-2307.674,-2108.184;Inherit;False;PositionUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;490;3203.604,-405.4536;Inherit;False;VertexB;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;619;-3758.073,-1330.155;Inherit;False;Property;_ZTestMode;Z Test Mode;82;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;618;-3760.292,-1416.694;Inherit;False;Property;_ZWriteMode;Z Write Mode;81;1;[Enum];Create;True;0;2;Off;0;On;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;907;5424.965,-809.8188;Inherit;False;VFX_VertexOffset;63;;407;47bca5503be245c4783b3c6edf42a04a;0;3;40;FLOAT;1;False;36;FLOAT2;0,0;False;39;FLOAT3;1,1,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TransformPositionNode;829;-2876.179,-1982.549;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;3923.222,-348.1472;Inherit;False;5;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;447;-1448.094,970.2497;Inherit;False;TwistMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;488;3204.964,-483.941;Inherit;False;VertexR;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;717;3601.462,-1209.034;Inherit;False;Constant;_FlowTexNullClip;FlowTex NullClip;37;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;830;-2630.393,-1955.321;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;809;5161.496,-1096.391;Inherit;False;VFX_Fresnel;16;;406;7bcd008f7aac81e4cba75f3fea21ab64;0;2;1;FLOAT3;0,0,0;False;18;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;605;-3758.784,-1499.744;Inherit;False;Property;_CullMode;Cull Mode;80;2;[Header];[Enum];Create;True;1;Shader Options;2;CullBack;2;CullOff;0;1;UnityEngine.Rendering.CullMode;True;0;False;2;2;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;828;-2854.504,-2130.728;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;489;3013.941,-482.8313;Inherit;False;VertexG;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;716;3876.567,-1251.877;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;831;-2635.065,-2106.249;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;832;-2472.504,-2104.622;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;906;5736.636,-1103.514;Float;False;False;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;1;New Amplify Shader;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;FullScreenPass;0;1;FullScreenPass;4;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;7;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=UniversalForwardOnly;True;2;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;622;4660.794,-1103.514;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;ExtraPrePass;0;2;ExtraPrePass;6;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;0;False;False;0;Hidden/InternalErrorShader;0;0;Standard;1;MRT Output;0;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;625;4660.794,-693.2109;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;DepthOnly;0;5;DepthOnly;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;False;False;True;False;False;False;False;0;False;-1;False;False;False;False;False;False;False;False;False;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;626;4660.794,-1103.514;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;SceneSelectionPass;0;6;SceneSelectionPass;5;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=SceneSelectionPass;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;624;4660.794,-693.2109;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;ShadowCaster;0;4;ShadowCaster;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;621;4660.794,-1103.514;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;AdditionalPass;0;0;AdditionalPass;6;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;0;False;False;0;Hidden/InternalErrorShader;0;0;Standard;1;MRT Output;0;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;627;4660.794,-693.2109;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;Meta;0;7;Meta;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;623;5736.636,-1103.514;Half;False;True;-1;2;ASEMaterialInspector;0;21;ASE/VFX/PT_MeshAssignColorClipTwistFresnalFlow;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;Forward;0;3;Forward;12;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;0;True;605;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;True;1;5;False;-1;10;False;-1;1;1;False;-1;10;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;True;2;True;618;True;3;True;619;True;False;0;False;-1;0;False;-1;True;1;LightMode=UniversalForward;False;False;0;Hidden/InternalErrorShader;0;0;Standard;19;Surface;1;637957856567043756;  Blend;0;0;Two Sided;1;0;Cast Shadows;0;637938935950703661;  Use Shadow Threshold;0;0;Receive Shadows;1;0;GPU Instancing;1;0;LOD CrossFade;0;0;Treeverse Linear Fog;0;0;DOTS Instancing;0;0;Meta Pass;0;0;Extra Pre Pass;0;0;Full Screen Pass;0;0;Additional Pass;0;0;Scene Selectioin Pass;0;0;Vertex Position,InvertActionOnDeselection;1;0;Vertex Operation Hide Pass Only;0;0;Discard Fragment;0;637957856600501076;Push SelfShadow to Main Light;0;0;2;MRT Output;0;0;Custom Output Position;0;0;8;False;False;False;True;False;False;False;False;False;;False;0
WireConnection;633;0;629;0
WireConnection;437;0;435;0
WireConnection;634;1;591;2
WireConnection;634;2;635;0
WireConnection;462;0;436;0
WireConnection;462;1;438;4
WireConnection;508;0;634;0
WireConnection;508;1;506;0
WireConnection;461;0;436;0
WireConnection;461;1;438;3
WireConnection;507;0;506;0
WireConnection;507;1;634;0
WireConnection;465;0;436;0
WireConnection;465;1;450;3
WireConnection;466;0;436;0
WireConnection;466;1;450;4
WireConnection;453;0;461;0
WireConnection;680;0;508;0
WireConnection;680;1;507;0
WireConnection;680;2;681;0
WireConnection;454;0;462;0
WireConnection;457;0;465;0
WireConnection;643;1;592;3
WireConnection;643;2;642;0
WireConnection;458;0;466;0
WireConnection;511;0;680;0
WireConnection;238;0;643;0
WireConnection;481;0;480;0
WireConnection;481;1;479;0
WireConnection;512;0;481;0
WireConnection;512;1;513;0
WireConnection;483;0;484;0
WireConnection;483;1;485;0
WireConnection;896;39;902;1
WireConnection;896;40;902;2
WireConnection;896;29;785;0
WireConnection;896;30;785;1
WireConnection;656;0;483;0
WireConnection;676;1;241;0
WireConnection;676;2;675;0
WireConnection;541;0;540;0
WireConnection;541;1;512;0
WireConnection;787;0;512;0
WireConnection;787;1;896;0
WireConnection;790;0;541;0
WireConnection;790;1;787;0
WireConnection;790;2;789;0
WireConnection;677;0;676;0
WireConnection;639;1;592;1
WireConnection;639;2;638;0
WireConnection;486;0;656;0
WireConnection;539;1;790;0
WireConnection;219;1;639;0
WireConnection;552;0;486;0
WireConnection;218;0;639;0
WireConnection;808;0;677;0
WireConnection;686;0;218;0
WireConnection;686;1;219;0
WireConnection;686;2;687;0
WireConnection;690;12;539;0
WireConnection;690;49;808;0
WireConnection;690;56;552;0
WireConnection;375;0;686;0
WireConnection;323;0;690;0
WireConnection;631;1;591;1
WireConnection;631;2;632;0
WireConnection;503;0;504;0
WireConnection;503;1;631;0
WireConnection;459;0;436;0
WireConnection;459;1;438;1
WireConnection;502;0;631;0
WireConnection;502;1;504;0
WireConnection;460;0;436;0
WireConnection;460;1;438;2
WireConnection;678;0;502;0
WireConnection;678;1;503;0
WireConnection;678;2;679;0
WireConnection;673;1;327;0
WireConnection;673;2;805;0
WireConnection;684;1;377;0
WireConnection;684;2;683;0
WireConnection;452;0;460;0
WireConnection;451;0;459;0
WireConnection;510;0;678;0
WireConnection;801;0;673;0
WireConnection;802;0;684;0
WireConnection;804;0;801;0
WireConnection;525;0;523;0
WireConnection;525;1;524;0
WireConnection;355;0;671;0
WireConnection;803;0;802;0
WireConnection;899;39;901;1
WireConnection;899;40;901;2
WireConnection;899;29;793;0
WireConnection;899;30;793;1
WireConnection;378;0;804;0
WireConnection;378;1;803;0
WireConnection;378;2;521;0
WireConnection;378;3;525;0
WireConnection;641;1;592;2
WireConnection;641;2;640;0
WireConnection;464;0;436;0
WireConnection;464;1;450;2
WireConnection;546;0;545;0
WireConnection;546;1;378;0
WireConnection;223;0;641;0
WireConnection;796;0;378;0
WireConnection;796;1;899;0
WireConnection;586;0;366;0
WireConnection;586;1;535;0
WireConnection;463;0;436;0
WireConnection;463;1;450;1
WireConnection;797;0;546;0
WireConnection;797;1;796;0
WireConnection;797;2;800;0
WireConnection;455;0;463;0
WireConnection;585;0;586;0
WireConnection;456;0;464;0
WireConnection;654;0;365;0
WireConnection;654;1;585;0
WireConnection;654;2;653;0
WireConnection;648;1;224;0
WireConnection;648;2;649;0
WireConnection;544;1;797;0
WireConnection;735;0;733;0
WireConnection;735;1;324;0
WireConnection;659;62;648;0
WireConnection;659;24;544;1
WireConnection;659;87;654;0
WireConnection;471;0;469;0
WireConnection;471;1;470;0
WireConnection;213;0;212;0
WireConnection;213;1;735;0
WireConnection;213;2;686;0
WireConnection;213;3;471;0
WireConnection;293;0;659;28
WireConnection;294;0;659;32
WireConnection;10;1;213;0
WireConnection;276;0;296;0
WireConnection;276;1;297;0
WireConnection;276;2;10;1
WireConnection;276;3;10;4
WireConnection;663;0;661;0
WireConnection;278;0;10;0
WireConnection;278;1;276;0
WireConnection;723;0;715;0
WireConnection;723;1;721;0
WireConnection;727;0;724;0
WireConnection;727;1;725;0
WireConnection;791;0;723;0
WireConnection;791;1;727;0
WireConnection;898;39;905;1
WireConnection;898;40;905;2
WireConnection;898;29;777;0
WireConnection;898;30;777;1
WireConnection;660;0;10;0
WireConnection;660;1;278;0
WireConnection;660;2;664;0
WireConnection;776;0;791;0
WireConnection;776;1;898;0
WireConnection;601;27;660;0
WireConnection;722;0;720;0
WireConnection;722;1;791;0
WireConnection;846;1;591;3
WireConnection;846;2;847;0
WireConnection;751;0;722;0
WireConnection;751;1;776;0
WireConnection;751;2;752;0
WireConnection;670;24;601;0
WireConnection;670;135;298;0
WireConnection;670;136;299;0
WireConnection;851;0;846;0
WireConnection;851;1;852;0
WireConnection;713;1;751;0
WireConnection;665;0;670;140
WireConnection;665;1;601;0
WireConnection;665;2;667;0
WireConnection;850;0;852;0
WireConnection;850;1;846;0
WireConnection;738;27;713;0
WireConnection;742;1;591;4
WireConnection;742;2;743;0
WireConnection;849;0;851;0
WireConnection;849;1;850;0
WireConnection;849;2;848;0
WireConnection;227;8;660;0
WireConnection;672;0;665;0
WireConnection;645;1;592;4
WireConnection;645;2;644;0
WireConnection;292;0;659;22
WireConnection;739;8;713;0
WireConnection;719;0;718;0
WireConnection;719;1;738;0
WireConnection;239;0;645;0
WireConnection;853;0;849;0
WireConnection;350;0;21;4
WireConnection;741;0;742;0
WireConnection;22;0;672;0
WireConnection;22;1;21;0
WireConnection;22;2;406;0
WireConnection;491;0;227;0
WireConnection;609;0;355;0
WireConnection;609;1;414;0
WireConnection;609;2;611;0
WireConnection;728;0;22;0
WireConnection;728;1;719;0
WireConnection;728;2;739;0
WireConnection;836;0;832;0
WireConnection;490;0;21;3
WireConnection;907;40;251;0
WireConnection;907;36;854;0
WireConnection;907;39;866;0
WireConnection;23;0;492;0
WireConnection;23;1;295;0
WireConnection;23;2;609;0
WireConnection;23;3;406;4
WireConnection;23;4;616;0
WireConnection;447;0;690;54
WireConnection;488;0;21;1
WireConnection;830;0;829;1
WireConnection;830;1;829;2
WireConnection;809;1;728;0
WireConnection;809;18;747;0
WireConnection;489;0;21;2
WireConnection;716;2;717;0
WireConnection;831;0;828;1
WireConnection;831;1;828;2
WireConnection;832;0;831;0
WireConnection;832;1;830;0
WireConnection;623;2;809;0
WireConnection;623;3;23;0
WireConnection;623;5;907;0
ASEEND*/
//CHKSM=DC903A9C1F3EA2E5AA5B494B4E6435EEECBDF4B4