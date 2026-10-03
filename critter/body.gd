extends Node3D

@onready var body = $"."
@onready var legs: Array[Leg] = [body.get_node("leg_fl"), body.get_node("leg_fr"), body.get_node("leg_bl"), body.get_node("leg_br")]
var leg_timing_offsets = [0.3, 0.8, 1.0, 0.5]
var leg_not_notified = [true, true, true, true]
var time : float = 2.0


func _ready() -> void:
	for l in legs:
		l.disable_find_target = true;

func _process(delta: float) -> void:
	time += delta * 0.5
	for i in 4:
		if leg_not_notified[i] and time >= leg_timing_offsets[i]:
			legs[i].set_new_target(legs[i].find_new_target())
			leg_not_notified[i] = false
	if time > 1.0:
		time = 0
		leg_not_notified = [true, true, true, true]
	
