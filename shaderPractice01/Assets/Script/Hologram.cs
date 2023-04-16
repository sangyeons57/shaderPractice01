using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Random = UnityEngine.Random;

public class Hologram : MonoBehaviour
{
    private Renderer renderer;

    public float glitchChane = .1f;

    private WaitForSeconds glitchLoopWait = new WaitForSeconds(.1f);
    private WaitForSeconds glitchDuration = new WaitForSeconds(.2f);
    // Start is called before the first frame update
    void Awake()
    {
        renderer = GetComponent<Renderer>();
    }

    private IEnumerator Start()
    {
        while (true)
        {
            float glitchTeset = Random.Range(0.0f, 1.0f);

            if (glitchTeset <= glitchChane) 
            {
                StartCoroutine(Glitch());
            }

            yield return glitchLoopWait;
        }
    }
    
    IEnumerator Glitch()
    {
        Debug.Log("glitchStart");
        glitchDuration = new WaitForSeconds(Random.Range(.05f, .25f));
        renderer.material.SetFloat("_Amount", 1f);
        renderer.material.SetFloat("_CutoutThresh", .29f);
        renderer.material.SetFloat("_Ampitude", Random.Range(100, 250));
        renderer.material.SetFloat("_Speed", Random.Range(5, 10));
        yield return glitchDuration;
        renderer.material.SetFloat("_Amount", 0f);
        renderer.material.SetFloat("_CutoutThresh", 0f);
        Debug.Log("glitchEnd");
    }


    // Update is called once per frame
    void Update()
    {
        
    }
}
