@tool
extends Node3D

var time : float = 0
@export var feet_motion_forward : Curve
@export var feet_motion_up : Curve
@export_range(0.0, 1.0, 0.05) var DEBUG_Y_strength : float = 1.0
@export_range(0.0, 1.0, 0.05) var DEBUG_fold_strength : float = 1.0
@export var disable_find_target : bool = false

@onready var target_node: MeshInstance3D = $target_node
var target_global_pos := Vector3.ZERO #becouse target_node.global_position moves with thigh
var smooth_target := Vector3.ZERO #local
var old_local_target_rel_tn_glob := Vector3.ZERO #local

@onready var thigh: Node3D = $thigh
@onready var lower_leg: Node3D = $thigh/lower_leg
@onready var raycast: RayCast3D = $raycast_leg
var reach_distance = 0.6

func _ready() -> void:
	var maybe_char_body = $"../.."
	if maybe_char_body is CollisionObject3D:
		raycast.add_exception(maybe_char_body)
	thigh.rotation.x = 0

func _process(delta: float) -> void:
	if not disable_find_target:
		time += delta
		if time >= 3.0 or ( time > 1.0 and thigh.position.distance_squared_to(target_node.position) > reach_distance*reach_distance ):
			time = 0
			var new_target = find_new_target()
			if new_target:
				old_local_target_rel_tn_glob = target_node.position - new_target
				target_global_pos = new_target
			else:
				time = 2.9
				#target_node.global_position = thigh.global_position + Vector3(0, 10, 0) #if cant find ground: be weird
	
	
	if target_global_pos:
		target_node.global_position = target_global_pos
	if smooth_target != target_node.position:
		var from = old_local_target_rel_tn_glob+target_node.global_position
		var sample_at = min(1,time*1.6)
		var amount = feet_motion_forward.sample_baked(sample_at)
		var up_offset = Vector3.UP *  feet_motion_up.sample_baked(sample_at)
		smooth_target = from.lerp(target_node.position, amount) + up_offset
	

	
	#var angle = atan2(smooth_target.y, -smooth_target.z)
	#var length = thigh.position.distance_to(smooth_target)
	#length = min(length, reach_distance)
	#var fold = acos(length / reach_distance) * DEBUG_fold_strength
	#thigh.rotation.x = angle + fold
	#lower_leg.rotation.x = -fold*2
	#thigh.rotation.y = atan2(-smooth_target.x, -smooth_target.z) * DEBUG_Y_strength #(Vector3.FORWARD).signed_angle_to(target_node.position, Vector3.UP)
	

	var roll = atan2(smooth_target.y, smooth_target.x)
	var pitch = -Vector3.FORWARD.signed_angle_to(smooth_target, Vector3.FORWARD.cross(smooth_target))
	var length = thigh.position.distance_to(smooth_target)
	length = min(length, reach_distance)
	var fold = acos(length / reach_distance) * DEBUG_fold_strength
	thigh.rotation.y = pitch + fold
	lower_leg.rotation.y = -fold*2
	thigh.rotation.z = roll * DEBUG_Y_strength 
	
	
	
	#$testbone.rotation.z = roll
	#$testbone.rotation.y = pitch * DEBUG_fold_strength
	#$testbone.scale.z = length



func distance(v1 : Vector3, v2 : Vector3):
	var diff : Vector3 = v1 - v2
	return diff.length()


func find_new_target():
	for i in 4:
		raycast.target_position =  Vector3.FORWARD.rotated(Vector3.RIGHT, -0.2*(i+1)) * (reach_distance +0.4) #två decimeter extra för smooth ikap
		raycast.force_raycast_update()
		if raycast.is_colliding():
			#if distance(thigh.global_position, raycast.get_collision_point()) <= reach_distance:
			target_node.scale.y = 1
			return raycast.get_collision_point()
	target_node.scale.y = 4
	time = 2.1
	return thigh.global_position + (-global_basis.z).rotated(global_basis.x.normalized(), -0.4) * (reach_distance +0.2)

#func find_new_target():
	#raycast.target_position = Vector3(0,-2, -4)
	#raycast.force_raycast_update()
	#if raycast.is_colliding():
		#if distance(thigh.global_position, raycast.get_collision_point()) <= reach_distance:
			#return raycast.get_collision_point()
	#
	#raycast.target_position = Vector3(0,-2, -2)
	#raycast.force_raycast_update()
	#if raycast.is_colliding():
		#if distance(thigh.global_position, raycast.get_collision_point()) <= reach_distance:
			#return raycast.get_collision_point()
	#
	#raycast.target_position = Vector3(0,-2, -0.1)
	#raycast.force_raycast_update()
	#if raycast.is_colliding():
		#if distance(thigh.global_position, raycast.get_collision_point()) <= reach_distance:
			#return raycast.get_collision_point()
	#
	#return null
