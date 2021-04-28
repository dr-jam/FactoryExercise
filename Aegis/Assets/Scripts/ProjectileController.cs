using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Aegis;

[RequireComponent(typeof(ProjectileMotion))]
public class ProjectileController : MonoBehaviour
{
    [SerializeField] private float Damage = 20.0f;
    [SerializeField] private float ChargeDelay = 1.0f;
    [SerializeField] private EffectTypes Type = EffectTypes.Kinetic;
    private float ChargeTimer = 0.0f;
    private bool Fired = false;

    void Start()
    {
        this.ChargeTimer = 0f;
        this.transform.localScale = new Vector3(0.01f, 0.01f, 0.01f);
    }

    public float GetDamage()
    {
        return this.Damage;
    }

    public EffectTypes GetEffectType()
    {
        return this.Type;
    }

    void Update()
    {
        if(this.ChargeTimer > this.ChargeDelay && !this.Fired)
        {
            this.GetComponent<ProjectileMotion>().Fire();
            this.Fired = true;
        }
        else if(!this.Fired)
        {
            this.ChargeTimer += Time.deltaTime;
            var scale = this.ChargeTimer / this.ChargeDelay;
            //var scale = this.transform.localScale * scale;
            this.transform.localScale = new Vector3(scale, scale, scale);
        }
    }
}
