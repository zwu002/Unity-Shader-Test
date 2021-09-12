Shader "ShaderTutorial/OptimizedShader01"
{
    Properties
    {
		_MainTex ("Albedo", 2D) = "white" {}
		_NormalTex ("Normal Map", 2D) = "bump" {}
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf SimpleLambert exclude_path:prepass noforwardadd

		sampler2D _NormalTex;
		sampler2D _MainTex;

        struct Input
        {
            half2 uv_MainTex;
        };

        inline float4 LightingSimpleLambert (SurfaceOutput s, float3 lightDir, float atten)
        {
            fixed diff = max(0, dot(s.Normal, lightDir));
            fixed4 c;
            c.rgb = s.Albedo * _LightColor0.rgb * (diff * atten * 2);
            c.a = s.Alpha;
            return c;
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
            o.Normal = UnpackNormal(tex2D(_NormalTex, IN.uv_MainTex));
        }
        ENDCG
    }
    FallBack "Diffuse"
}
