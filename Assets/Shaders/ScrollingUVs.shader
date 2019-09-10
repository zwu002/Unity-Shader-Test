Shader "ShaderTutorial/ScrollingUVs"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _ScrollXSpeed ("X Scroll Speed", Range(0,10)) = 2
		_ScrollYSpeed ("Y Scroll Speed", Range(0,10)) = 2
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
		fixed4 _Color;
		fixed _ScrollXSpeed;
		fixed _ScrollYSpeed;

        struct Input
        {
            float2 uv_MainTex;
        };
		
        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
			// store UV in fixed2
            fixed2 ScrolledUV = IN.uv_MainTex;

			// create variable for 2 scroll values
			fixed xScrollValue = _ScrollXSpeed * _Time;
			fixed yScrollValue = _ScrollYSpeed * _Time;

			// apply final UV offset
			ScrolledUV += fixed2 (xScrollValue, yScrollValue);

			// apply textures and tint
			half4 c = tex2D(_MainTex, ScrolledUV);
			o.Albedo = c.rgb * _Color;
			o.Alpha = c.a;

        }
        ENDCG
    }
    FallBack "Diffuse"
}
