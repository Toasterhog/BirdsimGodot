extends Node3D

@onready var character_body_3d: CharacterBody3D = $CharacterBody3D
@onready var body: Node3D = $CharacterBody3D/body
@onready var head: Node3D = body.get_node("head")
@onready var legs: Array[Node3D] = [body.get_node("leg_fl"), body.get_node("leg_fr"), body.get_node("leg_bl"), body.get_node("leg_br")]
var leg_timing_offsets = [0.3, 0.8, 1.0, 0.5]
var time : float = 2.0


func _process(delta: float) -> void:
	time += delta

func _physics_process(delta: float) -> void:
	#var angle = sin(time*0.5)
	#character_body_3d.velocity.z = -0.66 * cos(angle)
	#character_body_3d.velocity.x = -0.66 * sin(angle)
	#character_body_3d.rotation.y = angle
	character_body_3d.velocity.z = -1
	if not character_body_3d.is_on_floor():
		character_body_3d.velocity += character_body_3d.get_gravity() * delta
	
	character_body_3d.move_and_slide()












#
#
#
#
#
#
#extends Node3D
#
#@onready var character_body_3d: CharacterBody3D = $CharacterBody3D
#@onready var body: Node3D = $CharacterBody3D/body
#@onready var head: Node3D = body.get_node("head")
#@onready var legs: Array[Node3D] = [body.get_node("leg_fl"), body.get_node("leg_fr"), body.get_node("leg_bl"), body.get_node("leg_br")]
#var leg_timing_offsets = [0.3, 0.8, 1.0, 0.5]
#var time : float = 2.0
#@export var feet_motion : Curve
#
#var time_fr = 0.0
#var target_fr := Vector3(0,1,0):
	#set(v):
		#target_fr = v
		#ik_terget_fr.global_position = v
#@onready var ik_terget_fr: Sprite3D = $IK_terget_fr
#@onready var leg_fr: Node3D = $CharacterBody3D/body/leg_fr
#@onready var leg_fr_lower: Node3D = $CharacterBody3D/body/leg_fr/leg_fr_lower
#@onready var raycast: RayCast3D = $CharacterBody3D/body/leg_fr/raycast_leg
#var leg_reach_distance = 0.6
#
#func _ready() -> void:	
	#raycast.add_exception($CharacterBody3D)
#
#func _process(delta: float) -> void:
	#time += delta
	#time_fr = time_fr + delta if time_fr <= 3.0 else 0
	#if time_fr == 0 or distance(leg_fr.global_position, target_fr) > leg_reach_distance:
		##raycast.reparent(legs[2], false)
		#var new_target = find_new_target()
		#if new_target:
			#target_fr = new_target
		#else:
			#target_fr = leg_fr.position + Vector3(-1,0,0.5) #if cant find ground: be weird
		#
	#leg_fr.look_at(target_fr)
#
#func _physics_process(delta: float) -> void:
	#var angle = sin(time*0.5)
	#character_body_3d.velocity.z = -0.66 * cos(angle)
	#character_body_3d.velocity.x = -0.66 * sin(angle)
	#character_body_3d.rotation.y = angle
	#if not character_body_3d.is_on_floor():
		#character_body_3d.velocity += character_body_3d.get_gravity() * delta
	#
	#character_body_3d.move_and_slide()
#
#func distance(v1 : Vector3, v2 : Vector3):
	#var diff : Vector3 = v1 - v2
	#return diff.length()
#
#func find_new_target():
	#raycast.target_position = Vector3(0,-2,4)
	#raycast.force_raycast_update()
	#if raycast.is_colliding():
		#if distance(leg_fr.global_position, raycast.get_collision_point()) <= leg_reach_distance:
			#return raycast.get_collision_point()
	#
	#raycast.target_position = Vector3(0,-2,2)
	#raycast.force_raycast_update()
	#if raycast.is_colliding():
		#if distance(leg_fr.global_position, raycast.get_collision_point()) <= leg_reach_distance:
			#return raycast.get_collision_point()
	#
	#raycast.target_position = Vector3(0,-2,0.1)
	#raycast.force_raycast_update()
	#if raycast.is_colliding():
		#if distance(leg_fr.global_position, raycast.get_collision_point()) <= leg_reach_distance:
			#return raycast.get_collision_point()
	#
	#return null
