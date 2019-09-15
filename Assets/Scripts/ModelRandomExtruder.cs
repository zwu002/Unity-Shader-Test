using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ModelRandomExtruder : MonoBehaviour
{

    void Start()
    {
        float amount = Random.Range(-0.0001f, 0.0001f);

        Material material = GetComponent<Renderer>().sharedMaterial;
        Material newMaterial = new Material(material);
        newMaterial.SetFloat("_Amount", amount);
        GetComponent<Renderer>().material = newMaterial;
    }

}
