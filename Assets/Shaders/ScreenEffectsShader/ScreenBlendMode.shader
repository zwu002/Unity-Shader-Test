Shader "ShaderTutorial/ScreenBlendMode"
{
    Properties
    {
        _MainTex ("Albedo", 2D) = "white" {}
        _BlendTex ("Blend Texture", 2D) = "white" {}
        _Opacity("Opacity", Range(0.0, 1.0)) = 1.0
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
            uniform sampler2D _BlendTex;
            fixed _Opacity;
            
            fixed4 frag (v2f_img i) : COLOR
            {
                //Get the colours and uvs from RenderTexture from v2f_img struct
                fixed4 renderTex = tex2D(_MainTex, i.uv);
                fixed4 blendTex = tex2D(_BlendTex, i.uv);

                //Perform a multiply Blend mode
                fixed4 blendedMultiply = renderTex * blendTex;

                //Perform an additive Blend mode
                fixed4 blendedAdd = renderTex + blendTex;

                //Perform a screen Blend mode
                fixed4 blendedScreen = (1.0 - ((1.0 - renderTex) * (1.0 - blendTex)));

                //Adjust the amount of Blend mode by a lerp
                renderTex = lerp(renderTex, blendedScreen, _Opacity);
                
                return renderTex;
            }
            ENDCG
        }
    }
    Fallback off
}
