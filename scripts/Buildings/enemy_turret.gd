class_name EnemyTurret
extends Node3D

@onready
var weapon : Turret = $Weapon
@onready
var hit_scanner : HitScanner = $HitScanner
@onready
var fire_rate_timer : FireRateTimer = $FireRateTimer
@onready
var detection_area : Area3D = $DetectionArea
@onready
var detection_area_shape : SphereShape3D = $DetectionArea/DetectionAreaShape.shape
@export
var DETECTION_RANGE : float = 20
@export
var HEALTH_COMPONENT : HealthComponent
@export_category("Objects Raycast")
@export_flags_3d_physics
var RAYCAST_COLLISION_MASK : int = 2

var _target : Node3D = null

var _can_shoot : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !weapon:
		push_error("Missing weapon reference! ", name)
	if !HEALTH_COMPONENT:
		push_error("Missing Health component reference! ", name)
		return 
	if !hit_scanner:
		push_error("Missing hit scanner reference! ", name)
		return
	if !fire_rate_timer:
		push_error("Missing fire rate timer node! ", name)
	if !detection_area:
		push_error("Missing detection area node! ", name)
	if !detection_area_shape:
		push_error("Missing detection area shape node! ", name)
	HEALTH_COMPONENT.health_depleted.connect(_on_health_component_health_depleted)
	fire_rate_timer.fire.connect(weapon._Shoot)
	
	hit_scanner.projectile_hit.connect(_on_hit_scanner_projectile_hit)
	
	detection_area.body_entered.connect(_on_detection_area_body_entered)
	detection_area.body_exited.connect(_on_detection_area_body_exited)
	
	detection_area_shape.radius = DETECTION_RANGE
	
	_can_shoot = false
	
func _on_health_component_health_depleted():
	queue_free()
	
func _on_hit_scanner_projectile_hit(damage: float) -> void:
	HEALTH_COMPONENT.TakeDamage(damage)
	print(HEALTH_COMPONENT._health, " remaining health ", name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if _target == null:
		_can_shoot = false
		fire_rate_timer.Deactivate()
		return
	weapon._RotateTo(delta, _target.global_position)
	if !__Blocked():
		_can_shoot = true
	else:
		_can_shoot = false
		fire_rate_timer.Deactivate()
		
	if _can_shoot:
		fire_rate_timer.Activate()

func __Blocked() -> bool:
	var space := get_world_3d().direct_space_state
	var from := weapon.global_position
	var to := _target.global_position
	var query := PhysicsRayQueryParameters3D.create(from, to, RAYCAST_COLLISION_MASK)
	var collision := space.intersect_ray(query)
	if collision:
		if collision["collider"] is not Player:
			return true
	return false
	
func _on_detection_area_body_entered(body: Node3D):
	_target = body
	
func _on_detection_area_body_exited(_body: Node3D):
	_target = null
