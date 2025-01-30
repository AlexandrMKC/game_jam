class_name Shell
extends Node3D

@export
var SPEED : float = 40
@export
var SHELL_DAMAGE : float = 20

@export
var RAYCAST_DISTANCE: float = -0.8 # forward

@onready
var mesh = $MeshInstance3D
@onready
var raycast = $RayCast3D
@onready
var destruct_timer = $DestructTimer

var _base_speed : float = 40

func _ready() -> void:
	if !mesh:
		push_error("Missing shell mesh!")
	if !raycast:
		push_error("Missing shell Raycast!")
	if !destruct_timer:
		push_error("Missing shell Destruct timer!")

	scale = Vector3(1, 1, 1)
	
	raycast.target_position.z = RAYCAST_DISTANCE * SPEED / _base_speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += transform.basis * Vector3.FORWARD * SPEED * delta
	if raycast.is_colliding():
		mesh.visible = false
		var collider = raycast.get_collider()
		if "projectile_hit" in collider:
			collider.projectile_hit.emit(SHELL_DAMAGE)
		#TODO - add effects, sound
		queue_free()

func _on_timer_timeout() -> void:
	#TODO - maybe add something (should be an error scenario)
	queue_free()
