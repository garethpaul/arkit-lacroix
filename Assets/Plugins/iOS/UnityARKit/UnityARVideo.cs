using System;
using System.Runtime.InteropServices;
using UnityEngine;
using UnityEngine.Rendering;

namespace UnityEngine.XR.iOS
{

    public class UnityARVideo : MonoBehaviour
    {
        public Material m_ClearMaterial;

        private CommandBuffer m_VideoCommandBuffer;
        private Texture2D _videoTextureY;
        private Texture2D _videoTextureCbCr;

		private UnityARSessionNativeInterface m_Session;
		private bool bCommandBufferInitialized;

		private bool InitializeCommandBuffer()
		{
			Camera videoCamera = GetComponent<Camera>();
			if (videoCamera == null || m_ClearMaterial == null) {
				return false;
			}

			m_VideoCommandBuffer = new CommandBuffer();
			m_VideoCommandBuffer.Blit(null, BuiltinRenderTextureType.CurrentActive, m_ClearMaterial);
			videoCamera.AddCommandBuffer(CameraEvent.BeforeForwardOpaque, m_VideoCommandBuffer);
			bCommandBufferInitialized = true;
			return true;
		}

		private void ReleaseCommandBuffer()
		{
			if (m_VideoCommandBuffer == null) {
				bCommandBufferInitialized = false;
				return;
			}

			Camera videoCamera = GetComponent<Camera>();
			if (videoCamera != null) {
				videoCamera.RemoveCommandBuffer(CameraEvent.BeforeForwardOpaque, m_VideoCommandBuffer);
			}
			m_VideoCommandBuffer.Release();
			m_VideoCommandBuffer = null;
			bCommandBufferInitialized = false;
		}

#if !UNITY_EDITOR
        public void Start()
        {
			m_Session = UnityARSessionNativeInterface.GetARSessionNativeInterface ();
            bCommandBufferInitialized = false;
        }

        private void UpdateVideoTextures(Resolution resolution, ARTextureHandles handles)
        {
            if (_videoTextureY == null || _videoTextureCbCr == null ||
                _videoTextureY.width != resolution.width || _videoTextureY.height != resolution.height) {
                DestroyVideoTextures ();
                _videoTextureY = Texture2D.CreateExternalTexture(resolution.width, resolution.height,
                    TextureFormat.R8, false, false, handles.textureY);
                _videoTextureCbCr = Texture2D.CreateExternalTexture(resolution.width, resolution.height,
                    TextureFormat.RG16, false, false, handles.textureCbCr);
                _videoTextureY.filterMode = FilterMode.Bilinear;
                _videoTextureY.wrapMode = TextureWrapMode.Repeat;
                _videoTextureCbCr.filterMode = FilterMode.Bilinear;
                _videoTextureCbCr.wrapMode = TextureWrapMode.Repeat;
            } else {
                _videoTextureY.UpdateExternalTexture(handles.textureY);
                _videoTextureCbCr.UpdateExternalTexture(handles.textureCbCr);
            }
        }

        public void OnPreRender()
        {
			ARTextureHandles handles = m_Session.GetARVideoTextureHandles();
            if (handles.textureY == System.IntPtr.Zero || handles.textureCbCr == System.IntPtr.Zero)
            {
                return;
            }

            if (!bCommandBufferInitialized && !InitializeCommandBuffer ()) {
                return;
            }

            Resolution currentResolution = Screen.currentResolution;

            // Texture Y
            UpdateVideoTextures(currentResolution, handles);

            m_ClearMaterial.SetTexture("_textureY", _videoTextureY);
            m_ClearMaterial.SetTexture("_textureCbCr", _videoTextureCbCr);
            int isPortrait = 0;

            float rotation = 0;
            if (Screen.orientation == ScreenOrientation.Portrait) {
                rotation = -90;
                isPortrait = 1;
            }
            else if (Screen.orientation == ScreenOrientation.PortraitUpsideDown) {
                rotation = 90;
                isPortrait = 1;
            }
            else if (Screen.orientation == ScreenOrientation.LandscapeRight) {
                rotation = -180;
            }
            Matrix4x4 m = Matrix4x4.TRS (Vector3.zero, Quaternion.Euler(0.0f, 0.0f, rotation), Vector3.one);
            m_ClearMaterial.SetMatrix("_TextureRotation", m);
            m_ClearMaterial.SetFloat("_texCoordScale", m_Session.GetARYUVTexCoordScale());
            m_ClearMaterial.SetInt("_isPortrait", isPortrait);
        }
#else
        public void OnEnable()
        {
            if (!bCommandBufferInitialized) {
                InitializeCommandBuffer ();
            }
        }

#endif

		void OnDisable()
		{
			ReleaseCommandBuffer ();
		}

		void OnDestroy()
		{
			ReleaseCommandBuffer ();
			DestroyVideoTextures ();
		}

        private void DestroyVideoTextures()
        {
            if (_videoTextureY != null) {
                Destroy (_videoTextureY);
                _videoTextureY = null;
            }
            if (_videoTextureCbCr != null) {
                Destroy (_videoTextureCbCr);
                _videoTextureCbCr = null;
            }
        }
    }
}
