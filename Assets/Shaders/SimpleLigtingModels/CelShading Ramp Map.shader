Shader "LightingModels/CelShading_RampMap"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white"
		_RampTex ("Ramp", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM

        #pragma surface surf Toon

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
		sampler2D _RampTex;

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

		fixed4 LightingToon (SurfaceOutput s, half3 lightDir, half atten)
		{
			//calculate the dot product of the lighting direction and surface's normal
			half normalDotLength = dot(s.Normal, lightDir);

			// remap normal dot length to the value on the ramp map
			normalDotLength = tex2D(_RampTex, fixed2(normalDotLength, 0.5));


			//set what colour should be returned
			half4 color;
			color.rgb = s.Albedo * _LightColor0.rgb * (normalDotLength * atten);
			color.a = s.Alpha;

			return color;
		}

        ENDCG
    }
    FallBack "Diffuse"
}
