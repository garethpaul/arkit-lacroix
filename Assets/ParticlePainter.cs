using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.iOS;

public class ParticlePainter : MonoBehaviour {
    private const float DefaultMinDistanceThreshold = 0.05f;
    private const float DefaultMaxDistanceThreshold = 1.0f;
    private const int DefaultMaxPaintVertices = 10000;
    private const int DefaultMaxPaintSystems = 32;

    public ParticleSystem painterParticlePrefab;
    public float minDistanceThreshold;
    public float maxDistanceThreshold;
    private bool frameUpdated = false;
    public float particleSize = .1f;
    public float penDistance = 0.2f;
    [Range (1, DefaultMaxPaintVertices)]
    public int maxPaintVertices = DefaultMaxPaintVertices;
    [Range (1, DefaultMaxPaintSystems)]
    public int maxPaintSystems = DefaultMaxPaintSystems;
    public ColorPicker colorPicker;
    private ParticleSystem currentPS;
    private ParticleSystem.Particle [] particles;
    private Vector3 previousPosition = Vector3.zero;
    private List<Vector3> currentPaintVertices;
    private Color currentColor = Color.white;
    private List<ParticleSystem> paintSystems;
    private int paintMode = 0;  //0 = off, 1 = pick color, 2 = paint
    private bool isInitialized = false;
    private bool eventsSubscribed = false;
    private bool hasPreviousPosition = false;

    private bool IsValidDistanceThreshold (float value)
    {
        return !float.IsNaN (value) && !float.IsInfinity (value) && value > 0.0f;
    }

    private void RepairDistanceThresholds ()
    {
        if (!IsValidDistanceThreshold (minDistanceThreshold) ||
            !IsValidDistanceThreshold (maxDistanceThreshold) ||
            maxDistanceThreshold <= minDistanceThreshold) {
            minDistanceThreshold = DefaultMinDistanceThreshold;
            maxDistanceThreshold = DefaultMaxDistanceThreshold;
        }
    }

    private void RepairMaxPaintVertices ()
    {
        if (maxPaintVertices < 1 || maxPaintVertices > DefaultMaxPaintVertices) {
            maxPaintVertices = DefaultMaxPaintVertices;
        }
    }

    private void RepairMaxPaintSystems ()
    {
        if (maxPaintSystems < 1 || maxPaintSystems > DefaultMaxPaintSystems) {
            maxPaintSystems = DefaultMaxPaintSystems;
        }
    }

    private void EnsureParticleBuffer ()
    {
        if (particles == null || particles.Length != maxPaintVertices) {
            particles = new ParticleSystem.Particle[maxPaintVertices];
        }
    }

    private void TrimCurrentPaintVerticesToLimit ()
    {
        if (currentPaintVertices.Count <= maxPaintVertices) {
            return;
        }

        currentPaintVertices.RemoveRange (
            maxPaintVertices,
            currentPaintVertices.Count - maxPaintVertices);
        frameUpdated = true;
    }

    private void TrimPaintSystemsToLimit ()
    {
        if (paintSystems == null) {
            return;
        }

        while (paintSystems.Count >= maxPaintSystems) {
            ParticleSystem oldestPaintSystem = paintSystems [0];
            paintSystems.RemoveAt (0);
            if (oldestPaintSystem != null) {
                Destroy (oldestPaintSystem.gameObject);
            }
        }
    }

    private void ClearPaintSystems ()
    {
        if (currentPS != null) {
            Destroy (currentPS.gameObject);
            currentPS = null;
        }

        if (paintSystems == null) {
            return;
        }

        foreach (ParticleSystem paintSystem in paintSystems) {
            if (paintSystem != null) {
                Destroy (paintSystem.gameObject);
            }
        }
        paintSystems.Clear ();
    }

    void OnValidate ()
    {
        RepairDistanceThresholds ();
        RepairMaxPaintVertices ();
        RepairMaxPaintSystems ();
    }

