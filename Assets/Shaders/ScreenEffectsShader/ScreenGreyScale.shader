Shader "ShaderTutorial/ScreenGreyScale"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Luminosity("Luminosity", Range(0.0, 1.0)) = 1.0
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
            fixed _Luminosity;
            
            fixed4 frag (v2f_img i) : COLOR
            {
                //Get the colours and uvs from RenderTexture from v2f_img struct
                fixed4 renderTex = tex2D(_MainTex, i.uv);

                //Apply Luminosity values to render texture
                float luminosity = 0.299 * renderTex.r + 0.587 * renderTex.g + 0.114 * renderTex.b;

                fixed4 finalColour = lerp(renderTex, luminosity, _Luminosity);
                renderTex.rgb = finalColour;

                return renderTex;
            }
            ENDCG
        }
    }
    Fallback off
}
