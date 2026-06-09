using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SodaSpawn : MonoBehaviour {

	private const int DefaultMaxSodas = 1000;

	public GameObject sodaObject;
	[Range (1, 1000)]
	public int maxSodas = 1000;

	private List<GameObject> sodas = new List<GameObject>();

	// Use this for initialization
	void Start () {
		RepairMaxSodas ();
	}

	void OnValidate () {
		RepairMaxSodas ();
	}
	
	// Update is called once per frame
	void Update () {
		RepairMaxSodas ();

		if (sodaObject == null) {
			return;
		}

		GameObject soda = Instantiate (sodaObject, this.gameObject.transform.position, this.gameObject.transform.rotation);
		if (soda.GetComponent<Rigidbody> () == null) {
			soda.AddComponent<Rigidbody> ();
		}

		sodas.Add (soda);
		if (sodas.Count >= maxSodas) {
			ClearSodas ();
		}
	}

	void OnDisable () {
		ClearSodas ();
	}

	private void ClearSodas () {
		foreach (GameObject oldSoda in sodas) {
			if (oldSoda != null) {
				Destroy (oldSoda);
			}
		}

		sodas.Clear ();
	}

	private void RepairMaxSodas () {
		if (maxSodas < 1 || maxSodas > DefaultMaxSodas) {
			maxSodas = DefaultMaxSodas;
		}
	}
}
