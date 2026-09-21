extends Node3D

@onready var character_body_3d: CharacterBody3D = $CharacterBody3D
@onready var body: Node3D = $CharacterBody3D/body
@onready var head: Node3D = body.get_node("head")
@onready var legs: Array[Node3D] = [body.get_node("leg_fl"), body.get_node("leg_fr"), body.get_node("leg_bl"), body.get_node("leg_br")]
var leg_timing_offsets = [0.3, 0.8, 1.0, 0.5]
var time : float = 2.0
@export var feet_motion : Curve

#func _ready() -> void:
	#var max = leg_timing_offsets.max()
	#for lto in leg_timing_offsets:
		#lto = lto / TAU
		#print(lto)

func _process(delta: float) -> void:
	time += delta
	for i in 4:
		var t = fmod((time  - leg_timing_offsets[i]) , 1.0)
		legs[i].rotation.x = feet_motion.sample_baked(t) * 0.6

func _physics_process(delta: float) -> void:
	var angle = sin(time*0.5)
	character_body_3d.velocity.z = -0.66 * cos(angle)
	character_body_3d.velocity.x = -0.66 * sin(angle)
	character_body_3d.rotation.y = angle
	if not character_body_3d.is_on_floor():
		character_body_3d.velocity += character_body_3d.get_gravity() * delta
	
	character_body_3d.move_and_slide()
