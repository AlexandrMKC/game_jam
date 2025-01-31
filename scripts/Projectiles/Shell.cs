using Godot;
using System;

public partial class Shell : Node3D

{
	[Export]
	private float Speed = 40;
	[Export]
	private float ShellDamage = 20;

	[Export]
	private float RaycastDistance = -0.8f;
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
