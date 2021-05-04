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
    [SerializeField] private float CurrentCapacity = 0.0f;
    private HealthBarController healthBarController;

    void Start()
    {
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
        
        if (this.CurrentCapacity < 0.0f)
        {
            this.CurrentCapacity = 0.0f;
        }

        this.healthBarController.ChangeValue(this.CurrentCapacity / this.Capacity);
        
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
        if ("Projectile" == other.tag)
        {
            var damage = other.GetComponent<ProjectileController>().GetDamage();
            TakeDamage(damage);
        }
    }

    // Update is called once per frame
    void Update()
    {
        var capacityRatio = this.CurrentCapacity / this.Capacity;
        this.transform.localScale = new Vector3(capacityRatio, capacityRatio, capacityRatio);
    }
}
