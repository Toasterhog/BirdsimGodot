extends Node3D

@onready var character_body_3d: CharacterBody3D = $CharacterBody3D
@onready var body: Node3D = $CharacterBody3D/body
@onready var head: Node3D = body.get_node("head")
@onready var legs: Array[Node3D] = [body.get_node("leg_fl"), body.get_node("leg_fr"), body.get_node("leg_bl"), body.get_node("leg_br")]
var leg_timing_offsets = [PI*0.5, PI*1.5, TAU, PI]
var time : float = 0.0
@export var feet_motion : Curve

func _ready() -> void:
	var max = leg_timing_offsets.max()
	for lto in leg_timing_offsets:
		lto = lto * TAU / max

func _process(delta: float) -> void:
	time += delta
	for i in 4:
		legs[i].rotation.x = sin(time*2.3 - leg_timing_offsets[i]) * 0.6

func _physics_process(delta: float) -> void:
	character_body_3d.velocity.z = -0.3
	if not character_body_3d.is_on_floor():
		character_body_3d.velocity += character_body_3d.get_gravity() * delta
	
	character_body_3d.move_and_slide()
