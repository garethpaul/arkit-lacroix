using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SodaSpawn : MonoBehaviour {

	private const int DefaultMaxSodas = 1000;
	private const float DefaultSpawnIntervalSeconds = 0.1f;
	private const float MinSpawnIntervalSeconds = 0.05f;
	private const float MaxSpawnIntervalSeconds = 5.0f;

	public GameObject sodaObject;
	[Range (1, 1000)]
	public int maxSodas = 1000;
	[Range (MinSpawnIntervalSeconds, MaxSpawnIntervalSeconds)]
	public float spawnIntervalSeconds = DefaultSpawnIntervalSeconds;

	private List<GameObject> sodas = new List<GameObject>();
	private float nextSpawnTime;

	// Use this for initialization
	void Start () {
		RepairMaxSodas ();
		RepairSpawnInterval ();
	}

	void OnEnable () {
		RepairSpawnInterval ();
		nextSpawnTime = Time.time;
	}

	void OnValidate () {
		RepairMaxSodas ();
		RepairSpawnInterval ();
	}
	
	// Update is called once per frame
	void Update () {
		RepairMaxSodas ();
		RepairSpawnInterval ();
		PruneMissingSodas ();

		if (sodaObject == null) {
			return;
		}

		float currentTime = Time.time;
		if (currentTime < nextSpawnTime) {
			return;
		}
		nextSpawnTime = currentTime + spawnIntervalSeconds;

		GameObject soda = Instantiate (sodaObject, this.gameObject.transform.position, this.gameObject.transform.rotation);
		if (soda.GetComponent<Rigidbody> () == null) {
			soda.AddComponent<Rigidbody> ();
		}

		sodas.Add (soda);
		TrimSodasToLimit ();
	}

	void OnDisable () {
		ClearSodas ();
	}

	private void TrimSodasToLimit () {
		while (sodas.Count > maxSodas) {
			GameObject oldestSoda = sodas [0];
			sodas.RemoveAt (0);

			if (oldestSoda != null) {
				Destroy (oldestSoda);
			}
		}
	}

	private void ClearSodas () {
		foreach (GameObject oldSoda in sodas) {
			if (oldSoda != null) {
				Destroy (oldSoda);
			}
		}

		sodas.Clear ();
	}

	private void PruneMissingSodas () {
		for (int i = sodas.Count - 1; i >= 0; i--) {
			if (sodas [i] == null) {
				sodas.RemoveAt (i);
			}
		}
	}

	private void RepairMaxSodas () {
		if (maxSodas < 1 || maxSodas > DefaultMaxSodas) {
			maxSodas = DefaultMaxSodas;
		}
	}

	private void RepairSpawnInterval () {
		if (float.IsNaN (spawnIntervalSeconds) ||
			float.IsInfinity (spawnIntervalSeconds) ||
			spawnIntervalSeconds < MinSpawnIntervalSeconds ||
			spawnIntervalSeconds > MaxSpawnIntervalSeconds) {
			spawnIntervalSeconds = DefaultSpawnIntervalSeconds;
		}
	}
}