	// Use this for initialization
	void Start () {
        RepairDistanceThresholds ();
        RepairMaxPaintVertices ();
        RepairMaxPaintSystems ();

        if (painterParticlePrefab == null) {
            Debug.LogError ("ParticlePainter requires a painter particle prefab.");
            enabled = false;
            return;
        }

        if (colorPicker == null) {
            Debug.LogError ("ParticlePainter requires a color picker.");
            enabled = false;
            return;
        }

        currentPS = Instantiate (painterParticlePrefab);
        if (currentPS == null) {
            Debug.LogError ("ParticlePainter could not create its particle system.");
            enabled = false;
            return;
        }

        currentPaintVertices = new List<Vector3> ();
        EnsureParticleBuffer ();
        paintSystems = new List<ParticleSystem> ();
        frameUpdated = false;
        isInitialized = true;
        SubscribeToEvents ();
        colorPicker.gameObject.SetActive (false);
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
    }

    void OnDestroy ()
    {
        UnsubscribeFromEvents ();
        ClearPaintSystems ();
    }

    private void SubscribeToEvents ()
    {
        if (eventsSubscribed || colorPicker == null) {
            return;
        }

        UnityARSessionNativeInterface.ARFrameUpdatedEvent += ARFrameUpdated;
        colorPicker.onValueChanged.AddListener (HandleColorChanged);
        eventsSubscribed = true;
    }

    private void UnsubscribeFromEvents ()
    {
        if (!eventsSubscribed) {
            return;
        }

        UnityARSessionNativeInterface.ARFrameUpdatedEvent -= ARFrameUpdated;
        if (colorPicker != null) {
            colorPicker.onValueChanged.RemoveListener (HandleColorChanged);
        }
        eventsSubscribed = false;
    }

    private void HandleColorChanged (Color newColor)
    {
        currentColor = newColor;
    }

    public void ARFrameUpdated(UnityARCamera camera)
    {
        if (!isInitialized || currentPaintVertices == null) {
            return;
        }

        Camera mainCamera = Camera.main;
        if (mainCamera == null) {
            return;
        }

        Matrix4x4 matrix = new Matrix4x4();
        matrix.SetColumn(3, camera.worldTransform.column3);
      
        Vector3 currentPosition = UnityARMatrixOps.GetPosition(matrix) + (mainCamera.transform.forward * penDistance);
        if (!hasPreviousPosition) {
            previousPosition = currentPosition;
            hasPreviousPosition = true;
            return;
        }

        float distance = Vector3.Distance (currentPosition, previousPosition);
        if (distance < minDistanceThreshold) {
            return;
        }

        previousPosition = currentPosition;
        if (distance > maxDistanceThreshold) {
            return;
        }

        if (paintMode == 2 && currentPaintVertices.Count < maxPaintVertices) {
            currentPaintVertices.Add (currentPosition);
            frameUpdated = true;
        }
    }

    void OnGUI()
    {
        if (!isInitialized) {
            return;
        }

        string modeString = paintMode == 0 ? "OFF" : (paintMode == 1 ? "PICK" : "PAINT");
        if (GUI.Button(new Rect(Screen.width -100.0f, 0.0f, 100.0f, 50.0f), modeString))
         {
            paintMode = (paintMode + 1) % 3;
            colorPicker.gameObject.SetActive (paintMode == 1);
            if (paintMode == 2)
                RestartPainting ();
         }
        
    }
	
    void RestartPainting()
    {
        if (!isInitialized || currentPS == null) {
            return;
        }

        paintSystems.Add (currentPS);
        RepairMaxPaintSystems ();
        TrimPaintSystemsToLimit ();
        currentPS = Instantiate (painterParticlePrefab);
        currentPaintVertices = new List<Vector3> ();
        EnsureParticleBuffer ();
    }

	// Update is called once per frame
	void Update () {
        if (!isInitialized || currentPS == null || currentPaintVertices == null) {
            return;
        }

        RepairMaxPaintVertices ();
        RepairMaxPaintSystems ();
        TrimPaintSystemsToLimit ();
        TrimCurrentPaintVerticesToLimit ();
        EnsureParticleBuffer ();

        if (frameUpdated && paintMode == 2) {
            if ( currentPaintVertices.Count > 0) {
                int numParticles = currentPaintVertices.Count;
                int index = 0;
                foreach (Vector3 currentPoint in currentPaintVertices) {     
                    particles [index].position = currentPoint;
                    particles [index].startColor = currentColor;
                    particles [index].startSize = particleSize;
                    index++;
                }
                currentPS.SetParticles (particles, numParticles);
            } else {
                particles [0].startSize = 0.0f;
                currentPS.SetParticles (particles, 1);
            }
            frameUpdated = false;
        }
	}
}
