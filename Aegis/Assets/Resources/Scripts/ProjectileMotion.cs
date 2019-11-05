using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class ProjectileMotion : MonoBehaviour
{
    [SerializeField] private Vector3 MuzzleVelocity = new Vector3(10.0f, 0f, 0f);

    void Start()
    {
        this.GetComponent<Rigidbody>().AddForce(this.MuzzleVelocity);
    }


    private void OnTriggerEnter(Collider other)
    {
        Destroy(this.gameObject);
    }

}
