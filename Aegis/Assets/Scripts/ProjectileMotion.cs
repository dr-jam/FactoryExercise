using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class ProjectileMotion : MonoBehaviour
{
    [SerializeField] private Vector3 MuzzleVelocity = new Vector3(-200.0f, 0f, 0f);

    public void Fire()
    {
        this.GetComponent<Rigidbody>().AddForce(this.MuzzleVelocity);
    }

    private void OnTriggerEnter(Collider other)
    {
        Destroy(this.gameObject);
    }

}
