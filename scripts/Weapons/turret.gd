class_name Turret
extends Weapon

@export
var ROTATION_SPEED: float = 0.3

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
var TURRET_BASE: MeshInstance3D = get_node("Base")
@onready
var BARREL: MeshInstance3D = get_node("Base/GunBarrel")

var _rotation_requested: bool = false
var _horizonal_rotation: float
var _vertical_rotation: float

@onready
var shell_class: Resource = load("res://scenes/shell.tscn")
var instance: Shell

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	if !_rotation_requested:
		return
	

func _RotateTo(position: Vector3):
	look_at(position)

func _Shoot() -> void:
	instance = shell_class.instantiate()
	instance.position = BARREL.global_position
	instance.transform.basis = BARREL.global_transform.basis
	get_tree().root.add_child(instance)
