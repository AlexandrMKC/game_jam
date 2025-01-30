class_name Building
extends Node

@export
var HEALTH_COMPONENT : HealthComponent
@export
var SHIELD_COMPONENT : ShieldComponent

@export
var SHIELD_MATERIAL : Material = preload("res://materials/shield_material.tres")

@onready
var mesh : MeshInstance3D = $MeshInstance3D
@onready
var hit_scanner : HitScanner = $HitScanner

var _shield_active = false

func _ready():
	if !HEALTH_COMPONENT:
		push_error("Missing Health component! ", name)
		return
	if !SHIELD_COMPONENT:
		push_error("Missing Shield component! ", name)
		return
	if !mesh:
		push_error("Missing mesh reference! ", name)
		return
	if !hit_scanner:
		push_error("Missing hit scanner reference! ", name)
		return
		
	HEALTH_COMPONENT.health_depleted.connect(_on_health_component_health_depleted)
	SHIELD_COMPONENT.shield_activated.connect(_on_shield_component_shield_activated)
	SHIELD_COMPONENT.shield_deactivated.connect(_on_shield_component_shield_deactivated)
	
	hit_scanner.projectile_hit.connect(_on_hit_scanner_projectile_hit)
	
func _on_health_component_health_depleted():
	queue_free()

func _on_shield_component_shield_activated():
	mesh.material_overlay = SHIELD_MATERIAL
	_shield_active = true
	
func _on_shield_component_shield_deactivated():
	mesh.material_overlay = null
	_shield_active = false

func IsShieldActive() -> bool:
	return _shield_active

func _on_hit_scanner_projectile_hit(damage: float) -> void:
	if IsShieldActive():
		SHIELD_COMPONENT.TakeDamage(damage)
		print(SHIELD_COMPONENT._shield, " remaining shield ", name)
	else:
		HEALTH_COMPONENT.TakeDamage(damage)
		print(HEALTH_COMPONENT._health, " remaining health ", name)
