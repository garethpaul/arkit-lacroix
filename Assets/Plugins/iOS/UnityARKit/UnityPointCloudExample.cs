using System;
using UnityEngine;
using UnityEngine.XR.iOS;
using System.Collections.Generic;

public class UnityPointCloudExample : MonoBehaviour
{
    public uint numPointsToShow = 100;
    public GameObject PointCloudPrefab = null;
    private List<GameObject> pointCloudObjects;
    private Vector3[] m_PointCloudData;
    private bool isInitialized;
    private bool eventsSubscribed;

    public void Start()
    {
        if (PointCloudPrefab != null)
        {
            pointCloudObjects = new List<GameObject> ();
            for (int i =0; i < numPointsToShow; i++)
            {
                pointCloudObjects.Add (Instantiate (PointCloudPrefab));
            }
        }
        isInitialized = true;
        SubscribeToEvents ();
    }

    public void OnEnable()
    {
        if (isInitialized)
        {
            SubscribeToEvents ();
        }
    }

    public void OnDisable()
    {
        UnsubscribeFromEvents ();
    }

    public void OnDestroy()
    {
        UnsubscribeFromEvents ();
        if (pointCloudObjects != null)
        {
            foreach (GameObject pointCloudObject in pointCloudObjects)
            {
                if (pointCloudObject != null)
                {
                    Destroy (pointCloudObject);
                }
            }
            pointCloudObjects.Clear ();
            pointCloudObjects = null;
        }
        m_PointCloudData = null;
    }

    private void SubscribeToEvents()
    {
        if (eventsSubscribed)
        {
            return;
        }

        UnityARSessionNativeInterface.ARFrameUpdatedEvent += ARFrameUpdated;
        eventsSubscribed = true;
    }

    private void UnsubscribeFromEvents()
    {
        if (!eventsSubscribed)
        {
            return;
        }

        UnityARSessionNativeInterface.ARFrameUpdatedEvent -= ARFrameUpdated;
        eventsSubscribed = false;
    }

    public void ARFrameUpdated(UnityARCamera camera)
    {
        m_PointCloudData = camera.pointCloudData;
    }

    public void Update()
    {
        if (PointCloudPrefab != null && m_PointCloudData != null)
        {
            for (int count = 0; count < Math.Min (m_PointCloudData.Length, numPointsToShow); count++)
            {
                Vector4 vert = m_PointCloudData [count];
                GameObject point = pointCloudObjects [count];
                point.transform.position = new Vector3(vert.x, vert.y, vert.z);
            }
        }
    }
}
