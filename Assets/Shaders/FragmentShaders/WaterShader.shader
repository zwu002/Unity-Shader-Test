Shader "FragmentShaders/Water"
{

    Properties
    {
        _Colour("Colour", Color) = (1,1,1,1)
        _NoiseTex("Noise Texture", 2D) = "white" {}
        _Period("Period", Range(0, 50)) = 1
        _Scale("Scale", Range(0, 10)) = 1
        _Magnitude("Magnitude", Range(0, 1)) = 0.05
    }

    SubShader
    {
        Tags{ "Queue" = "Transparent" 
              "IgnoreProjector" = "True"
              "RenderType" = "Opaque"}

        GrabPass {  }

        Pass
        {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

            fixed4 _Colour;
            sampler2D _NoiseTex;
            
            float _Period;
            float _Scale;
            float _Magnitude;

			#include "UnityCG.cginc"
			sampler2D _GrabTexture;

			struct vertInput 
			{
				float4 vertex : POSITION;
                fixed4 color : COLOR;
                float2 texcoord : TEXCOORD0;
			};

            struct vertOutput
            {
                float4 vertex : POSITION;
                fixed4 color: COLOR;
                float2 texcoord : TEXCOORD0;
                float4 worldPos : TEXCOORD1;
                float4 uvgrab : TEXCOORD2;
            };

            //Vertex Function
			vertOutput vert (vertInput v) 
			{
				vertOutput o;
				o.vertex = UnityObjectToClipPos(v.vertex);
                o.color = v.color;
                o.texcoord = v.texcoord;

				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.uvgrab = ComputeGrabScreenPos(o.vertex);

				return o;
			}

            //Fragment function
            fixed4 frag(vertOutput i) : COLOR
            {
                float sinT = sin(_Time.w / _Period);

                float distX = tex2D(_NoiseTex, i.worldPos.xy / _Scale + float2(sinT, 0)).r - 0.5;
                float distY = tex2D(_NoiseTex, i.worldPos.xy / _Scale + float2(0, sinT)).r - 0.5;

                float2 distortion = float2 (distX, distY);
                i.uvgrab.xy += distortion * _Magnitude;

                fixed4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab));

                return col * _Colour;
            }

            ENDCG
        }

    }

    FallBack "Diffuse"
}

