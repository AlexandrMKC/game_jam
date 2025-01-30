class_name HealthComponent
extends Resource

@export
var TOTAL_HEALTH : float = 0

signal health_depleted

var _health : float

func _init():
	# грязный хак
	call_deferred("Ready")
	
func Ready():
	_health = TOTAL_HEALTH
	if is_zero_approx(_health):
		push_error("Object ", resource_scene_unique_id, " have their health set to 0, most likely this is a mistake!")

func TakeDamage(damage: float):
	# debug
	if damage < 0:
		push_warning("Damage is not positive, something is wrong")
		
	_health -= damage
	if _health <= 0.0 || is_zero_approx(_health):
		health_depleted.emit()

func Heal(value: float):
	# debug
	if value < 0:
		push_warning("Heal value is not positive, something is wrong")
		
	_health = clamp(_health + value, 0, TOTAL_HEALTH)
