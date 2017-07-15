using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SodaSpawn : MonoBehaviour {

	public GameObject sodaObject;
	private List<GameObject> sodas = new List<GameObject>();

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		GameObject soda = Instantiate (sodaObject, this.gameObject.transform.position, this.gameObject.transform.rotation);
		soda.AddComponent<Rigidbody> ();

		sodas.Add (soda);
		if (sodas.Count >= 1000) {
			foreach (GameObject oldSoda in sodas) {
				Destroy (oldSoda);
			}
			sodas = new List<GameObject> ();
		}
	}
}
