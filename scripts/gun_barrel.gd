class_name GunBarrel
extends MeshInstance3D

@export
var RANGE: float = 20

@export_flags_3d_physics
var COLLISION_MASK = 1


func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

# Call only from _physics_process!
func Shoot() -> void:
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_position, global_position - global_transform.basis.z * RANGE, COLLISION_MASK, [self])
	var collision = space.intersect_ray(query)
	if collision:
		print("Hit")
	else:
		print("No hit")
