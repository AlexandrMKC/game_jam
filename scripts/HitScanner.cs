using Godot;
using System;

[GlobalClass]
public partial class HitScanner : StaticBody3D, IHittable
{

	[Signal]
	public delegate void HitEventHandler(float damage);
	public void RegisterHit(float damage)
	{
		EmitSignal(SignalName.Hit, damage);
	}

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
