Shader "ShaderPrac/Session6/02-Texture"
{
	Properties
	{
		_Color("Color",Color) = (1,1,1,1)
		_MainTex ("Alebedo (RGB)" ,2D)="white" {}
		_Glossiness ("Smothness" , Range(0,1)) = 0.5
		_Metallic ("Metallic" , Range(0,1)) = 0.0

	}
	SubShader
	{
		Tags{"RenderType" = "Opaque"}
		LOD 200
		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows

		#pragma target 3.0

		struct Input
		{
			float2 uv_MainTex;
		};

		fixed4  _Color;

		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			o.Albedo = _Color.rgb;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
