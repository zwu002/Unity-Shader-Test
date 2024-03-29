using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class RenderDepth : MonoBehaviour
{
    #region Variables
    public Shader curShader;
    public float depthPower = 0.2f;
    private Material screenMat;
    #endregion


    #region Preperties
    Material ScreenMat
    {
        get
        {
            if (screenMat == null)
            {
                screenMat = new Material(curShader);
                screenMat.hideFlags = HideFlags.HideAndDontSave;
            }
            return screenMat;
        }
    }
    #endregion

    private void Start()
    {
        if (!SystemInfo.supportsImageEffects)
        {
            enabled = false;
            return;
        }

        if (!curShader && !curShader.isSupported)
        {
            enabled = false;
        }
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (curShader != null)
        {
            ScreenMat.SetFloat("_DepthPower", depthPower);

            Graphics.Blit(source, destination, ScreenMat);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }

    void Update()
    {
        Camera.main.depthTextureMode = DepthTextureMode.Depth;
        depthPower = Mathf.Clamp(depthPower, 0, 1);
    }

    void OnDisable()
    {
        if (screenMat)
        {
            DestroyImmediate(screenMat);
        }
    }
}
