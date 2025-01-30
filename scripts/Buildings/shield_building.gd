class_name ShieldBuilding
extends Node

@onready
var hit_scanner : HitScanner = $HitScanner

@export
var HEALTH_COMPONENT : HealthComponent

@export
var TARGET : Building

@export
var INVINCIBLE_SHIELD : bool

func _ready():
	if !hit_scanner:
		push_error("Missing hit scanner reference! ", name)
		return
	if !HEALTH_COMPONENT:
		push_error("Missing Health component! ", name)
		return
	if !TARGET:
		push_error("Missing Target for shielding! ", name)
		return
	HEALTH_COMPONENT.health_depleted.connect(_on_health_component_health_depleted)
	
	TARGET.SHIELD_COMPONENT.Activate(INVINCIBLE_SHIELD)
	
	hit_scanner.projectile_hit.connect(_on_hit_scanner_projectile_hit)
	
func _on_health_component_health_depleted():
	if TARGET != null:
		TARGET.SHIELD_COMPONENT.Deactivate()
	queue_free()

func _on_hit_scanner_projectile_hit(damage: float) -> void:
	HEALTH_COMPONENT.TakeDamage(damage)
	print(HEALTH_COMPONENT._health, " remaining health ", name)
