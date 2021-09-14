Shader "ShaderTutorial/ScreenBSC"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Brightness("Brightness", Range(0.0, 1.0)) = 1.0
        _Saturation("Saturation", Range(0.0, 1.0)) = 1.0
        _Contrast("Contrast", Range(0.0, 1.0)) = 1.0
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #pragma fragmentoption ARB_precision_hint_fastest

            #include "UnityCG.cginc"
            
            uniform sampler2D _MainTex;
            fixed _Brightness;
            fixed _Saturation;
            fixed _Contrast;
            
            float3 ContrastSaturationBrightness (float3 color, float brt, float sat, float con)
            {
                //default values for r, g, b channels
                float AvgLumR = 0.5;
                float AvgLumG = 0.5;
                float AvgLumB = 0.5;

                //Luminance coefficients for getting luminance from the image
                float3 luminanceCoeff = float3(0.2125, 0.7154, 0.0721);

                //Brightness
                float3 AvgLumin = float3(AvgLumR, AvgLumG, AvgLumB);
                float3 brtColor = color * brt;
                float intensityf = dot(brtColor, luminanceCoeff);
                float3 intensity = float3(intensityf, intensityf, intensityf);

                //Saturation
                float3 satColor = lerp(intensity, brtColor, sat);
                
                //Contrast
                float3 conColor = lerp(AvgLumin, satColor, con);

                return conColor;
            }

            fixed4 frag (v2f_img i) : COLOR
            {
                //Get the colours and uvs from RenderTexture from v2f_img struct
                fixed4 renderTex = tex2D(_MainTex, i.uv);

                //Apply BSC OPERATIONS
                renderTex.rgb = ContrastSaturationBrightness(renderTex.rgb, _Brightness, _Saturation, _Contrast);
                return renderTex;
            }
            ENDCG
        }
    }
    Fallback off
}
