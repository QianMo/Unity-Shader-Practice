//write by Unity document Version: 2017.2

Shader "ShaderPrac/Session00/01-ShaderSyntax"
{
	
	Properties
	{
		//----------------------------------------------【1、Properties】------------------------------------------------
		// https://docs.unity3d.com/Manual/SL-Properties.html
		//---------------------------------------------------------------------------------------------------------------
		// 1) Numbers and Sliders
		// name ("display name", Range (min, max)) = number
		// name ("display name", Float) = number
		// name ("display name", Int) = number

		// 2) Colors and Vectors
		// name ("display name", Color) = (number,number,number,number)
		// name ("display name", Vector) = (number,number,number,number)

		// 3) Textures
		// name ("display name", 2D) = "defaulttexture" {}
		// name ("display name", Cube) = "defaulttexture" {}
		// name ("display name", 3D) = "defaulttexture" {}

		// 4) Property attributes and drawers
		// [HideInInspector] - does not show the property value in the material inspector.
		// [NoScaleOffset] - material inspector will not show texture tiling/offset fields for texture properties with this attribute.
		// [Normal] - indicates that a texture property expects a normal-map.
		// [HDR] - indicates that a texture property expects a high-dynamic range (HDR) texture.
		// [Gamma] - indicates that a float/vector property is specified as sRGB value in the UI (just like colors are), and possibly needs conversion according to color space used. See Properties in Shader Programs.
		// [PerRendererData] - indicates that a texture property will be coming from per-renderer data in the form of a MaterialPropertyBlock. Material inspector changes the texture slot UI for these properties.

		// 5) Example
		_WaveScale ("Wave scale", Range (0.02,0.15)) = 0.07 // sliders
		_ReflDistort ("Reflection distort", Range (0,1.5)) = 0.5
		_RefrDistort ("Refraction distort", Range (0,1.5)) = 0.4
		_RefrColor ("Refraction color", Color) = (.34, .85, .92, 1) // color
		_ReflectionTex ("Environment Reflection", 2D) = "" {} // textures
		_RefractionTex ("Environment Refraction", 2D) = "" {}
		_Fresnel ("Fresnel (A) ", 2D) = "" {}
		_BumpMap ("Bumpmap (RGB) ", 2D) = "" {}
		//---------------------------------------------------------------------------------------------------------------
		//---------------------------------------------------------------------------------------------------------------
	}


	//Vertex & Fragment Shader
	SubShader
	{

		//--------------------------------------------【2、Pass Tags】---------------------------------------------------
		// Subshaders use tags to tell how and when they expect to be rendered to the rendering engine.
		// https://docs.unity3d.com/Manual/SL-SubShaderTags.html
		//---------------------------------------------------------------------------------------------------------------
		// 1) Syntax
		// Tags { "TagName1" = "Value1" "TagName2" = "Value2" }
		// Tags are basically key-value pairs. Inside a SubShader tags are used to determine rendering order and other parameters of a subshader. 
		// Note that the following tags recognized by Unity must be inside SubShader section and not inside Pass!
		// In addition to built-in tags recognized by Unity, you can use your own tags and query them using Material.GetTag function.

		// 2) Rendering Order - Queue tag
		// You can determine in which order your objects are drawn using the Queue tag. 
		// A Shader decides which render queue its objects belong to, this way any Transparent shaders make sure they are drawn after all opaque objects and so on.

		// There are four pre-defined render queues, but there can be more queues in between the predefined ones. The predefined queues are:

		// - Background - this render queue is rendered before any others. You’d typically use this for things that really need to be in the background.
		// - Geometry (default) - this is used for most objects. Opaque geometry uses this queue.
		// - AlphaTest - alpha tested geometry uses this queue. It’s a separate queue from Geometry one since it’s more efficient to render alpha-tested objects after all solid ones are drawn.
		// - Transparent - this render queue is rendered after Geometry and AlphaTest, in back-to-front order. Anything alpha-blended (i.e. shaders that don’t write to depth buffer) should go here (glass, particle effects).
		// - Overlay - this render queue is meant for overlay effects. Anything rendered last should go here (e.g. lens flares).

		// Queues up to 2500 (“Geometry+500”) are consided “opaque” and optimize the drawing order of the objects for best performance. 
		// Higher rendering queues are considered for “transparent objects” and sort objects by distance, starting rendering from the furthest ones and ending with the closest ones. 
		// Skyboxes are drawn in between all opaque and all transparent objects.

		// 3) RenderType tag
		// RenderType tag categorizes shaders into several predefined groups, e.g. is is an opaque shader, or an alpha-tested shader etc. 
		// This is used by Shader Replacement and in some cases used to produce camera’s depth texture.

		// 4) DisableBatching tag
		// Some shaders (mostly ones that do object-space vertex deformations) do not work when Draw Call Batching is used – that’s because batching transforms all geometry into world space, so “object space” is lost.
		// DisableBatching tag can be used to incidate that. There are three possible values: 
		// “True” (always disables batching for this shader), 
		// “False” (does not disable batching; this is default) and “LODFading” (disable batching when LOD fading is active; mostly used on trees).

		// 5) ForceNoShadowCasting tag
		// If ForceNoShadowCasting tag is given and has a value of “True”, then an object that is rendered using this subshader will never cast shadows. 
		// This is mostly useful when you are using shader replacement on transparent objects and you do not wont to inherit a shadow pass from another subshader.

		// 6) IgnoreProjector tag
		// If IgnoreProjector tag is given and has a value of “True”, then an object that uses this shader will not be affected by Projectors. 
		// This is mostly useful on semitransparent objects, because there is no good way for Projectors to affect them.

		// 7) CanUseSpriteAtlas tag
		// Set CanUseSpriteAtlas tag to “False” if the shader is meant for sprites, and will not work when they are packed into atlases (see Sprite Packer).

		// 8) PreviewType tag
		// PreviewType indicates how the material inspector preview should display the material. 
		// By default materials are displayed as spheres, but PreviewType can also be set to “Plane” (will display as 2D) or “Skybox” (will display as skybox).

		// 9) Example
		//Tags {"Queue" = "Overlay" }
		Tags {"Queue" = "Geometry+1" "ForceNoShadowCasting" = "True" "CanUseSpriteAtlas"="False" "PreviewType" = "Plane"}




		Pass
		{
			//--------------------------------------------【3、Pass Tags】---------------------------------------------------
			// Passes use tags to tell how and when they expect to be rendered to the rendering engine.
			// https://docs.unity3d.com/Manual/SL-PassTags.html
			//---------------------------------------------------------------------------------------------------------------
			// 1) Syntax
			// Tags { "TagName1" = "Value1" "TagName2" = "Value2" }
			// Tags are basically key-value pairs. Inside a Pass tags are used to control which role this pass has in the lighting pipeline (ambient, vertex lit, pixel lit etc.) and some other options. 
			// Note that the following tags recognized by Unity must be inside Pass section and not inside SubShader!

			// 2) LightMode tag
			// LightMode tag defines Pass’ role in the lighting pipeline. 
			// These tags are rarely used manually; most often shaders that need to interact with lighting are written as Surface Shaders and then all those details are taken care of.
			// Possible values for LightMode tag are:
			// - Always: Always rendered; no lighting is applied.
			// - ForwardBase: Used in Forward rendering, ambient, main directional light, vertex/SH lights and lightmaps are applied.
			// - ForwardAdd: Used in Forward rendering; additive per-pixel lights are applied, one pass per light.
			// - Deferred: Used in Deferred Shading; renders g-buffer.
			// - ShadowCaster: Renders object depth into the shadowmap or a depth texture.
			// - MotionVectors: Used to calculate per-object motion vectors.
			// - PrepassBase: Used in legacy Deferred Lighting, renders normals and specular exponent.
			// - PrepassFinal: Used in legacy Deferred Lighting, renders final color by combining textures, lighting and emission.
			// - Vertex: Used in legacy Vertex Lit rendering when object is not lightmapped; all vertex lights are applied.
			// - VertexLMRGBM: Used in legacy Vertex Lit rendering when object is lightmapped; on platforms where lightmap is RGBM encoded (PC & console).
			// - VertexLM: Used in legacy Vertex Lit rendering when object is lightmapped; on platforms where lightmap is double-LDR encoded (mobile platforms).

			// 3) PassFlags tag
			// A pass can indicate flags that change how rendering pipeline passes data to it. 
			// This is done by using PassFlags tag, with a value that is space-separated flag names. Currently the flags supported are:
			// - OnlyDirectional: When used in ForwardBase pass type, this flag makes it so that only the main directional light and ambient/lightprobe data is passed into the shader. 
			// 					  This means that data of non-important lights is not passed into vertex-light or spherical harmonics shader variables. See Forward rendering for details.

			// 4) RequireOptions tag
			// A pass can indicate that it should only be rendered when some external conditions are met. 
			// This is done by using RequireOptions tag, whose value is a string of space separated options. 
			// Currently the options supported by Unity are:
			// - SoftVegetation: Render this pass only if Soft Vegetation is on in Quality Settings.

			//5) Example
			Tags { "LightMode" = "ForwardBase" "PassFlags"="OnlyDirectional" "RequireOptions"= "SoftVegetation"}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			fixed4  _RefrColor;

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
				return _RefrColor;
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
