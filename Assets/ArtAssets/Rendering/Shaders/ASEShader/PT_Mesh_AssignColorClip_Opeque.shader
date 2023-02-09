// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/VFX/PT_Mesh_AssignColorClip_Opeque"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[ASEBegin][HDR]_TintColor("TintColor", Color) = (1,1,1,1)
		[Header(MainTex)]_MainTex("MainTex", 2D) = "white" {}
		[Toggle]_MainTexUsePositionUV("MainTex Use Position UV", Float) = 0
		[Header(AssignColor)]_ColorA("Color A", Color) = (1,1,1,0)
		_ColorB("Color B", Color) = (0.9960854,1,0.5235849,0)
		_ColorC("Color C", Color) = (1,0.6265537,0.08018869,0)
		[Header(GradientBlend)][Toggle]_UseGradient("Use Gradient", Float) = 0
		_GradientBlendIntensity("Gradient Blend Intensity", Range( 0 , 1)) = 1
		_GradientUVOffset("Gradient UV Offset", Range( -1 , 1)) = 0
		[Toggle]_GradientUorV("Gradient UorV", Float) = 0
		[Toggle]_InvertGradient("Invert Gradient", Float) = 0
		[Toggle]_UseOriginColor("Use OriginColor", Float) = 0
		_MatCapTexIntensity("MatCapTex Intensity", Range( 0 , 1)) = 0
		_MatcapTex("MatcapTex", 2D) = "white" {}
		[Header(Clip)]_ClipTex("ClipTex", 2D) = "white" {}
		[Toggle]_ClipTexUsePositionUV("ClipTex Use Position UV", Float) = 0
		[Toggle]_InvertClipTex("Invert ClipTex", Float) = 0
		[Toggle]_ClipNullAlpha("Clip Null Alpha", Float) = 0
		_ClipStage("ClipStage", Range( 0 , 1)) = 0
		[HDR]_EdgeColor("EdgeColor", Color) = (1,1,1,1)
		_EdgeWidth("EdgeWidth", Range( 0 , 1)) = 0.1
		_EdgeSmooth("EdgeSmooth", Range( 0 , 2)) = 0.1
		[Header(Custom Data)][Toggle]_UseCustomData("Use Custom Data", Float) = 0
		[ASEEnd][Header(Shader Options)][Enum(UnityEngine.Rendering.CullMode)]_CullMode("Cull Mode", Range( 0 , 2)) = 2

		
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
			
			Tags { "LightMode"="UniversalForwardOnly" }
			
			Blend One Zero, One Zero
			ZWrite On
			ZTest LEqual
			Offset 0,0
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
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_COLOR
			#define ASE_NEEDS_VERT_NORMAL


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_color : COLOR;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord3 : TEXCOORD3;
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
				float4 ase_color : COLOR;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)

			float4 _ColorB;
			float4 _MainTex_ST;
			float4 _ColorA;
			float4 _ColorC;
			float4 _TintColor;
			float4 _EdgeColor;
			float4 _ClipTex_ST;
			float _ClipTexUsePositionUV;
			float _UseOriginColor;
			float _UseGradient;
			float _InvertGradient;
			float _GradientUorV;
			float _GradientUVOffset;
			float _GradientBlendIntensity;
			float _MainTexUsePositionUV;
			float _UseCustomData;
			float _MatCapTexIntensity;
			float _EdgeWidth;
			float _EdgeSmooth;
			float _ClipNullAlpha;
			float _InvertClipTex;
			float _ClipStage;
			float _CullMode;
			CBUFFER_END
			sampler2D _ClipTex;
			sampler2D _MainTex;
			sampler2D _MatcapTex;


			
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

				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord5.xyz = ase_worldNormal;
				
				o.ase_color = v.ase_color;
				o.ase_texcoord3 = v.ase_texcoord1;
				o.ase_texcoord4.xy = v.ase_texcoord.xy;
				o.ase_texcoord4.zw = v.ase_texcoord3.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord5.w = 0;
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
				float VertexAlpha1004 = IN.ase_color.a;
				float4 lerpResult989 = lerp( float4( 0,0,0,0 ) , IN.ase_texcoord3 , _UseCustomData);
				float4 break992 = lerpResult989;
				float DataY1986 = break992.y;
				float EdgeWidth95_g460 = _EdgeWidth;
				float EdgeSmooth57_g460 = _EdgeSmooth;
				float temp_output_72_0_g460 = (( ( EdgeWidth95_g460 * -1.1 ) + -0.2 + ( EdgeSmooth57_g460 * -1.0 ) ) + (saturate( ( _ClipStage + DataY1986 ) ) - 0.0) * (1.1 - ( ( EdgeWidth95_g460 * -1.1 ) + -0.2 + ( EdgeSmooth57_g460 * -1.0 ) )) / (1.0 - 0.0));
				float2 uv_ClipTex = IN.ase_texcoord4.xy * _ClipTex_ST.xy + _ClipTex_ST.zw;
				float3 objToWorld50_g457 = mul( GetObjectToWorldMatrix(), float4( float3( 0,0,0 ), 1 ) ).xyz;
				float2 appendResult55_g457 = (float2(( ( WorldPosition.x - IN.ase_texcoord4.zw.x ) - objToWorld50_g457.x ) , ( ( WorldPosition.y - IN.ase_texcoord4.zw.y ) - objToWorld50_g457.y )));
				float2 lerpResult995 = lerp( uv_ClipTex , (appendResult55_g457*_ClipTex_ST.xy + _ClipTex_ST.zw) , _ClipTexUsePositionUV);
				float temp_output_122_0_g460 = saturate( ( tex2D( _ClipTex, lerpResult995 ).r * 1.0 ) );
				float lerpResult128_g460 = lerp( temp_output_122_0_g460 , ( 1.0 - temp_output_122_0_g460 ) , _InvertClipTex);
				float ClipTex89_g460 = lerpResult128_g460;
				float smoothstepResult40_g460 = smoothstep( temp_output_72_0_g460 , ( temp_output_72_0_g460 + EdgeSmooth57_g460 ) , ClipTex89_g460);
				float lerpResult132_g460 = lerp( smoothstepResult40_g460 , 1.0 , _ClipNullAlpha);
				float ClipAlpha975 = lerpResult132_g460;
				
				float2 uv_MainTex = IN.ase_texcoord4.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float3 objToWorld50_g458 = mul( GetObjectToWorldMatrix(), float4( float3( 0,0,0 ), 1 ) ).xyz;
				float2 appendResult55_g458 = (float2(( ( WorldPosition.x - IN.ase_texcoord4.zw.x ) - objToWorld50_g458.x ) , ( ( WorldPosition.y - IN.ase_texcoord4.zw.y ) - objToWorld50_g458.y )));
				float2 lerpResult1019 = lerp( uv_MainTex , (appendResult55_g458*_MainTex_ST.xy + _MainTex_ST.zw) , _MainTexUsePositionUV);
				float4 tex2DNode959 = tex2D( _MainTex, lerpResult1019 );
				float3 temp_output_27_0_g461 = tex2DNode959.rgb;
				float temp_output_16_0_g462 = temp_output_27_0_g461.x;
				Gradient gradient2_g462 = NewGradient( 0, 4, 2, float4( 1, 1, 1, 0 ), float4( 0.7991835, 0.7991835, 0.7991835, 0.1176471 ), float4( 0.07750964, 0.07750964, 0.07750964, 0.8382391 ), float4( 0, 0, 0, 0.997055 ), 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
				float2 temp_cast_2 = (_GradientUVOffset).xx;
				float2 texCoord3_g462 = IN.ase_texcoord4.xy * float2( 1,1 ) + temp_cast_2;
				float lerpResult17_g462 = lerp( texCoord3_g462.x , texCoord3_g462.y , _GradientUorV);
				float lerpResult19_g462 = lerp( SampleGradient( gradient2_g462, lerpResult17_g462 ).r , ( 1.0 - SampleGradient( gradient2_g462, lerpResult17_g462 ).r ) , _InvertGradient);
				float clampResult9_g462 = clamp( ( ( -1.0 * _GradientBlendIntensity * lerpResult19_g462 ) + temp_output_16_0_g462 ) , 0.0 , 1.0 );
				float lerpResult21_g462 = lerp( temp_output_16_0_g462 , clampResult9_g462 , _UseGradient);
				float ColorAAlpha5_g461 = _ColorA.a;
				float temp_output_17_0_g461 = ( lerpResult21_g462 + ( -0.35 + ( ColorAAlpha5_g461 * 0.3 ) ) );
				float4 lerpResult21_g461 = lerp( _ColorB , _ColorA , temp_output_17_0_g461);
				float ColorBAlpha6_g461 = _ColorB.a;
				float ColorCAlpha9_g461 = _ColorC.a;
				float4 lerpResult18_g461 = lerp( _ColorC , lerpResult21_g461 , ( temp_output_17_0_g461 + ( 0.45 + ( ColorBAlpha6_g461 * 0.3 ) + ( ColorCAlpha9_g461 * -0.3 ) ) ));
				float3 InputRGB30_g461 = temp_output_27_0_g461;
				float4 lerpResult36_g461 = lerp( lerpResult18_g461 , float4( InputRGB30_g461 , 0.0 ) , _UseOriginColor);
				float3 ase_worldNormal = IN.ase_texcoord5.xyz;
				float4 lerpResult1037 = lerp( float4( 0.5,0.5,0.5,0 ) , tex2D( _MatcapTex, ( ( (mul( UNITY_MATRIX_V, float4( ase_worldNormal , 0.0 ) ).xyz).xy * 0.5 ) + 0.5 ) ) , _MatCapTexIntensity);
				float4 blendOpSrc1033 = lerpResult36_g461;
				float4 blendOpDest1033 = lerpResult1037;
				float4 ClipEdgeColor977 = _EdgeColor;
				float clampResult102_g460 = clamp( ( temp_output_72_0_g460 + EdgeWidth95_g460 ) , -3.0 , 2.0 );
				float EgdeSmoothFixValue100_g460 = ( EdgeSmooth57_g460 * -0.2 );
				float smoothstepResult47_g460 = smoothstep( ( clampResult102_g460 + EgdeSmoothFixValue100_g460 ) , ( clampResult102_g460 + EdgeSmooth57_g460 + EgdeSmoothFixValue100_g460 ) , ClipTex89_g460);
				float ClipEdgeAlpha976 = ( ( 1.0 - smoothstepResult47_g460 ) * _EdgeColor.a );
				float3 lerpResult129_g463 = lerp( ( saturate( (( blendOpDest1033 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest1033 ) * ( 1.0 - blendOpSrc1033 ) ) : ( 2.0 * blendOpDest1033 * blendOpSrc1033 ) ) )).rgb , ClipEdgeColor977.rgb , ClipEdgeAlpha976);
				
