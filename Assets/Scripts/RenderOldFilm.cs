using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class RenderOldFilm : MonoBehaviour
{
    #region Variables
    public Shader curShader;
    public float oldFilmEffectAmount = 1.0f;

    public Color sepiaColor = Color.white;
    public Texture2D vignetteTexture;
    public float vignetteAmount = 1.0f;

    public Texture2D scratchesTexture;
    public float scratchesXSpeed = 10.0f;
    public float scratchesYSpeed = 10.0f;

    public Texture2D dustTexture;
    public float dustXSpeed = 10.0f;
    public float dustYSpeed = 10.0f;

    private float randomValue;
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
            ScreenMat.SetColor("_SepiaColor", sepiaColor);
            ScreenMat.SetFloat("_VignetteAmount", vignetteAmount);
            ScreenMat.SetFloat("_EffectAmount", oldFilmEffectAmount);

            if (vignetteTexture)
            {
                ScreenMat.SetTexture("_VignetteTex", vignetteTexture);
            }

            if (scratchesTexture)
            {
                ScreenMat.SetTexture("_ScratchesTex", scratchesTexture);
                ScreenMat.SetFloat("_ScratchesXSpeed", scratchesXSpeed);
                ScreenMat.SetFloat("_ScratchesYSpeed", scratchesYSpeed);
            }

            if (dustTexture)
            {
                ScreenMat.SetTexture("_DustTex", dustTexture);
                ScreenMat.SetFloat("_dustXSpeed", dustXSpeed);
                ScreenMat.SetFloat("_dustYSpeed", dustYSpeed);
            }

            Graphics.Blit(source, destination, ScreenMat);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }

    void Update()
    {
        vignetteAmount = Mathf.Clamp01(vignetteAmount);
        oldFilmEffectAmount = Mathf.Clamp(oldFilmEffectAmount, 0.0f, 1.5f);
        randomValue = Random.Range(-1f, 1f);
    }

    void OnDisable()
    {
        if (screenMat)
        {
            DestroyImmediate(screenMat);
        }
    }
}
