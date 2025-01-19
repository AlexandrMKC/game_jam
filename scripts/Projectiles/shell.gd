class_name Shell
extends Node3D

@export
var SPEED: float = 40

@onready
var MESH = $MeshInstance3D

@onready
var RAYCAST = $RayCast3D

@onready
var DESTRUCT_TIMER = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.basis * Vector3.FORWARD * SPEED * delta
	if RAYCAST.is_colliding():
		MESH.visible = false
		queue_free()

func _on_timer_timeout() -> void:
	queue_free()
