using UnityEngine;
using UnityEngine.VFX;

//[VFXType(VFXTypeAttribute.Usage.GraphicsBuffer)]
//struct CustomData
//{
//    public Vector3 color;
//    public Vector3 position;
//}

public class SetComputeBuffer : MonoBehaviour
{
    [SerializeField] ComputeShader _compute = null;

    [SerializeField, Range(0, 30)] uint ColCount = 6;
    [SerializeField, Range(0, 10)] uint RowCount = 1;
    [SerializeField] Vector2 XRange = Vector2.one;
    [SerializeField] Vector2 YRange = Vector2.one;
    [SerializeField, Range(0, 3)] float Slope = 1;
    [SerializeField, Range(0, 10)] float Speed = 1;

    GraphicsBuffer _buffer;
    void Start()
    {
        _buffer = new GraphicsBuffer
          (GraphicsBuffer.Target.Structured, 64 * 64, 4 * sizeof(float));
        GetComponent<VisualEffect>().SetGraphicsBuffer("SinBuffer", _buffer);
    }

    void OnDestroy()
    {
        _buffer?.Dispose();
        _buffer = null;
    }

    void Update()
    {
        _compute.SetInt("RowCount", (int)RowCount);
        _compute.SetInt("ColCount", (int)ColCount);
        _compute.SetVector("XRange", XRange);
        _compute.SetVector("YRange", YRange);
        _compute.SetFloat("Slope", Slope);
        _compute.SetFloat("Speed", Speed);
        _compute.SetFloat("Time", Time.time);
        _compute.SetBuffer(0, "SinBuffer", _buffer);
        _compute.Dispatch(0, 8, 8, 1);
    }
}
