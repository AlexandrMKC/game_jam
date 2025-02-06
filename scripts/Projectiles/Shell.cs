using Godot;
using System;


public partial class Shell : Node3D

{
	[Export]
	private float Speed = 40.0f;
	[Export]
	private float ShellDamage = 20;
	[Export]
	private float RaycastDistance = -0.8f;

	// @onready
	private MeshInstance3D Mesh;
	private RayCast3D RayCast;
	private Timer DestructTimer;

	private float _baseSpeed = 40.0f;
	private float _shellDamage = 0f;

	public override void _Ready()
	{
		Mesh = GetNode<MeshInstance3D>("Mesh");
		if (Mesh == null)
		{
			GD.PushError("Missing shell mesh! ", Name);
		}
		RayCast = GetNode<RayCast3D>("RayCast3D");
		if (RayCast == null)
		{
			GD.PushError("Missing shell Raycast! ", Name);
		}
		DestructTimer = GetNode<Timer>("DestructTimer");
		if (DestructTimer == null)
		{
			GD.PushError("Missing shell Destruct timer! ", Name);
		}

		_shellDamage = ShellDamage;

		RayCast.TargetPosition = RayCast.TargetPosition with { Z = RaycastDistance * Speed / _baseSpeed };
		DestructTimer.Timeout += OnTimerTimeout;
	}

	public override void _PhysicsProcess(double delta)
	{
		Position += Transform.Basis * Vector3.Forward * Speed * (float)delta;
		if (RayCast.IsColliding())
		{
			Mesh.Visible = false;
			var collider = RayCast.GetCollider();
			if (collider is IHittable hittable)
			{
				hittable.RegisterHit(_shellDamage);
			}
			QueueFree();
		}
	}

	public void OverrideShellDamage(float damage)
	{
		_shellDamage = damage;
	}

	private void OnTimerTimeout()
	{
		QueueFree();
	}
}
