Shader "VertexShaders/SimpleVertexColor"
{
    Properties
    {
        _MainTint ("Colour Tint", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert vertex:vert

        #pragma target 3.0

		fixed4 _MainTint;

        struct Input
        {
            float2 uv_MainTex;
			float4 vertColor;
        };


        UNITY_INSTANCING_BUFFER_START(Props)

        UNITY_INSTANCING_BUFFER_END(Props)

		void vert (inout appdata_full v, out Input o)
		{
			UNITY_INITIALIZE_OUTPUT(Input, o);
			o.vertColor = v.color;
		}

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = IN.vertColor.rgb * _MainTint.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
