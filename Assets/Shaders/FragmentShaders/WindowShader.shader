Shader "FragmentShaders/Window"
{

    Properties
    {
        _Color("Colour", Color) = (1,1,1,1)
        _MainTex("Albedo RGB", 2D) = "white" {}
        _BumpMap("Noise texture", 2D) = "bump" {}
        _Magnitude("Magnitude", Range(0, 1)) = 0.05
    }

    SubShader
    {
        Tags{ "Queue" = "Transparent" 
              "IgnoreProjector" = "True"
              "RenderType" = "Opaque"}

        GrabPass { }

        Pass
        {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

            fixed4 _Color;
            sampler2D _MainTex;
            sampler2D _BumpMap;
            float _Magnitude;

			#include "UnityCG.cginc"
			sampler2D _GrabTexture;

			struct vertInput 
			{
				float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
			};

            struct vertOutput
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
                float4 uvgrab : TEXCOORD1;
            };

            //Vertex Function
			vertOutput vert (vertInput v) 
			{
				vertOutput o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uvgrab = ComputeGrabScreenPos(o.vertex);
                o.texcoord = v.texcoord;
				return o;
			}

            //Fragment function
            half4 frag(vertOutput i) : COLOR
            {
                half4 mainColour = tex2D(_MainTex, i.texcoord);
                half4 bump = tex2D(_BumpMap, i.texcoord);
                half2 distortion = UnpackNormal(bump).rg;

                i.uvgrab.xy += distortion * _Magnitude;

                fixed4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab));

                return col * mainColour * _Color;
            }

            ENDCG
        }

    }

    FallBack "Diffuse"
}

