using Godot;
using System;

[GlobalClass]
public partial class FireRateTimer : Node
{
    private static readonly float _timeToRate = 60.0f;

    [Export(PropertyHint.Range, "0,10000,0.01,or_greater,suffix:Shots/Min")]
    public float FireRate = 0;

    [Signal]
    public delegate void FireEventHandler();

    private float _totalTimeInbetween = 0;
    private float _time = 0;
    private bool _noFire = true;

    public override void _Ready()
    {
        if (Mathf.IsZeroApprox(FireRate))
        {
            _noFire = true;
            return;
        }
        _totalTimeInbetween = _timeToRate / FireRate;
        _time = _totalTimeInbetween;
    }

    public override void _Process(double delta)
    {
        _time -= (float)delta;
        if (_time <= 0)
        {
            // maybe change later
            _time = _noFire ? 0 : _totalTimeInbetween;
            if (_noFire)
            {
                return;
            }
            EmitSignal(SignalName.Fire);
        }
    }

    public void Activate()
    {
        _noFire = false;
    }

    public void Deactivate()
    {
        _noFire = true;
    }
}
