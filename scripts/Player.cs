using Godot;
using System;

[GlobalClass]
public partial class Player : CharacterBody3D, IHittable
{
	// @onready
	private Node3D PlayerMesh;
	private Node3D CameraController;
	private Node3D PitchNode;
	private Camera3D Camera;
	private FireRateTimer FireRate;
	private float _cameraInitialPitch;

	[Export]
	private Turret Weaponry;
	[Export]
	private HealthComponent Health;

	[ExportCategory("Mouse Raycast")]
	[Export(PropertyHint.Layers3DPhysics)]
	private uint RaycastCollisionMask = 1;
	[Export]
	private float RaycastRange = 512;

	[ExportGroup("Zoom")]
	[Export]
	private float MaximumZoom = 3;
	[Export]
	private float MinimumZoom = 0.5f;
	[Export]
	private float ZoomSpeed = 0.1f;

	[ExportGroup("Tilt Parameters", "Tilt")]
	[Export(PropertyHint.Range, "-90,90,0.001,degrees")]
	private float TiltUpperLimit = 90;
	[ExportGroup("Tilt Parameters", "Tilt")]
	[Export(PropertyHint.Range, "-90,90,0.001,degrees")]
	private float TiltLowerLimit = -90;

	// Maybe precompute later
	private float _upperLimit;
	private float _lowerLimit;

	[ExportGroup("Input")]
	[Export]
	private float YawSensitivity = 0.7f;
	[Export]
	private float PitchSensitivity = 0.7f;

	[ExportGroup("Movement")]
	[Export]
	private float BaseSpeed = 30.0f;
	[Export]
	private float AcceleratedMultiplier = 1.5f;
	[Export]
	private float Acceleration = 8.0f;
	[Export]
	private float Deceleration = 8.0f;
	[Export]
	private float VerticalSpeed = 10.0f;
	[Export]
	private float VerticalAcceleration = 5.0f;
	[Export]
	private float VerticalDeceleration = 5.0f;
	[Export]
	private float MinimumHeight = 10.0f;
	[Export]
	private float MaximumHeight = 50.0f;

	private float _realYawSensitivity;
	private float _realPitchSensitivity;

	private Vector3 _mainMovement = Vector3.Zero;
	private float _verticalMovement = 0.0f;

	private Vector2 _rotationInput = Vector2.Zero;

	private float _currentSpeedMultiplier = 1;
	private float CurrentSpeed => BaseSpeed * _currentSpeedMultiplier;

	private float _zoom = 1.0f;

	public override void _Ready()
	{
		PlayerMesh = GetNode<Node3D>("PlayerMesh");
		if (PlayerMesh == null)
		{
			GD.PushError("Missing player mesh! ", Name);
		}
		CameraController = GetNode<Node3D>("CameraController");
		if (CameraController == null)
		{
			GD.PushError("Missing camera controller! ", Name);
		}
		PitchNode = GetNode<Node3D>("CameraController/PitchNode");
		if (PitchNode == null)
		{
			GD.PushError("Missing pitch node! ", Name);
		}
		Camera = GetNode<Camera3D>("CameraController/PitchNode/Camera3D");
		if (Camera == null)
		{
			GD.PushError("Missing camera! ", Name);
		}
		FireRate = GetNode<FireRateTimer>("PlayerMesh/FireRateTimer");
		if (FireRate == null)
		{
			GD.PushError("Missing fire rate timer! ", Name);
		}

		if (Weaponry == null)
		{
			GD.PushError("Missing weapons! ", Name);
		}
		if (Health == null)
		{
			GD.PushError("Missing Health! ", Name);
		}

		_cameraInitialPitch = Camera.RotationDegrees.X;

		_realYawSensitivity = YawSensitivity / 1000f;
		_realPitchSensitivity = PitchSensitivity / 1000f;

		_upperLimit = Mathf.DegToRad(TiltUpperLimit - _cameraInitialPitch);
		_lowerLimit = Mathf.DegToRad(TiltLowerLimit - _cameraInitialPitch);

		Health.HealthDepleted += OnHealthDepleted;
		FireRate.Fire += Weaponry.Shoot;
	}

	public override void _Process(double delta)
	{
		UpdateCamera();
	}

