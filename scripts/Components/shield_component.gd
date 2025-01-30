class_name ShieldComponent
extends Resource

@export
var TOTAL_SHIELD : float = 0
@export
var INVINCIBLE : bool = false

signal shield_deactivated
signal shield_activated

var _shield : float
var _invincible : bool

func _init():
	# грязный хак
	call_deferred("Ready")
	
func Ready():
	_shield = TOTAL_SHIELD
	_invincible = INVINCIBLE
	if is_zero_approx(_shield):
		push_error("Object ", resource_scene_unique_id, " have their shield set to 0, most likely this is a mistake!")
		
func Activate(invincible: bool):
	_shield = TOTAL_SHIELD
	_invincible = invincible
	shield_activated.emit()
	
func TakeDamage(damage: float):
	# debug
	if _invincible:
		return
		
	if damage < 0:
		push_warning("Damage is not positive, something is wrong")
		
	_shield -= damage
	if _shield <= 0.0 || is_zero_approx(_shield):
		shield_deactivated.emit()

func Deactivate():
	shield_deactivated.emit()
