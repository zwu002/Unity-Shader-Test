Shader "VertexShaders/SnowShader"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
		_Color ("Main Color", Color) = (1,1,1,1)
		_Bump ("Bump Map", 2D) = "bump" {}
		_Snow ("Level of Snow", Range(-1,1)) = 1
		_SnowColor ("Color of Snow", Color) = (1,1,1,1)
		_SnowDirection ("Direction of Snow", Vector) = (0,1,0)
		_SnowDepth ("Depth of Snow", Range(0,1)) = 0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard vertex:vert

        #pragma target 3.0

		sampler2D _MainTex;
		sampler2D _Bump;
		float _Snow;
		float4 _SnowColor;
		float4 _Color;
		float4 _SnowDirection;
		float _SnowDepth;

        struct Input
        {
            float2 uv_MainTex;
			float2 uv_Bump;
			float3 worldNormal;
			INTERNAL_DATA
        };


        UNITY_INSTANCING_BUFFER_START(Props)

        UNITY_INSTANCING_BUFFER_END(Props)

		void vert (inout appdata_full v) 
		{
			float4 sn = mul(UNITY_MATRIX_IT_MV, _SnowDirection);

			if (dot(v.normal, sn.xyz) >= _Snow) {
				v.vertex.xyz += (sn.xyz + v.normal) * _SnowDepth * _Snow;
			}
		}

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            half4 color = tex2D (_MainTex, IN.uv_MainTex);
			
			o.Normal = UnpackNormal(tex2D(_Bump, IN.uv_Bump));
			
			if (dot(WorldNormalVector(IN, o.Normal), _SnowDirection.xyz) >= _Snow)
			{
				o.Albedo = _SnowColor.rgb;
			}
			else 
			{
				o.Albedo = color.rgb * _Color;
			}
			o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
