using Godot;
using System;

[GlobalClass]
public partial class ShieldBuilding : Node3D
{
	[Export]
	private HealthComponent Health;
	[Export]
	private bool OverrideShieldInvincibility;
	[Export]
	private Building Target;

	// @onready
	private HitScanner HitScanner;

	public override void _Ready()
	{
		if (Health == null)
		{
			GD.PushError("Missing health component! ", Name);
		}
		if (Target == null)
		{
			GD.PushError("Missing target node! ", Name);
		}
		HitScanner = GetNode<HitScanner>("HitScanner");
		if (HitScanner == null)
		{
			GD.PushError("Missing hit scanner node! ", Name);
		}

		Health.HealthDepleted += OnHealthDepleted;
		Target.Shield.Activate(OverrideShieldInvincibility);
		HitScanner.Hit += OnProjectileHit;
	}

	private void OnHealthDepleted()
	{
		if (Target != null)
		{
			Target.Shield.Deactivate();
		}
		QueueFree();
	}

	private void OnProjectileHit(float damage)
	{
		Health.TakeDamage(damage);
	}
}
