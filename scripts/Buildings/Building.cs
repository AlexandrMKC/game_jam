using Godot;
using System;

[GlobalClass]
public partial class Building : Node3D
{
	[Export]
	private HealthComponent Health;
	[Export]
	public ShieldComponent Shield;
	[Export]
	private Material ShieldMaterial;

	// @onready
	private MeshInstance3D Mesh;
	private HitScanner HitScanner;

	private bool _shieldActive = false;

	public override void _Ready()
	{
		if (Health == null)
		{
			GD.PushError("Missing health component! ", Name);
		}
		if (Shield == null)
		{
			GD.PushError("Missing shield component! ", Name);
		}
		if (ShieldMaterial == null)
		{
			GD.PushError("Missing shield material! ", Name);
		}
		Mesh = GetNode<MeshInstance3D>("Mesh");
		if (Mesh == null)
		{
			GD.PushError("Missing mesh node! ", Name);
		}
		HitScanner = GetNode<HitScanner>("HitScanner");
		if (HitScanner == null)
		{
			GD.PushError("Missing hit scanner node! ", Name);
		}

		Health.HealthDepleted += OnHealthDepleted;
		Shield.ShieldActivated += OnShieldActivated;
		Shield.ShieldDeactivated += OnShieldDeactivated;

		HitScanner.Hit += OnProjectileHit;
	}

	public bool IsShieldActive()
	{
		return _shieldActive;
	}

	private void OnHealthDepleted()
	{
		QueueFree();
	}

	private void OnShieldActivated()
	{
		Mesh.MaterialOverlay = ShieldMaterial;
		_shieldActive = true;
	}

	private void OnShieldDeactivated()
	{
		Mesh.MaterialOverlay = null;
		_shieldActive = false;
	}

	private void OnProjectileHit(float damage)
	{
		if (IsShieldActive())
		{
			Shield.TakeDamage(damage);
			return;
		}
		Health.TakeDamage(damage);
	}
}
