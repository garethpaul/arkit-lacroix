using System.Runtime.InteropServices;
using UnityEngine.XR.iOS;

namespace UnityEngine.XR.iOS
{
    public class UnityARAmbient : MonoBehaviour
    {

        private Light l;
		private UnityARSessionNativeInterface m_Session;

        public void Start()
        {
#if !UNITY_EDITOR
			EnsureAmbientDependencies ();
#endif
        }
#if !UNITY_EDITOR
		private bool EnsureAmbientDependencies ()
		{
			if (l == null) {
				l = GetComponent<Light>();
			}

			if (m_Session == null) {
				m_Session = UnityARSessionNativeInterface.GetARSessionNativeInterface ();
			}

			return l != null && m_Session != null;
		}

        public void Update()
        {
            if (!EnsureAmbientDependencies ()) {
                return;
            }

            // Convert ARKit intensity to Unity intensity
            // ARKit ambient intensity ranges 0-2000
            // Unity ambient intensity ranges 0-8 (for over-bright lights)
            float newai = m_Session.GetARAmbientIntensity();
            l.intensity = newai / 1000.0f;
        }
#endif
    }
}
