using System;
using System.Numerics;
using Unity.Mathematics;
using UnityEngine;
using UnityEngine.Splines;
using UnityEngine.UIElements;

public class SplinGenerator : MonoBehaviour
{
    SplineContainer _container;
    Spline[] _splines;

    [SerializeField] int splineCount = 3;

    [SerializeField] Rect waveRect;
    //[SerializeField] Vector2 startPoint;
    //[SerializeField] Vector2 endPoint;

    [SerializeField, Range(1, 10)] int waveCount = 10;
    [SerializeField, Range(0, 1)] float waveAmplitude = 0.8f;

    [SerializeField, Range(0, 90)] float tangentAngle = 0;
    [SerializeField, Range(0, 2)] float tangentIntensity = 1;

    void CreateSplines()
    {
        //foreach (Spline sp in _container.Splines) sp.Clear();
        _splines = new Spline[splineCount];
        for (int j = 0; j < splineCount; j++)
        {
            Spline spline = new Spline();
            _container.AddSpline(spline);
            _splines[j] = spline;
        }
    }

    void UpdateSpline(Rect waveZoom)
    {
        //foreach (Spline sp in _container.Splines) sp.Clear();

        for (int j = 0; j < splineCount; j++)
        {
            //Spline spline = new Spline();
            var knots = new BezierKnot[waveCount * 2 + 1];

            var sp = new float2(waveZoom.xMin, waveZoom.yMin + waveZoom.height * (j + 0.5f) / splineCount);
            var ep = new float2(waveZoom.xMax, waveZoom.yMin + waveZoom.height * (j + 0.5f) / splineCount);

            var seg = (ep - sp) / waveCount;
            var tangent = tangentIntensity * new float3(Mathf.Cos(tangentAngle * Mathf.Deg2Rad), Mathf.Sin(tangentAngle * Mathf.Deg2Rad), 0);
            for (int i = 0; i < waveCount; i++)
            {
                float2 p1 = sp + seg * i;
                float2 p2 = sp + seg * (i + 1);
                knots[i * 2] = new BezierKnot(new float3(p1.x, p1.y + waveAmplitude / 2, 0f), new float3(-tangent.x, -tangent.y, 0), new float3(tangent.x, -tangent.y, 0));
                knots[i * 2 + 1] = new BezierKnot(new float3(p1.x + seg.x / 2, p1.y + seg.y / 2 - waveAmplitude / 2, 0f), new float3(-tangent.x, tangent.y, 0), new float3(tangent.x, tangent.y, 0));
            }
            //print(waveCount * 4 + 1);
            knots[waveCount * 2] = new BezierKnot(new float3(ep.x, ep.y + waveAmplitude / 2, 0f), new float3(-tangent.x, -tangent.y, 0), new float3(tangent.x, -tangent.y, 0));

            _splines[j].Knots = knots;
            //_container.AddSpline(spline);
        }
    }

    private void OnBoolChangedEvent(ChangeEvent<bool> evt)
    {
        Debug.Log($"Toggle changed. Old value: {evt.previousValue}, new value: {evt.newValue}");
    }

    void Start()
    {
        _container = GetComponent<SplineContainer>();
        //_splines = new Spline[splineCount];
        //foreach (Spline sp in _splines)
        //{

        //sp = _container.AddSpline();
        //}
        CreateSplines();
    }

    // Update is called once per frame
    void Update()
    {
        UpdateSpline(waveRect);

        //UpdateSpline(waveRect);
        //if ()
        //{
        //    CreateSplines();
        //}
    }
}
