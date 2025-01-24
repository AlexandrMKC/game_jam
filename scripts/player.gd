class_name Player extends CharacterBody3D

@export_group("")
@export
var WEAPONRY : Weapon
@export
var HEALTH_COMPONENT : HealthComponent

@export_category("Mouse Raycast")
@export_flags_3d_physics
var RAYCAST_COLLISION_MASK : int = 1
@export
var RAYCAST_RANGE : float = 512

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

@export_group("Movement Parameters")
@export 
var BASE_SPEED : float = 15.0
@export 
var ACCELERATION : float = 8.0
@export 
var DECELERATION : float = 8.0
@export
var VERTICAL_SPEED : float = 10.0
@export 
var VERTICAL_ACCELERATION : float = 5.0
@export 
var VERTICAL_DECELERATION : float = 5.0
@export
var MINIMUM_HEIGHT : float = 10.0
@export
var MAXIMUM_HEIGHT : float = 50.0

@onready
var PlAYER_MESH : Node3D = $Robot
@onready
var CAMERA_CONTROLLER : Node3D = $CameraController
@onready
var CAMERA : Camera3D = $CameraController/Camera3D

var _main_movement : Vector3 = Vector3.ZERO
var _vertical_movement : float = 0

var _rotation_input : Vector2 = Vector2.ZERO
var _player_rotation : Vector3 = Vector3.ZERO
var _camera_rotation : Vector3 = Vector3.ZERO:
	get:
		return _camera_rotation
	set(value):
		_camera_rotation = value
		_camera_rotation.x = clamp(_camera_rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)
		
func _ready():
	if !HEALTH_COMPONENT:
		push_error("Missing Health component!")
		return
		
	if !WEAPONRY:
		push_error("Missing Weaponry!")
		
	if !PlAYER_MESH:
		push_error("Missing Player mesh!")

	if !CAMERA:
		push_error("Missing Camera!")
		
	if !CAMERA_CONTROLLER:
		push_error("Missing Camera controller!")
	HEALTH_COMPONENT.health_depleted.connect(_on_health_component_health_depleted)
	
func _physics_process(delta: float) -> void:
	UpdateCamera(delta)
	
	var player_points_to := RaycastFromMouse()
	if player_points_to != Vector3.ZERO:
		WEAPONRY._RotateTo(delta, player_points_to)
		
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		_main_movement = _main_movement.lerp(direction * BASE_SPEED, ACCELERATION * delta);
	else:
		_main_movement = _main_movement.lerp(Vector3.ZERO, DECELERATION * delta)

	var vertical_direction := Input.get_axis("move_down", "move_up")
	if vertical_direction:
		_vertical_movement = lerp(_vertical_movement, vertical_direction * VERTICAL_SPEED, VERTICAL_ACCELERATION * delta)
	else:
		_vertical_movement = lerp(_vertical_movement, 0.0, VERTICAL_DECELERATION * delta)

	position.y = clamp(position.y, MINIMUM_HEIGHT, MAXIMUM_HEIGHT)

	velocity = _main_movement + Vector3(0, _vertical_movement, 0)
	move_and_slide()
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_rotation_input = -event.relative * MOUSE_SENSITIVITY
	
	if event.is_action_pressed("shoot"):
		WEAPONRY._Shoot()

func _on_health_component_health_depleted() -> void:
	print("You died!")
	#TODO - change to actual stuff

func UpdateCamera(delta: float) -> void:
	_player_rotation.y += _rotation_input.x * delta
	_camera_rotation.x = clamp(_camera_rotation.x + _rotation_input.y * delta, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)
	
	global_transform.basis = Basis.from_euler(_player_rotation)
	CAMERA_CONTROLLER.transform.basis = Basis.from_euler(_camera_rotation)
	
	_rotation_input = Vector2.ZERO
	
func RaycastFromMouse() -> Vector3:
	var space = get_world_3d().direct_space_state
	var mouse_position = get_viewport().get_mouse_position()
	var from = CAMERA.project_ray_origin(mouse_position)
	var to = from + CAMERA.project_ray_normal(mouse_position) * RAYCAST_RANGE
	var query = PhysicsRayQueryParameters3D.create(from, to, RAYCAST_COLLISION_MASK)
	var collision = space.intersect_ray(query)
	if collision:
		return collision["position"]
	return Vector3.ZERO
