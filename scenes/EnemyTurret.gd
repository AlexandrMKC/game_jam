class_name EnemyTurret
extends Node3D

@onready 
var PLAYER : Player = get_node("/root/Game/World/Player")
@onready
var WEAPON : Turret = $Weapon
@onready
var COOLDOWN_TIMER : Timer = $CooldownTimer

@export
var HEALTH_COMPONENT : HealthComponent

var _can_shoot : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !PLAYER:
		push_error("Enemy turret is missing player reference!")
	if !WEAPON:
		push_error("Enemy turret is missing weapon reference!")
	if !HEALTH_COMPONENT:
		push_error("Enemy turret is missing Health component reference!")
		return 
	if !COOLDOWN_TIMER:
		push_error("Enemy turret is missing coldownt timer reference!")
		return
	
	HEALTH_COMPONENT.health_depleted.connect(_on_health_component_health_depleted)
	COOLDOWN_TIMER.timeout.connect(WEAPON._Shoot)
	
	_can_shoot = false
	
func _on_health_component_health_depleted():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var direction_to_player := WEAPON.global_position - PLAYER.global_position
	if WEAPON.TURRET_BASE.transform.basis.z.dot(direction_to_player) > 0:
		WEAPON._RotateTo(delta, PLAYER.global_position)
		_can_shoot = true
	else: 
		_can_shoot = false
		COOLDOWN_TIMER.stop()
		
	if _can_shoot and COOLDOWN_TIMER.is_stopped():
		COOLDOWN_TIMER.start()
