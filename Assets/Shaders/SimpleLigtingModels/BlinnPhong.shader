Shader "LightingModels/BlinnPhong"
{
    Properties
    {
        _MainTint ("Diffuse Tint", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _SpecularColor ("Specular Color", Color) = (1,1,1,1)
		_SpecPower ("Specular Power", Range(0.1,60)) = 3
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf CustomBlinnPhong

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        float4 _SpecularColor;
		float4 _MainTint;
		float _SpecPower;


        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

		fixed4 LightingCustomBlinnPhong (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten) 
		{
			//Reflection
			float normalDotLength = max(0,dot(s.Normal, lightDir));

			float3 halfVector = normalize(lightDir + viewDir);
			float normalDotHeight = max(0, dot(s.Normal, halfVector));
			float spec = pow(normalDotHeight, _SpecPower) * _SpecularColor;

			float4 color;
			color.rgb = (s.Albedo * _LightColor0.rgb * normalDotLength) + (_LightColor0.rgb * _SpecularColor.rgb * spec) * atten;
			color.a = s.Alpha;
			return color;
		}

        void surf (Input IN, inout SurfaceOutput o)
        {
            half4 c = tex2D (_MainTex, IN.uv_MainTex) * _MainTint;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
