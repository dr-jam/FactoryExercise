using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Aegis;

public class ShieldController : MonoBehaviour   
{
    [SerializeField] private float capacity = 100.0f;
    [SerializeField] private float rechargeRate = 1.0f;
    [SerializeField] private float rechargeDelay = 1.0f;
    [SerializeField] private EffectTypes type = EffectTypes.Kinetic;
    [SerializeField] private EffectTypeColors effectTypeColors;
    [SerializeField] private GameObject scrollingText;
    [SerializeField] private GameObject healthBar;
    [SerializeField] private float currentCapacity = 0.0f;
    private HealthBarController healthBarController;

    void Awake()
    {
        this.currentCapacity = this.capacity;   

        if (!this.healthBar.TryGetComponent<HealthBarController>(out this.healthBarController))
        {
            Debug.Log("ShieldController expects a health bar.");
        }

        this.healthBarController.ChangeValue(this.currentCapacity / this.capacity);

        this.gameObject.GetComponent<Renderer>().material.SetColor("_Color", this.effectTypeColors.GetColorByEffectType(this.type));     
    }

    private void TakeDamage(float damage)
    {
        this.currentCapacity -= damage;
        
        if (this.currentCapacity < 0.0f)
        {
            this.currentCapacity = 0.0f;
        }

        this.healthBarController.ChangeValue(this.currentCapacity / this.capacity);
        
        if(this.scrollingText)
        {
            this.ShowScrollingText(damage.ToString());
        }
    }

    private void ShowScrollingText(string message)
    {
        var scrollingText = Instantiate(this.scrollingText, this.transform.position, Quaternion.identity);
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
        var capacityRatio = this.currentCapacity / this.capacity;
        this.transform.localScale = new Vector3(capacityRatio, capacityRatio, capacityRatio);
        this.gameObject.GetComponent<Renderer>().material.SetColor("_Color", this.effectTypeColors.GetColorByEffectType(this.type));     
    }
}
