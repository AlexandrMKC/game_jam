using Godot;
using System;

[GlobalClass]
public partial class Turret : Weapon
{
	[Signal]
	public delegate void RotationCompleteEventHandler();

	[Export]
	private float ShellDamage = 0;
	[Export]
	public float ShellSpeed { get; private set; } = 0;
	[Export]
	private float HorizontalRotationSpeed = 3;
	[Export]
	private float VerticalRotationSpeed = 3;
	[Export]
	private PackedScene ShellClass;

	[ExportGroup("Horizontal Limits", "Horizontal")]
	[Export(PropertyHint.Range, "-180,180,0.001,degrees")]
	private float HorizontalLeftRotationLimit = -180;
	[Export(PropertyHint.Range, "-180,180,0.001,degrees")]
	private float HorizontalRightRotationLimit = 180;
	[ExportGroup("Vertical Limits", "Vertical")]
	[Export(PropertyHint.Range, "-180,180,0.001,degrees")]
	private float VerticalLowerRotationLimit = -180;
	[Export(PropertyHint.Range, "-180,180,0.001,degrees")]
	private float VerticalUpperRotationLimit = 180;
	// Maybe precompute later
	private float _leftRotationLimit => Mathf.DegToRad(HorizontalLeftRotationLimit);
	private float _rightRotationLimit => Mathf.DegToRad(HorizontalRightRotationLimit);
	private float _lowerRotationLimit => Mathf.DegToRad(VerticalLowerRotationLimit);
	private float _upperRotationLimit => Mathf.DegToRad(VerticalUpperRotationLimit);

	// @onready
	private MeshInstance3D TurretBase;
	private Node3D PitchNode;
	private MeshInstance3D Cannon;
	private Node3D Spawnpoint;

	private float _horizontalRotationSpeed = 0.0f;
	private float _verticalRotationSpeed = 0.0f;

	public float HorizontalRotation { get; private set; } = 0;
	public float CannonVerticalRotation { get; private set; } = 0;

	private bool _rotationRequested = false;
	private Shell _shellInstance;

	public override void _Ready()
	{
		TurretBase = GetNode<MeshInstance3D>("Base");
		if (TurretBase == null)
		{
			GD.PushError("Missing turret base! ", Name);
		}
		PitchNode = GetNode<Node3D>("Base/PitchNode");
		if (PitchNode == null)
		{
			GD.PushError("Missing pitch node! ", Name);
		}
		Cannon = GetNode<MeshInstance3D>("Base/PitchNode/Cannon");
		if (Cannon == null)
		{
			GD.PushError("Missing Cannon! ", Name);
		}
		Spawnpoint = GetNode<Node3D>("Base/PitchNode/Cannon/SpawnPoint");
		if (Spawnpoint == null)
		{
			GD.PushError("Missing spawnpoint node! ", Name);
		}

		_horizontalRotationSpeed = HorizontalRotationSpeed;
		_verticalRotationSpeed = VerticalRotationSpeed;
	}

	public override void _PhysicsProcess(double delta)
	{
		if (!_rotationRequested)
		{
			return;
		}

		GlobalRotation = GlobalRotation with { Y = Mathf.RotateToward(GlobalRotation.Y, HorizontalRotation, _horizontalRotationSpeed * (float)delta) };
		PitchNode.Rotation = PitchNode.Rotation with { X = Mathf.RotateToward(PitchNode.Rotation.X, CannonVerticalRotation, _verticalRotationSpeed * (float)delta) };
		if (Mathf.IsEqualApprox(GlobalRotation.Y, HorizontalRotation) && Mathf.IsEqualApprox(PitchNode.Rotation.X, CannonVerticalRotation))
		{
			_rotationRequested = false;
		}
	}

	public override void Shoot()
	{
		_shellInstance = (Shell)ShellClass.Instantiate();
		if (!Mathf.IsZeroApprox(ShellDamage))
		{
			_shellInstance.OverrideShellDamage(ShellDamage);
		}
		if (!Mathf.IsZeroApprox(ShellSpeed))
		{
			_shellInstance.OverrideShellSpeed(ShellSpeed);
		}
		_shellInstance.Position = Spawnpoint.GlobalPosition;
		_shellInstance.Transform = _shellInstance.Transform with { Basis = Spawnpoint.GlobalTransform.Basis };
		GetTree().Root.AddChild(_shellInstance);
		// TODO - add effects, sound
	}

	public void RotateTo(Vector3 targetPosition)
	{
		var horizontalTarget = targetPosition with { Y = Spawnpoint.GlobalPosition.Y };
		var direction = Spawnpoint.GlobalPosition.DirectionTo(horizontalTarget);
		HorizontalRotation = direction.SignedAngleTo(Vector3.Forward, Vector3.Down);

		direction = -(PitchNode.GlobalPosition - targetPosition).Normalized();
		CannonVerticalRotation = Mathf.Atan2(direction.Y, Mathf.Sqrt(direction.Z * direction.Z + direction.X * direction.X));

		_rotationRequested = true;
	}

	public Vector3 GetForwardDirection()
	{
		return -GlobalBasis.Z with { Y = -PitchNode.Transform.Basis.Z.Y };
	}
}
