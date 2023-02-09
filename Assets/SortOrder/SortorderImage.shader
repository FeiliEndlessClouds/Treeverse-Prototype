// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SortorderImage"
{
    Properties
    {
        _MainTex("MainTex", 2D) = "white" {}
        _Color("Color", Color) = (1,1,1,1)
        [HideInInspector] _texcoord( "", 2D ) = "white" {}
        
        _StencilComp ("Stencil Comparison", Float) = 8
        _Stencil ("Stencil ID", Float) = 0
        _StencilOp ("Stencil Operation", Float) = 0
        _StencilWriteMask ("Stencil Write Mask", Float) = 255
        _StencilReadMask ("Stencil Read Mask", Float) = 255
        
        _ColorMask ("Color Mask", Float) = 15
        
        [Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
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
        ZTest Always
        Blend One OneMinusSrcAlpha
        ColorMask [_ColorMask]
        
        
        Pass
        {
            Name "Forward"
            Tags { "LightMode"="SRPDefaultUnlit" }
            
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
            ZWrite Off
            ZTest Always
            Offset 0 , 0
            ColorMask RGBA
            
            CGPROGRAM
            
            #define SUPPORT_CLIP_RECT 1
            
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0
            
            #include "UnityCG.cginc"
            #include "UnityUI.cginc"
            #ifdef SUPPORT_CLIP_RECT
            #pragma multi_compile_local _ UNITY_UI_CLIP_RECT
            #endif
            #pragma multi_compile_local _ UNITY_UI_ALPHACLIP
            
            #define ASE_NEEDS_FRAG_COLOR
            struct appdata_t
            {
                float4 vertex: POSITION;
                float4 color    : COLOR;
                float2 texcoord: TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                
            };
            
            struct v2f
            {
                float4 vertex: SV_POSITION;
                fixed4 color    : COLOR;
                float2 texcoord: TEXCOORD0;
                float4 worldPosition: TEXCOORD1;
                float4 mask: TEXCOORD2;
                float3 maskUV: TEXCOORD3;
                UNITY_VERTEX_OUTPUT_STEREO
                
            };
            
            float4 _ClipRect;
            float _UIMaskSoftnessX;
            float _UIMaskSoftnessY;
            uniform float4 _Color;
            uniform sampler2D _MainTex;
            uniform float4 _MainTex_ST;
            
                        
            v2f vert(appdata_t input )
            {
                v2f output = (v2f)0;
                UNITY_SETUP_INSTANCE_ID(input);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);
                float4 vPosition = UnityObjectToClipPos(input.vertex);
                
                float2 pixelSize = vPosition.w;
                pixelSize /= float2(1, 1) * abs(mul((float2x2)UNITY_MATRIX_P, _ScreenParams.xy));
                
                float4 clampedRect = clamp(_ClipRect, -2e10, 2e10);
                output.maskUV = float3((input.vertex.xy - clampedRect.xy) / (clampedRect.zw - clampedRect.xy), 0.0);
                output.mask = float4(input.vertex.xy * 2 - clampedRect.xy - clampedRect.zw, 0.25 / (0.25 * half2(_UIMaskSoftnessX, _UIMaskSoftnessY) + abs(pixelSize.xy)));
                
                
                output.worldPosition = input.vertex;
                output.vertex = vPosition;
                output.texcoord = input.texcoord;
                output.color = input.color;
                return output;
            }
            
            fixed4 frag(v2f IN ): SV_Target
            {
                //Round up the alpha color coming from the interpolator (to 1.0/256.0 steps)
                //The incoming alpha could have numerical instability, which makes it very sensible to
                //HDR color transparency blend, when it blends with the world's texture.
                const half alphaPrecision = half(0xff);
                const half invAlphaPrecision = half(1.0 / alphaPrecision);
                IN.color.a = round(IN.color.a * alphaPrecision) * invAlphaPrecision;
                
                float3 worldPosition = IN.maskUV;
                float2 uv_MainTex = IN.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                
                
                fixed4 color = ( _Color * tex2D( _MainTex, uv_MainTex ) * IN.color );
                half2 m = saturate((_ClipRect.zw - _ClipRect.xy - abs(IN.mask.xy)) * IN.mask.zw);
                #ifdef SUPPORT_CLIP_RECT
                    #ifdef UNITY_UI_CLIP_RECT
                    color.a *= m.x * m.y;
                    #endif
                #else
                    half rectMask = m.x * m.y;
                    color.rgb = lerp(IN.color.rgb, color.rgb, rectMask);
                    color.a = max(color.a, (1.0 - rectMask) * IN.color.a);
                #endif
                #ifdef UNITY_UI_ALPHACLIP
                    clip(color.a - 0.001);
                #endif
                return color;
            }
            ENDCG
            
        }
    }
    CustomEditor "ASEMaterialInspector"
    
    
}
/*ASEBEGIN
Version=18935
2560;116;1706.667;908.3334;953.9999;487;1;True;False
Node;AmplifyShaderEditor.SamplerNode;1;-359.9999,14.66666;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;2;-366.9999,-216.3333;Inherit;False;Property;_Color;Color;1;0;Create;True;0;0;0;False;0;False;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;4;-363.9999,-415.3333;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;20.00012,-292.3333;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;212,-29;Float;False;True;-1;2;ASEMaterialInspector;0;20;SortorderImage;ce0bf6a6e544803479533b89b14999b1;True;Forward;0;0;Forward;1;False;True;3;1;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;True;True;True;True;True;0;True;-7;False;False;False;False;False;False;False;True;True;0;True;-3;255;True;-6;255;True;-5;0;True;-2;0;True;-4;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;True;2;False;-1;True;7;False;-9;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;False;0;False;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=SRPDefaultUnlit;True;0;False;0;;0;0;Standard;1;Support Clip Rect;1;0;0;1;True;False;;False;0
WireConnection;3;0;2;0
WireConnection;3;1;1;0
WireConnection;3;2;4;0
WireConnection;0;1;3;0
ASEEND*/
//CHKSM=178146FC98FD5ED786EECAEE6C51DA102DD2AB18