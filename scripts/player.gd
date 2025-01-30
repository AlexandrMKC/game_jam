class_name Player extends CharacterBody3D

@onready
var player_mesh : Node3D = $PlayerMesh
@onready
var camera_controller : Node3D = $CameraController
@onready
var pitch_node : Node3D = $CameraController/Pitch
@onready
var camera : Camera3D = $CameraController/Pitch/Camera3D
@onready
var camera_initial_pitch : float = camera.rotation.x
@onready
var fire_rate_timer : FireRateTimer = $FireRateTimer

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

@export_group("Zoom")
@export
var MAX_ZOOM : float = 3
@export
var MIN_ZOOM : float = 0.5
@export
var ZOOM_SPEED : float = 0.1

@export_group("Input")
@export
var YAW_SENSITIVITY : float = 0.3
@export
var PITCH_SENSITIVITY : float = 0.3

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
var ACCELERATED_MUTLIPLIER : float = 1.5
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

var _main_movement : Vector3 = Vector3.ZERO
var _vertical_movement : float = 0.0

var _rotation_input : Vector2 = Vector2.ZERO
var _player_rotation : Vector3 = Vector3.ZERO
var _camera_rotation : Vector3 = Vector3.ZERO:
	get:
		return _camera_rotation
	set(value):
		_camera_rotation = value
		_camera_rotation.x = clamp(_camera_rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)

var _current_speed_multiplier : float = 1
var current_speed : float:
	get:
		return BASE_SPEED * _current_speed_multiplier
var _zoom : float = 1

signal projectile_hit(damage: float)
		
func _ready():
	if !HEALTH_COMPONENT:
		push_error("Missing Health component! ", name)
		return
		
	if !WEAPONRY:
		push_error("Missing Weaponry! ", name)
		
	if !player_mesh:
		push_error("Missing Player mesh! ", name)

	if !camera:
		push_error("Missing Camera! ", name)
		
	if !camera_controller:
		push_error("Missing Camera controller! ", name)
		
	if !pitch_node:
		push_error("Missing pitch node! ", name)
		
	if !fire_rate_timer:
		push_error("Missing fire rate timer node! ", name)
		
	HEALTH_COMPONENT.health_depleted.connect(_on_health_component_health_depleted)
	
	fire_rate_timer.fire.connect(WEAPONRY._Shoot)
	
	
func _physics_process(delta: float) -> void:
	__UpdateCamera(delta)
	
	WEAPONRY._RotateTo(delta, __RaycastFromMouse())
		
	__HorizontalMove(delta)
	
	__VerticalMove(delta)

	velocity = _main_movement + Vector3(0, _vertical_movement, 0)
	move_and_slide()
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_rotation_input.x = -event.relative.x * YAW_SENSITIVITY
		_rotation_input.y = -event.relative.y * PITCH_SENSITIVITY
	
	__Shoot(event)
	
	__Accelerate(event)
	
	__Zoom(event)
		
func _on_health_component_health_depleted() -> void:
	print("You died!")
	#TODO - change to actual stuff
	
func __Shoot(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		fire_rate_timer.Activate()
		
	if event.is_action_released("shoot"):
		fire_rate_timer.Deactivate()
		
func __Accelerate(event: InputEvent) -> void:
	if event.is_action_pressed("accelerate"):
		_current_speed_multiplier = ACCELERATED_MUTLIPLIER

	if event.is_action_released("accelerate"):
		_current_speed_multiplier = 1

func __Zoom(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_in"):
		_zoom -= ZOOM_SPEED

	if event.is_action_pressed("zoom_out"):
		_zoom += ZOOM_SPEED

	_zoom = clamp(_zoom, MIN_ZOOM, MAX_ZOOM)

func __HorizontalMove(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		_main_movement = _main_movement.lerp(direction * current_speed, ACCELERATION * delta);
	else:
		_main_movement = _main_movement.lerp(Vector3.ZERO, DECELERATION * delta)


func __VerticalMove(delta: float) -> void:
	var vertical_direction := Input.get_axis("move_down", "move_up")
	if vertical_direction:
		_vertical_movement = lerp(_vertical_movement, vertical_direction * VERTICAL_SPEED, VERTICAL_ACCELERATION * delta)
	else:
		_vertical_movement = lerp(_vertical_movement, 0.0, VERTICAL_DECELERATION * delta)

	position.y = clamp(position.y, MINIMUM_HEIGHT, MAXIMUM_HEIGHT)


func __UpdateCamera(delta: float) -> void:

	_player_rotation.y += _rotation_input.x * delta
	_camera_rotation.x += _rotation_input.y * delta

	rotate_object_local(Vector3.UP, _rotation_input.x * delta)
	pitch_node.rotate_object_local(Vector3.RIGHT, _rotation_input.y * delta)
	pitch_node.scale = pitch_node.scale.lerp(Vector3.ONE * _zoom, ZOOM_SPEED)
	#global_transform.basis = Basis.from_euler(_player_rotation)
	#pitch_node.transform.basis = Basis.from_euler(_camera_rotation)

	_rotation_input = Vector2.ZERO

	
func __RaycastFromMouse() -> Vector3:
	var space := get_world_3d().direct_space_state
	var mouse_position := get_viewport().get_mouse_position()
	var from := camera.project_ray_origin(mouse_position)
	var to := from + camera.project_ray_normal(mouse_position) * RAYCAST_RANGE
	var query := PhysicsRayQueryParameters3D.create(from, to, RAYCAST_COLLISION_MASK)
	var collision := space.intersect_ray(query)
	if collision:
		return collision["position"]
	return to
