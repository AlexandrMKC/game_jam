class_name Turret
extends Weapon

@export
var SHELL_DAMAGE_OVERRIDE : float = 0

@export
var ROTATION_SPEED: float = 5

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
var TURRET_BASE: MeshInstance3D = $Base
@onready
var BARREL: MeshInstance3D = $Base/GunBarrel
@onready
var SPAWNPOINT: Node3D = $Base/GunBarrel/SpawnPoint
#var _horizonal_rotation: float = 0
#var _vertical_rotation: float = 0
var _last_position: Vector3

@export
var shell_class: PackedScene
var shell_instance: Shell

func _ready() -> void:
	if !TURRET_BASE:
		push_error("Missing Turret base!")
	if !BARREL:
		push_error("Missing Turret barrel!")
	if !shell_class:
		push_error("Missing shell class script!")

func _process(delta: float) -> void:
	pass

func _RotateTo(delta: float, target_position: Vector3 = _last_position):
	#var direction = (global_position - position).normalized()
	#_horizonal_rotation = clamp(atan2(direction.x, direction.z), HORIZONTAL_LEFT_ROTATION_LIMIT, HORIZONTAL_RIGHT_ROTATION_LIMIT) * delta
	#_vertical_rotation = clamp(atan2(direction.y, direction.z * direction.z + direction.x * direction.x), VERTICAL_LOWER_ROTATION_LIMIT, VERTICAL_UPPER_ROTATION_LIMIT) * delta
	#TURRET_BASE.transform.basis = Basis.from_euler(Vector3(0, _horizonal_rotation, 0))
	#BARREL.transform.basis = Basis.from_euler(Vector3(_vertical_rotation, 0, 0))
	var new_transform = TURRET_BASE.global_transform.looking_at(target_position)
	TURRET_BASE.global_transform = TURRET_BASE.global_transform.interpolate_with(new_transform, ROTATION_SPEED * delta)
	TURRET_BASE.scale = Vector3(1, 1, 1)
	_last_position = target_position

func _Shoot() -> void:
	shell_instance = shell_class.instantiate()
	if !is_zero_approx(SHELL_DAMAGE_OVERRIDE):
		shell_instance.SHELL_DAMAGE = SHELL_DAMAGE_OVERRIDE
	shell_instance.position = SPAWNPOINT.global_position
	shell_instance.transform.basis = SPAWNPOINT.global_transform.basis
	get_tree().root.add_child(shell_instance)
	#TODO - add effects, sound
