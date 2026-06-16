using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.iOS;

public class BallMaker : MonoBehaviour {
	private const int DefaultMaxBalls = 100;

	public GameObject ballPrefab;
	public float createHeight;
	[Range (1, DefaultMaxBalls)]
	public int maxBalls = DefaultMaxBalls;
	private MaterialPropertyBlock props;
	private List<GameObject> balls = new List<GameObject> ();

	// Use this for initialization
	void Start () {
		RepairMaxBalls ();
		props = new MaterialPropertyBlock ();

	}

	void OnValidate () {
		RepairMaxBalls ();
	}

	void CreateBall(Vector3 atPosition)
	{
		if (!IsFinitePosition (atPosition)) {
			return;
		}

		if (ballPrefab == null) {
			return;
		}

		GameObject ballGO = Instantiate (ballPrefab, atPosition, Quaternion.identity);
		if (ballGO == null) {
			return;
		}
			
		
		float r = Random.Range(0.0f, 1.0f);
		float g = Random.Range(0.0f, 1.0f);
		float b = Random.Range(0.0f, 1.0f);

		props.SetColor("_InstanceColor", new Color(r, g, b));

		MeshRenderer renderer = ballGO.GetComponent<MeshRenderer>();
		if (renderer != null) {
			renderer.SetPropertyBlock(props);
		}

		balls.Add (ballGO);
		TrimBallsToLimit ();

	}

	// Update is called once per frame
	void Update () {
		RepairMaxBalls ();
		PruneMissingBalls ();
		TrimBallsToLimit ();

		if (Input.touchCount > 0 )
		{
			var touch = Input.GetTouch(0);
			if (touch.phase == TouchPhase.Began)
			{
				var screenPosition = Camera.main.ScreenToViewportPoint(touch.position);
				ARPoint point = new ARPoint {
					x = screenPosition.x,
					y = screenPosition.y
				};
						
				List<ARHitTestResult> hitResults = UnityARSessionNativeInterface.GetARSessionNativeInterface ().HitTest (point, 
					ARHitTestResultType.ARHitTestResultTypeExistingPlaneUsingExtent);
				if (hitResults.Count > 0) {
					foreach (var hitResult in hitResults) {
						Vector3 position = UnityARMatrixOps.GetPosition (hitResult.worldTransform);
						Vector3 spawnPosition = new Vector3 (position.x, position.y + createHeight, position.z);
						if (!IsFinitePosition (spawnPosition)) {
							continue;
						}
						CreateBall (spawnPosition);
						break;
					}
				}

			}
		}

	}

	void OnDisable () {
		ClearBalls ();
	}

	private static bool IsFinitePosition (Vector3 position) {
		return !float.IsNaN (position.x) && !float.IsInfinity (position.x) &&
			!float.IsNaN (position.y) && !float.IsInfinity (position.y) &&
			!float.IsNaN (position.z) && !float.IsInfinity (position.z);
	}

	private void TrimBallsToLimit () {
		while (balls.Count > maxBalls) {
			GameObject oldestBall = balls [0];
			balls.RemoveAt (0);
			if (oldestBall != null) {
				Destroy (oldestBall);
			}
		}
	}

	private void ClearBalls () {
		foreach (GameObject ball in balls) {
			if (ball != null) {
				Destroy (ball);
			}
		}
		balls.Clear ();
	}

	private void PruneMissingBalls () {
		for (int index = balls.Count - 1; index >= 0; index--) {
			if (balls [index] == null) {
				balls.RemoveAt (index);
			}
		}
	}

	private void RepairMaxBalls () {
		if (maxBalls < 1 || maxBalls > DefaultMaxBalls) {
			maxBalls = DefaultMaxBalls;
		}
	}

}
