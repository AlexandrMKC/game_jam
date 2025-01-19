class_name Player extends CharacterBody3D

@export_group("Input")
@export
var MOUSE_SENSITIVITY : float = 0.3

@export_group("Tilt Parameters", "TILT_")
@export_range(-90, 90, 0.001, "degrees")
var TILT_UPPER_LIMIT : float = 90:
	get:
		return deg_to_rad(TILT_UPPER_LIMIT)
	set(value):
		TILT_UPPER_LIMIT = value
@export_range(-90, 90, 0.001, "degrees")
var TILT_LOWER_LIMIT : float = -90:
	get:
		return deg_to_rad(TILT_LOWER_LIMIT)
	set(value):
		TILT_LOWER_LIMIT = value

@export_group("Speed Parameters")
@export 
var BASE_SPEED : float = 10.0
@export 
var ACCELERATION : float = 5.0
@export 
var DECELERATION : float = 5.0

@export_group("")
@export
var WEAPONRY: Weapon
@onready
var CAMERA_CONTROLLER : Node3D = get_node("CameraController")

#signal rotate_turret_to(position: Vector3)

var _main_movement : Vector3 = Vector3.ZERO

var _rotation_input : Vector2 = Vector2.ZERO
var _player_rotation : Vector3 = Vector3.ZERO
var _camera_rotation : Vector3 = Vector3.ZERO:
	get:
		return _camera_rotation
	set(value):
		_camera_rotation = value
		_camera_rotation.x = clamp(_camera_rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)

func _physics_process(delta: float) -> void:
	UpdateCamera(delta)

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		_main_movement = _main_movement.lerp(direction * BASE_SPEED, ACCELERATION * delta);
	else:
		_main_movement = _main_movement.lerp(Vector3.ZERO, DECELERATION * delta)

	

	velocity = _main_movement
	move_and_slide()


func UpdateCamera(delta: float) -> void:
	_player_rotation.y += _rotation_input.x * delta
	_camera_rotation.x = clamp(_camera_rotation.x + _rotation_input.y * delta, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT) 
	
	global_transform.basis = Basis.from_euler(_player_rotation)
	CAMERA_CONTROLLER.transform.basis = Basis.from_euler(_camera_rotation)
	
	_rotation_input = Vector2.ZERO
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_rotation_input = -event.relative * MOUSE_SENSITIVITY
	
	if event.is_action_pressed("shoot"):
		WEAPONRY._Shoot()
