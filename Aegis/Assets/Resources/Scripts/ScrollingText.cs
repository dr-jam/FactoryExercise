using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScrollingText : MonoBehaviour
{
    [SerializeField] private float ScrollingTextTime = 1.5f;
    [SerializeField] private Vector3 Offset = new Vector3(-1.0f, 1.0f, 0.0f);
    // Start is called before the first frame update
    void Start()
    {
        Debug.Log(this.transform.position);
        this.transform.position = this.transform.position + this.Offset;
        Debug.Log(this.transform.position);
        Destroy(this.gameObject, this.ScrollingTextTime);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
