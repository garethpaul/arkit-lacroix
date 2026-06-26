using UnityEngine;
using System.Collections;

public class ColorPickerTester : MonoBehaviour 
{

    public new Renderer renderer;
    public ColorPicker picker;

	// Use this for initialization
	void Start () 
    {
		picker.onValueChanged.AddListener(ColorChanged);
		renderer.material.color = picker.CurrentColor;
	}

	void OnDestroy ()
	{
		if (picker != null)
		{
			picker.onValueChanged.RemoveListener(ColorChanged);
		}
	}

	void ColorChanged (Color color)
	{
		renderer.material.color = color;
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