	public override void _PhysicsProcess(double delta)
	{
		if (Weaponry is Turret turret)
		{
			turret.RotateTo(RaycastFromMouse());
		}

		HorizontalMove((float)delta);
		VerticalMove((float)delta);

		Velocity = _mainMovement + new Vector3(0, _verticalMovement, 0);
		MoveAndSlide();
	}

	public override void _UnhandledInput(InputEvent @event)
	{
		if (@event is InputEventMouseMotion mouseMotion)
		{
			_rotationInput = -mouseMotion.Relative;
			_rotationInput.X *= _realYawSensitivity;
			_rotationInput.Y *= _realPitchSensitivity;
		}

		Shoot(@event);
		Accelerate(@event);
		Zoom(@event);
	}

	private void OnHealthDepleted()
	{
		// add actual stuff
		GD.Print("You died");
	}

	private void Shoot(InputEvent @event)
	{
		if (@event.IsActionPressed("shoot"))
		{
			FireRate.Activate();
		}
		if (@event.IsActionReleased("shoot"))
		{
			FireRate.Deactivate();
		}
	}

	private void Accelerate(InputEvent @event)
	{
		if (@event.IsActionPressed("accelerate"))
		{
			_currentSpeedMultiplier = AcceleratedMultiplier;
		}
		if (@event.IsActionReleased("accelerate"))
		{
			_currentSpeedMultiplier = 1;
		}
	}

	private void Zoom(InputEvent @event)
	{
		if (@event.IsActionPressed("zoom_in"))
		{
			_zoom -= ZoomSpeed;
		}
		if (@event.IsActionReleased("zoom_out"))
		{
			_zoom += ZoomSpeed;
		}
		_zoom = Mathf.Clamp(_zoom, MinimumZoom, MaximumZoom);
	}

	private void HorizontalMove(float delta)
	{
		var inputDirection = Input.GetVector("move_left", "move_right", "move_forward", "move_backward");
		var direction = (Transform.Basis * new Vector3(inputDirection.X, 0, inputDirection.Y)).Normalized();

		if (!Mathf.IsZeroApprox(direction.Length()))
		{
			_mainMovement = _mainMovement.Lerp(direction * CurrentSpeed, Acceleration * delta);
		}
		else
		{
			_mainMovement = _mainMovement.Lerp(Vector3.Zero, Deceleration * delta);
		}
	}

	private void VerticalMove(float delta)
	{
		var verticalDirection = Input.GetAxis("move_down", "move_up");
		if (!Mathf.IsZeroApprox(verticalDirection))
		{
			_verticalMovement = Mathf.Lerp(_verticalMovement, verticalDirection * VerticalSpeed, VerticalAcceleration * delta);
		}
		else
		{
			_verticalMovement = Mathf.Lerp(_verticalMovement, 0.0f, VerticalDeceleration * delta);
		}

		Position = Position with { Y = Mathf.Clamp(Position.Y, MinimumHeight, MaximumHeight) };
	}

	private void UpdateCamera()
	{
		RotateObjectLocal(Vector3.Up, _rotationInput.X);
		PitchNode.RotateObjectLocal(Vector3.Right, _rotationInput.Y);

		PitchNode.Rotation = PitchNode.Rotation with { X = Mathf.Clamp(PitchNode.Rotation.X, _lowerLimit, _upperLimit) };

		PitchNode.Scale = PitchNode.Scale.Lerp(Vector3.One * _zoom, ZoomSpeed);

		_rotationInput = Vector2.Zero;
	}

	private Vector3 RaycastFromMouse()
	{
		var space = GetWorld3D().DirectSpaceState;
		var mousePosition = GetViewport().GetMousePosition();
		var from = Camera.ProjectRayOrigin(mousePosition);
		var to = from + Camera.ProjectRayNormal(mousePosition) * RaycastRange;
		var query = PhysicsRayQueryParameters3D.Create(from, to, RaycastCollisionMask);
		var collision = space.IntersectRay(query);
		if (collision.Count == 0)
		{
			return to;
		}
		return (Vector3)collision["position"];
	}

	public void RegisterHit(float damage)
	{
		Health.TakeDamage(damage);
	}
}
