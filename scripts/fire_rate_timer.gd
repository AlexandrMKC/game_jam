class_name FireRateTimer
extends Node

@export_range(0, 10000, 0.01, "or_greater", "suffix:Shots/Min")
var FIRE_RATE : float = 0

signal fire

# shots in minutes
var _total_time_inbetween : float = 0

var _time : float = 0

var _no_fire : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_zero_approx(FIRE_RATE):
		_no_fire = true
		return
	_total_time_inbetween = 60 / FIRE_RATE
	_time = _total_time_inbetween
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_time -= delta
	if _time <= 0:
		_time = 0 if _no_fire else _total_time_inbetween
		if _no_fire:
			return
		fire.emit()

func Activate():
	_no_fire = false
	
func Deactivate():
	_no_fire = true
