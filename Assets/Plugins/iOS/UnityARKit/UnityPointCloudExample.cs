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
            HideAllPoints ();
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
        ClearFrameState ();
    }

    public void OnDestroy()
    {
        UnsubscribeFromEvents ();
        ClearFrameState ();
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
    }

    private void ClearFrameState()
    {
        m_PointCloudData = null;
        HideAllPoints ();
    }

    private void HideAllPoints ()
    {
        if (pointCloudObjects == null)
        {
            return;
        }

        foreach (GameObject pointCloudObject in pointCloudObjects)
        {
            if (pointCloudObject != null)
            {
                pointCloudObject.SetActive (false);
            }
        }
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

    private static bool IsFinitePoint(Vector4 point)
    {
        return !float.IsNaN (point.x) && !float.IsInfinity (point.x) &&
            !float.IsNaN (point.y) && !float.IsInfinity (point.y) &&
            !float.IsNaN (point.z) && !float.IsInfinity (point.z);
    }

    public void ARFrameUpdated(UnityARCamera camera)
    {
        m_PointCloudData = camera.pointCloudData;
    }

    public void Update()
    {
        if (PointCloudPrefab != null && pointCloudObjects != null)
        {
            int displayedPointCount = m_PointCloudData == null
                ? 0
                : Math.Min (m_PointCloudData.Length, pointCloudObjects.Count);
            for (int count = 0; count < pointCloudObjects.Count; count++)
            {
                GameObject point = pointCloudObjects [count];
                if (point == null)
                {
                    continue;
                }

                Vector4 pointData = count < displayedPointCount
                    ? m_PointCloudData [count]
                    : Vector4.zero;
                bool pointIsVisible = count < displayedPointCount && IsFinitePoint (pointData);
                point.SetActive (pointIsVisible);
                if (pointIsVisible)
                {
                    point.transform.position = new Vector3(pointData.x, pointData.y, pointData.z);
                }
            }
        }
    }
}
