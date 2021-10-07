using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HightlightOnHover : MonoBehaviour
{
    public Color highlightColor = Color.red;

    private Material material;

    // Initialization
    void Start()
    {
        material = GetComponent<MeshRenderer>().material;

        OnMouseExit();
    }

    private void OnMouseOver()
    {
        material.SetColor("HoverColour", highlightColor);
    }

    private void OnMouseExit()
    {
        material.SetColor("HoverColour", Color.black);    
    }
}
