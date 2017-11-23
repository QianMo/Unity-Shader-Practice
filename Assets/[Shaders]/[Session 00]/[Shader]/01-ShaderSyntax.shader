Shader "ShaderPrac/Session00/01-ShaderSyntax"
{
	//----------------------------------------------【1、Properties】------------------------------------------------
	// https://docs.unity3d.com/Manual/SL-Properties.html
	//---------------------------------------------------------------------------------------------------------------
	Properties
	{
		//1、Numbers and Sliders
		// name ("display name", Range (min, max)) = number
		// name ("display name", Float) = number
		// name ("display name", Int) = number

		//2、Colors and Vectors
		// name ("display name", Color) = (number,number,number,number)
		// name ("display name", Vector) = (number,number,number,number)

		//3、Textures
		// name ("display name", 2D) = "defaulttexture" {}
		// name ("display name", Cube) = "defaulttexture" {}
		// name ("display name", 3D) = "defaulttexture" {}

		//4、Property attributes and drawers
		// [HideInInspector] - does not show the property value in the material inspector.
		// [NoScaleOffset] - material inspector will not show texture tiling/offset fields for texture properties with this attribute.
		// [Normal] - indicates that a texture property expects a normal-map.
		// [HDR] - indicates that a texture property expects a high-dynamic range (HDR) texture.
		// [Gamma] - indicates that a float/vector property is specified as sRGB value in the UI (just like colors are), and possibly needs conversion according to color space used. See Properties in Shader Programs.
		// [PerRendererData] - indicates that a texture property will be coming from per-renderer data in the form of a MaterialPropertyBlock. Material inspector changes the texture slot UI for these properties.

		//5、Example
		_WaveScale ("Wave scale", Range (0.02,0.15)) = 0.07 // sliders
		_ReflDistort ("Reflection distort", Range (0,1.5)) = 0.5
		_RefrDistort ("Refraction distort", Range (0,1.5)) = 0.4
		_RefrColor ("Refraction color", Color) = (.34, .85, .92, 1) // color
		_ReflectionTex ("Environment Reflection", 2D) = "" {} // textures
		_RefractionTex ("Environment Refraction", 2D) = "" {}
		_Fresnel ("Fresnel (A) ", 2D) = "" {}
		_BumpMap ("Bumpmap (RGB) ", 2D) = "" {}
	}


	//Vertex & Fragment Shader
	SubShader
	{
		Pass
		{
			//----------------------------------------------【2、Tags】------------------------------------------------------
			// Passes use tags to tell how and when they expect to be rendered to the rendering engine.
			// https://docs.unity3d.com/Manual/SL-PassTags.html
			//---------------------------------------------------------------------------------------------------------------
			Tags { "LightMode" = "ForwardBase"}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			//=============================================
			//SV_POSITION-剪裁空间中的顶点坐标
			//此函数需完成顶点坐标从模型空间到裁剪空间的变换
			float4 vert(float4 v:POSITION):SV_POSITION
			{
				//float4 UnityObjectToClipPos(float4 pos)等价于：mul(UNITY_MATRIX_MVP, float4(pos)),
				return UnityObjectToClipPos(v);
			}

			//=============================================
			//此函数需返回对应屏幕上该像素的颜色值
			//SV_Target- Multiple Render Targets,MRT,渲染目标的语义，表示渲染给那个渲染目标。SV_Target等价于SV_Target0
			//同理还有SV_Target1, SV_Target2, …
			//更多语义可参考https://docs.unity3d.com/Manual/SL-ShaderSemantics.html
			float4 frag():SV_Target
			{
				return float4(0.1,0.1,0.6,0.6);
			}



			ENDCG
		}
	}

	//Surface Shader
	SubShader
	{
		//----------------------------------------------【1、Properties】------------------------------------------------
		// https://docs.unity3d.com/Manual/SL-Properties.html
		//---------------------------------------------------------------------------------------------------------------
		Tags{"RenderType" = "Opaque"}
		LOD 200
		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows

		#pragma target 3.0

		struct Input
		{
			float2 uv_MainTex;
		};

		fixed4  _RefrColor;

		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			o.Albedo = _RefrColor.rgb;
		}
		ENDCG
	}

	



	FallBack "Diffuse"
}
