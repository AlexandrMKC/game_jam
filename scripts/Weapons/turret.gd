class_name Turret
extends Weapon

@export
var SHELL_DAMAGE_OVERRIDE : float = 0

@export
var ROTATION_SPEED : float = 5

@export
var SHELL_CLASS: PackedScene

@export_group("Horizontal Limits", "HORIZONTAL_")
@export_range(-180, 180, 0.001, "degrees")
var HORIZONTAL_LEFT_ROTATION_LIMIT: float = -180:
	get:
		return deg_to_rad(HORIZONTAL_LEFT_ROTATION_LIMIT)
	set(value):
		HORIZONTAL_LEFT_ROTATION_LIMIT = value
@export_range(-180, 180, 0.001, "degrees")
var HORIZONTAL_RIGHT_ROTATION_LIMIT: float = 180:
	get:
		return deg_to_rad(HORIZONTAL_RIGHT_ROTATION_LIMIT)
	set(value):
		HORIZONTAL_RIGHT_ROTATION_LIMIT = value

@export_group("Vertical Limits", "VERTICAL_")
@export_range(-180, 180, 0.001, "degrees")
var VERTICAL_LOWER_ROTATION_LIMIT: float = -180:
	get:
		return deg_to_rad(VERTICAL_LOWER_ROTATION_LIMIT)
	set(value):
		VERTICAL_LOWER_ROTATION_LIMIT = value
@export_range(-180, 180, 0.001, "degrees")
var VERTICAL_UPPER_ROTATION_LIMIT: float = 180:
	get:
		return deg_to_rad(VERTICAL_UPPER_ROTATION_LIMIT)
	set(value):
		VERTICAL_UPPER_ROTATION_LIMIT = value

@onready
var turret_base: MeshInstance3D = $Base
@onready
var pitch_node: Node3D = $Base/Node3D
@onready
var cannon: MeshInstance3D = $Base/Node3D/Cannon
@onready
var spawnpoint: Node3D = $Base/Node3D/Cannon/SpawnPoint

var _horizonal_rotation: float = 0
var _cannon_vertical_rotation: float = 0

var _rotation_requested : bool = false

var _shell_instance: Shell

signal rotation_complete

func _ready() -> void:
	if !turret_base:
		push_error("Missing Turret base! ", name)
	if !cannon:
		push_error("Missing Turret cannon! ", name)
	if !pitch_node:
		push_error("Missing Turret pitch node! ", name)
	if !spawnpoint:
		push_error("Missing Turret spawnpoint node! ", name)
	if !SHELL_CLASS:
		push_error("Missing shell class script! ", name)

func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	if !_rotation_requested:
		return
	global_rotation.y = rotate_toward(global_rotation.y, _horizonal_rotation, delta)
	pitch_node.rotation.x = rotate_toward(pitch_node.rotation.x, _cannon_vertical_rotation, delta)
	
	if is_equal_approx(global_rotation.y, _horizonal_rotation) and is_equal_approx(cannon.rotation.x, _cannon_vertical_rotation):
		_rotation_requested = false

func _RotateTo(delta: float, target_position: Vector3):
	var horizontal_target := target_position
	horizontal_target.y = spawnpoint.global_position.y
	
	var direction := spawnpoint.global_position.direction_to(horizontal_target)
	_horizonal_rotation = direction.signed_angle_to(Vector3.FORWARD, Vector3.DOWN)

	direction = -(pitch_node.global_position - target_position).normalized()
	_cannon_vertical_rotation = atan2(direction.y, sqrt(direction.z * direction.z + direction.x * direction.x))
	
	_rotation_requested = true

func _Shoot() -> void:
	_shell_instance = SHELL_CLASS.instantiate()
	if !is_zero_approx(SHELL_DAMAGE_OVERRIDE):
		_shell_instance.SHELL_DAMAGE = SHELL_DAMAGE_OVERRIDE
	_shell_instance.position = spawnpoint.global_position
	_shell_instance.transform.basis = spawnpoint.global_transform.basis
	get_tree().root.add_child(_shell_instance)
	#TODO - add effects, sound
	
func GetForwardDirection() -> Vector3:
	return -cannon.transform.basis.z
