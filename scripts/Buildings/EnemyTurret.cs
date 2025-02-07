using Godot;
using System;

[GlobalClass]
public partial class EnemyTurret : Node3D
{
	[Export]
	private float DetectionRange = 20;
	[Export(PropertyHint.Range, "0,180,0.001,degrees")]
	private float MaximumFiringAngle = 15;
	[Export]
	private float RotationSpeedOverride = 0.0f;
	[Export]
	public HealthComponent Health;
	[ExportCategory("Objects Raycast")]
	[Export(PropertyHint.Layers3DPhysics)]
	private uint RaycastCollisionMask = 2;

	// @onready
	private Turret TurretWeapon;
	private HitScanner HitScanner;
	private FireRateTimer FireRate;
	private Area3D DetectionArea;
	private SphereShape3D DetectionAreaShape;

	private Node3D _target = null;

	public override void _Ready()
	{
		if (Health == null)
		{
			GD.PushError("Missing health component! ", Name);
		}
		TurretWeapon = GetNode<Turret>("Turret");
		if (TurretWeapon == null)
		{
			GD.PushError("Missing turret node! ", Name);
		}
		HitScanner = GetNode<HitScanner>("HitScanner");
		if (HitScanner == null)
		{
			GD.PushError("Missing hit scanner node! ", Name);
		}
		FireRate = GetNode<FireRateTimer>("FireRateTimer");
		if (FireRate == null)
		{
			GD.PushError("Missing fire rate timer node! ", Name);
		}
		DetectionArea = GetNode<Area3D>("DetectionArea");
		if (DetectionArea == null)
		{
			GD.PushError("Missing detection area node! ", Name);
		}
		DetectionAreaShape = (SphereShape3D)GetNode<CollisionShape3D>("DetectionArea/DetectionAreaShape").Shape;
		if (DetectionAreaShape == null)
		{
			GD.PushError("Missing detection area shape! ", Name);
		}

		Health.HealthDepleted += OnHealthDepleted;
		FireRate.Fire += TurretWeapon.Shoot;
		HitScanner.Hit += OnProjectileHit;

		DetectionArea.BodyEntered += OnDetectionAreaBodyEntered;
		DetectionArea.BodyExited += OnDetectionAreaBodyExited;

		DetectionAreaShape.Radius = DetectionRange;

		TurretWeapon.OverrideRotationSpeed(RotationSpeedOverride);
	}


	public override void _PhysicsProcess(double delta)
	{
		if (_target == null)
		{
			FireRate.Deactivate();
			return;
		}
		TurretWeapon.RotateTo(_target.GlobalPosition);
		if (!Blocked() && IsClose())
		{
			FireRate.Activate();
		}
		else
		{
			FireRate.Deactivate();
		}
	}

	// Assume target is not null
	private Vector3 VectorToTarget()
	{
		return (_target.GlobalPosition - GlobalPosition).Normalized();
	}

	private bool Blocked()
	{
		var space = GetWorld3D().DirectSpaceState;
		var from = TurretWeapon.GlobalPosition;
		var to = _target.GlobalPosition;
		var query = PhysicsRayQueryParameters3D.Create(from, to, RaycastCollisionMask);
		var collision = space.IntersectRay(query);
		if (collision.Count != 0)
		{
			if (collision["collider"].AsGodotObject() is not Player player)
			{
				return true;
			}
		}
		return false;
	}

	private bool IsClose()
	{
		return TurretWeapon.GetForwardDirection().AngleTo(VectorToTarget()) <= Mathf.DegToRad(MaximumFiringAngle);
	}

	private void OnHealthDepleted()
	{
		QueueFree();
	}

	private void OnProjectileHit(float damage)
	{
		Health.TakeDamage(damage);
	}

	private void OnDetectionAreaBodyEntered(Node3D body)
	{
		_target = body;
	}
	private void OnDetectionAreaBodyExited(Node3D body)
	{
		_target = null;
	}
}
