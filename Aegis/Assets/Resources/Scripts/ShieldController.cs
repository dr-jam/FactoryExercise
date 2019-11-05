using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Aegis;

public class ShieldController : MonoBehaviour
{
    [SerializeField] private float Capacity = 10.0f;
    [SerializeField] private float RechargeRate = 1.0f;
    [SerializeField] private float RechargeDelay = 1.0f;
    [SerializeField] private EffectTypes Type = EffectTypes.Kinetic;
    [SerializeField] private GameObject ScrollingText;
    

    // Start is called before the first frame update
    void Start()
    {
        //health bar
    }

    private void TakeDamage(float damage)
    {
        if(this.ScrollingText)
        {
            this.ShowScrollingText(damage.ToString());
        }
    }

    private void ShowScrollingText(string message)
    {
        var scrollingText = Instantiate(this.ScrollingText, this.transform.position, Quaternion.identity);
        scrollingText.GetComponent<TextMesh>().text = message;
    }

    private void OnTriggerEnter(Collider other)
    {
        TakeDamage(20.0f);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