#ifdef DISCARD_FRAGMENT
				float DiscardValue = ( VertexAlpha1004 * ClipAlpha975 );
				float DiscardThreshold = 0.001;

				if(DiscardValue < DiscardThreshold)discard;
#endif
				float3 BakedAlbedo = 0;
				float3 BakedEmission = 0;
				float3 Color = ( _TintColor * IN.ase_color * float4( lerpResult129_g463 , 0.0 ) ).rgb;
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
706;478;2189;684;-1731.784;905.4182;2.11348;True;True
Node;AmplifyShaderEditor.CommentaryNode;1070;4250.544,389.1649;Inherit;False;270;209;Comment;1;1068;Particle Center;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;982;3358.111,-311.2093;Inherit;False;1;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;991;3410.555,-116.4487;Inherit;False;Property;_UseCustomData;Use Custom Data;28;2;[Header];[Toggle];Create;True;1;Custom Data;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureTransformNode;1000;4332.603,652.3102;Inherit;False;978;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.TexCoordVertexDataNode;1068;4302.523,447.081;Inherit;False;3;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;989;3638.755,-304.5487;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;1069;3080.481,-1127.081;Inherit;False;260.1904;186.1115;Comment;1;1051;Particle Center;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;1066;4606.278,540.5665;Inherit;False;VFX_PositionUV;-1;;457;f9d906dc205907d44ab7c80e358e2575;0;4;39;FLOAT;0;False;40;FLOAT;0;False;29;FLOAT2;1,1;False;30;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;998;4643.727,391.8538;Inherit;False;0;978;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;996;4630.541,699.8303;Inherit;False;Property;_ClipTexUsePositionUV;ClipTex Use Position UV;20;1;[Toggle];Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;992;3804.139,-303.0924;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TexCoordVertexDataNode;1051;3122.306,-1067.271;Inherit;False;3;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureTransformNode;1016;3247.898,-859.1479;Inherit;False;959;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.LerpOp;995;4931.396,398.7644;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1018;3505.19,-743.4702;Inherit;False;Property;_MainTexUsePositionUV;MainTex Use Position UV;2;1;[Toggle];Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1020;3534.712,-1039.154;Inherit;False;0;959;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;1067;3488.927,-904.7521;Inherit;False;VFX_PositionUV;-1;;458;f9d906dc205907d44ab7c80e358e2575;0;4;39;FLOAT;0;False;40;FLOAT;0;False;29;FLOAT2;1,1;False;30;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;986;4082.633,-340.3483;Inherit;False;DataY1;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;978;5127.983,327.9899;Inherit;True;Property;_ClipTex;ClipTex;19;1;[Header];Create;True;1;Clip;0;0;False;0;False;-1;3313b5d760a88c0499a0a3306d53c25b;314b6cccc1058454f8b55955f4fd7c2b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;1031;5186.137,-1208.301;Inherit;False;VFX_MatCapUV;-1;;459;de666f160bf14ab4ea5b6d6d91e23e45;0;0;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;1019;3836.326,-917.5032;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;994;5279.695,242.0818;Inherit;False;986;DataY1;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;959;4007.617,-946.8096;Inherit;True;Property;_MainTex;MainTex;1;1;[Header];Create;True;1;MainTex;0;0;False;0;False;-1;1a00ca6e281456e4ebe187d579d56d48;7657360bfd51fef4cb47982676ebfc4e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;974;5624.84,361.3006;Inherit;False;VFX_ClipSmoothEdge;21;;460;69e070d297569514d918f7319aa4d435;0;3;62;FLOAT;0;False;24;FLOAT;0;False;87;FLOAT;1;False;4;FLOAT;22;FLOAT;28;COLOR;32;FLOAT;124
Node;AmplifyShaderEditor.SamplerNode;1032;5398.572,-1236.607;Inherit;True;Property;_MatcapTex;MatcapTex;18;0;Create;True;0;0;0;False;0;False;-1;2db1ad595836c194fab5e08f7ce3c814;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1038;5422.205,-1010.564;Inherit;False;Property;_MatCapTexIntensity;MatCapTex Intensity;17;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;965;5459.547,-836.0199;Inherit;True;VFX_GraytoColor;6;;461;4dca6182a64a98847bdebf99782433f1;0;1;27;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;977;6019.717,463.3767;Inherit;False;ClipEdgeColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1037;5756.307,-1258.863;Inherit;False;3;0;COLOR;0.5,0.5,0.5,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;976;6021.797,377.8339;Inherit;False;ClipEdgeAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;1001;6641.18,-901.9737;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1004;6915.089,-742.4846;Inherit;False;VertexAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;975;6023.215,293.3099;Inherit;False;ClipAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;1033;6023.068,-853.73;Inherit;True;Overlay;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;964;5762.534,-616.2504;Inherit;False;976;ClipEdgeAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;966;5771.876,-544.8362;Inherit;False;977;ClipEdgeColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;1023;3029.773,-1339.09;Inherit;False;292;132;Comment;1;1022;Shader Potions;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;1009;6448.491,-1517.491;Inherit;False;975;ClipAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1007;6451.605,-1596.239;Inherit;False;1004;VertexAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1011;6031.614,-1144.657;Inherit;False;Property;_TintColor;TintColor;0;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;967;6432.742,-587.4077;Inherit;False;VFX_ClipEdge;-1;;463;1a8a8b88657c99948944543463522665;0;3;24;FLOAT3;0,0,0;False;135;FLOAT;0;False;136;FLOAT3;0,0,0;False;1;FLOAT3;140
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1002;6934.23,-930.2048;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1005;6720.462,-1415.331;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;987;4033.807,-527.3167;Inherit;False;DataX1;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;970;5854.773,-283.4077;Inherit;False;ClipBlackAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1012;6240.679,-1046.795;Inherit;False;TintColorAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;968;5352.145,-566.1776;Inherit;True;VFX_ClipBlack;3;;464;bca2b1ae1e5a4c544b8f204bdd345f7b;0;2;8;FLOAT4;0,0,0,0;False;18;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1022;3048.773,-1293.09;Inherit;False;Property;_CullMode;Cull Mode;29;2;[Header];[Enum];Create;True;1;Shader Options;2;CullBack;2;CullOff;0;1;UnityEngine.Rendering.CullMode;True;0;False;2;2;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;873;6712.453,-1309.382;Inherit;False;Constant;_Float10;Float 10;45;0;Create;True;0;0;0;False;0;False;0.001;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;985;3981.952,-172.3071;Inherit;False;DataZ1;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;984;3977.123,-95.3245;Inherit;False;DataW1;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;621;4660.794,-1118.745;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;AdditionalPass;0;0;AdditionalPass;6;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;0;False;False;0;Hidden/InternalErrorShader;0;0;Standard;1;MRT Output;0;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;624;4660.794,-693.2109;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;ShadowCaster;0;4;ShadowCaster;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;623;7231.635,-1112.617;Half;False;True;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;21;ASE/VFX/PT_Mesh_AssignColorClip_Opeque;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;Forward;0;3;Forward;12;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;0;True;1022;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;True;0;1;False;-1;0;False;-1;1;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;618;True;3;False;-1;True;False;0;False;-1;0;False;-1;True;1;LightMode=UniversalForwardOnly;False;False;0;Hidden/InternalErrorShader;0;0;Standard;18;Surface;0;637958790616925259;  Blend;0;0;Two Sided;1;0;Cast Shadows;0;637938935950703661;  Use Shadow Threshold;0;0;Receive Shadows;1;0;GPU Instancing;1;0;LOD CrossFade;0;0;Built-in Fog;0;0;DOTS Instancing;0;0;Meta Pass;0;0;Extra Pre Pass;0;0;Full Screen Pass;0;0;Additional Pass;0;0;Scene Selectioin Pass;0;0;Vertex Position,InvertActionOnDeselection;1;0;Discard Fragment;1;637958790682882765;Push SelfShadow to Main Light;0;0;2;MRT Output;0;0;Custom Output Position;0;0;8;False;False;False;True;False;False;False;False;False;;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;627;4660.794,-693.2109;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;Meta;0;7;Meta;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;622;4660.794,-1118.745;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;ExtraPrePass;0;2;ExtraPrePass;6;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;0;False;False;0;Hidden/InternalErrorShader;0;0;Standard;1;MRT Output;0;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;626;4660.794,-1118.745;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;SceneSelectionPass;0;6;SceneSelectionPass;5;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=SceneSelectionPass;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;940;6787.188,-1118.745;Float;False;False;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;1;New Amplify Shader;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;FullScreenPass;0;1;FullScreenPass;4;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;7;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=UniversalForwardOnly;True;2;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;625;4660.794,-693.2109;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;689d3e8c4ac0d7c40a3407d6ee9e04bc;True;DepthOnly;0;5;DepthOnly;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;True;17;d3d9;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;nomrt;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;False;False;True;False;False;False;False;0;False;-1;False;False;False;False;False;False;False;False;False;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
WireConnection;989;1;982;0
WireConnection;989;2;991;0
WireConnection;1066;39;1068;1
WireConnection;1066;40;1068;2
WireConnection;1066;29;1000;0
WireConnection;1066;30;1000;1
WireConnection;992;0;989;0
WireConnection;995;0;998;0
WireConnection;995;1;1066;0
WireConnection;995;2;996;0
WireConnection;1067;39;1051;1
WireConnection;1067;40;1051;2
WireConnection;1067;29;1016;0
WireConnection;1067;30;1016;1
WireConnection;986;0;992;1
WireConnection;978;1;995;0
WireConnection;1019;0;1020;0
WireConnection;1019;1;1067;0
WireConnection;1019;2;1018;0
WireConnection;959;1;1019;0
WireConnection;974;62;994;0
WireConnection;974;24;978;1
WireConnection;1032;1;1031;0
WireConnection;965;27;959;0
WireConnection;977;0;974;32
WireConnection;1037;1;1032;0
WireConnection;1037;2;1038;0
WireConnection;976;0;974;28
WireConnection;1004;0;1001;4
WireConnection;975;0;974;22
WireConnection;1033;0;965;0
WireConnection;1033;1;1037;0
WireConnection;967;24;1033;0
WireConnection;967;135;964;0
WireConnection;967;136;966;0
WireConnection;1002;0;1011;0
WireConnection;1002;1;1001;0
WireConnection;1002;2;967;140
WireConnection;1005;0;1007;0
WireConnection;1005;1;1009;0
WireConnection;987;0;992;0
WireConnection;970;0;968;0
WireConnection;1012;0;1011;4
WireConnection;968;8;959;0
WireConnection;985;0;992;2
WireConnection;984;0;992;3
WireConnection;623;21;1005;0
WireConnection;623;22;873;0
WireConnection;623;2;1002;0
ASEEND*/
//CHKSM=DABE9E06EE51D49D5C7512FEDA1AE31326E25090