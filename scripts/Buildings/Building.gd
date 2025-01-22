class_name Building
extends Node

@export
var HEALTH_COMPONENT : HealthComponent

func _ready():
	if !HEALTH_COMPONENT:
		push_error("Missing Health component!")
		return
	HEALTH_COMPONENT.health_depleted.connect(_on_health_component_health_depleted)
	
func _on_health_component_health_depleted():
	queue_free()
