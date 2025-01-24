class_name Shell
extends Node3D

@export
var SPEED : float = 40
@export
var SHELL_DAMAGE : float = 20

@export
var RAYCAST_DISTANCE: float = -0.7 # forward

@onready
var MESH = $MeshInstance3D
@onready
var RAYCAST = $RayCast3D
@onready
var DESTRUCT_TIMER = $DestructTimer

var _base_speed : float = 40


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !MESH:
		push_error("Missing shell mesh!")
	if !RAYCAST:
		push_error("Missing shell Raycast!")
	if !DESTRUCT_TIMER:
		push_error("Missing shell Destruct timer!")

	scale = Vector3(1, 1, 1)
	
	RAYCAST.target_position.z = RAYCAST_DISTANCE * SPEED / _base_speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += transform.basis * Vector3.FORWARD * SPEED * delta
	if RAYCAST.is_colliding():
		MESH.visible = false
		# maybe bad
		var collider = RAYCAST.get_collider()
		if !"HEALTH_COMPONENT" in collider:
			collider = collider.get_parent()
		elif "HEALTH_COMPONENT" in collider:
			collider.HEALTH_COMPONENT.TakeDamage(SHELL_DAMAGE)
		#TODO - add effects, sound
		queue_free()

func _on_timer_timeout() -> void:
	#TODO - maybe add something (should be an error scenario)
	queue_free()
