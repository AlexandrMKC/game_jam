class_name Shell
extends Node3D

@export
var SPEED: float = 40

@export
var RAYCAST_DISTANCE: float = -0.7 # forward

@onready
var MESH = $MeshInstance3D
@onready
var RAYCAST = $RayCast3D
@onready
var DESTRUCT_TIMER = $DestructTimer

var _base_speed : float = 40

var shell_damage : float = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !MESH:
		push_error("Missing shell mesh!")
	if !RAYCAST:
		push_error("Missing shell Raycast!")
	if !DESTRUCT_TIMER:
		push_error("Missing shell Destruct timer!")
		
	if !shell_damage:
		push_warning("Shell damage is zero, possibly was not set in weapon!")
	scale = Vector3(1, 1, 1)
	
	RAYCAST.target_position.z = RAYCAST_DISTANCE * SPEED / _base_speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += transform.basis * Vector3.FORWARD * SPEED * delta
	if RAYCAST.is_colliding():
		MESH.visible = false
		# maybe bad
		var collider = RAYCAST.get_collider().get_parent() as Building
		if collider:
			collider.HEALTH_COMPONENT.TakeDamage(shell_damage)
		#TODO - add effects, sound
		print("hit")
		queue_free()

func _on_timer_timeout() -> void:
	#TODO - maybe add something (should be an error scenario)
	queue_free()
