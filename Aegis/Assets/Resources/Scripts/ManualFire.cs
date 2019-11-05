using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ManualFire : MonoBehaviour
{
    [SerializeField] private GameObject Projectile;
    [SerializeField] private GameObject ProjectileSpawn;
    
    void Start()
    {
        
    }

    
    void Update()
    {
        if(Input.GetButtonDown("Jump"))
        {
            Instantiate(this.Projectile, this.ProjectileSpawn.transform.position, Quaternion.identity);
        }
    }
}
