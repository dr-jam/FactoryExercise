using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Aegis;

public class ShieldController : MonoBehaviour
{
    [SerializeField] private float Capacity = 100.0f;
    [SerializeField] private float RechargeRate = 1.0f;
    [SerializeField] private float RechargeDelay = 1.0f;
    [SerializeField] private EffectTypes Type = EffectTypes.Kinetic;
    [SerializeField] private GameObject ScrollingText;
    [SerializeField] private GameObject HealthBar;
    private float CurrentCapacity = 0.0f;
    private HealthBarController healthBarController;

    // Start is called before the first frame update
    void Start()
    {
        //health bar verification
        this.CurrentCapacity = this.Capacity;
        
        if (!this.HealthBar.TryGetComponent<HealthBarController>(out this.healthBarController))
        {
            Debug.Log("ShieldController expects a health bar.");
        }
        this.healthBarController.ChangeValue(this.CurrentCapacity / this.Capacity);
    }

    private void TakeDamage(float damage)
    {
        this.CurrentCapacity -= damage;
        this.healthBarController.ChangeValue(this.CurrentCapacity / this.Capacity);
        if (this.Capacity < 0.0f)
        {
            this.Capacity = 0.0f;
        }

        if(this.ScrollingText)
        {
            this.ShowScrollingText(this.CurrentCapacity.ToString());
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
