Shader "LightingModels/CelShading_SnapLighting"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white"
		_CelShadingLevels ("Cel Shading Levels", float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM

        #pragma surface surf ToonSnapLighting

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
		float _CelShadingLevels;

        struct Input
        {
            float2 uv_MainTex;
        };

        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
			o.Albedo =tex2D(_MainTex, IN.uv_MainTex).rgb;
        }

		fixed4 LightingToonSnapLighting (SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
		{
			//calculate the dot product of the lighting direction and surface's normal
			half normalDotLength = dot(s.Normal, lightDir);

			// snap lighting
			half cel = floor(normalDotLength * _CelShadingLevels) / (_CelShadingLevels - 0.5);


			//set what colour should be returned
			half4 color;
			color.rgb = s.Albedo * _LightColor0.rgb * (cel * atten);
			color.a = s.Alpha;

			return color;
		}

        ENDCG
    }
    FallBack "Diffuse"
}
