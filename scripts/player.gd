extends CharacterBody3D

@export
var MOUSE_SENSITIVITY = 0.3

@export 
var BASE_SPEED = 5.0
@export 
var ACCELERATION = 5.0
@export 
var DECELERATION = 5.0

var _mainMovement : Vector3 = Vector3.ZERO
var _rotationInput : Vector2 = Vector2.ZERO
var _playerRotation : Vector3 = Vector3.ZERO

func _physics_process(delta: float) -> void:
	update_camera(delta)
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		_mainMovement = _mainMovement.lerp(direction * BASE_SPEED, ACCELERATION * delta);
	else:
		_mainMovement = _mainMovement.lerp(Vector3.ZERO, DECELERATION * delta)


	velocity = _mainMovement
	move_and_slide()


func update_camera(delta: float) -> void:
	_playerRotation.y += _rotationInput.x * delta
	
	global_transform.basis = Basis.from_euler(_playerRotation)
	
	_rotationInput = Vector2.ZERO
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_rotationInput = -event.relative * MOUSE_SENSITIVITY
