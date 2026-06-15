using UnityEngine;
using UnityEngine.XR.iOS;

public class PointCloudParticleExample : MonoBehaviour {
    public ParticleSystem pointCloudParticlePrefab;
    public int maxPointsToShow;
    public float particleSize = 1.0f;
    private Vector3[] m_PointCloudData;
    private bool frameUpdated = false;
    private ParticleSystem currentPS;
    private bool isInitialized;
    private bool eventsSubscribed;

	// Use this for initialization
	void Start () {
        currentPS = Instantiate (pointCloudParticlePrefab);
        frameUpdated = false;
		isInitialized = true;
		SubscribeToEvents ();
	}

	void OnEnable ()
	{
		if (isInitialized) {
			SubscribeToEvents ();
		}
	}

	void OnDisable ()
	{
		UnsubscribeFromEvents ();
		ClearFrameState ();
	}

	void OnDestroy ()
	{
		UnsubscribeFromEvents ();
		ClearFrameState ();
		if (currentPS != null) {
			Destroy (currentPS.gameObject);
			currentPS = null;
		}
	}

	private void ClearFrameState ()
	{
		m_PointCloudData = null;
		frameUpdated = false;
	}

	private void SubscribeToEvents ()
	{
		if (eventsSubscribed) {
			return;
		}

		UnityARSessionNativeInterface.ARFrameUpdatedEvent += ARFrameUpdated;
		eventsSubscribed = true;
	}

	private void UnsubscribeFromEvents ()
	{
		if (!eventsSubscribed) {
			return;
		}

		UnityARSessionNativeInterface.ARFrameUpdatedEvent -= ARFrameUpdated;
		eventsSubscribed = false;
	}
	
    public void ARFrameUpdated(UnityARCamera camera)
    {
        m_PointCloudData = camera.pointCloudData;
        frameUpdated = true;
    }

	// Update is called once per frame
	void Update () {
        if (frameUpdated) {
            if (m_PointCloudData != null && m_PointCloudData.Length > 0) {
                int numParticles = Mathf.Min (m_PointCloudData.Length, maxPointsToShow);
                ParticleSystem.Particle[] particles = new ParticleSystem.Particle[numParticles];
                for (int index = 0; index < numParticles; index++) {
                    Vector3 currentPoint = m_PointCloudData [index];
                    particles [index].position = currentPoint;
                    particles [index].startColor = new Color (1.0f, 1.0f, 1.0f);
                    particles [index].startSize = particleSize;
                }
                currentPS.SetParticles (particles, numParticles);
            } else {
                ParticleSystem.Particle[] particles = new ParticleSystem.Particle[1];
                particles [0].startSize = 0.0f;
                currentPS.SetParticles (particles, 1);
            }
            frameUpdated = false;
        }
	}
}
