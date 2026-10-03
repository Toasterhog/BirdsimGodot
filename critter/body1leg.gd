extends Node3D

@onready var body = $"."
@export var legs: Array[Leg] 
var leg_timing_offsets = [0.3, 0.8, 1.0, 0.5]
var leg_not_notified = [true, true, true, true]
var time : float = 2.0
var numLegs := 0

func _ready() -> void:
	numLegs = legs.size()
	leg_timing_offsets.resize(numLegs)
	leg_not_notified.resize(numLegs)
	for l in legs:
		l.disable_find_target = true;

func _process(delta: float) -> void:
	time += delta * 0.5
	for i in numLegs:
		if leg_not_notified[i] and time >= leg_timing_offsets[i]:
			legs[i].set_new_target(legs[i].find_new_target())
			leg_not_notified[i] = false
	if time > 1.0:
		time = 0
		for lnn in leg_not_notified:
			lnn = true
	
