extends Node
class_name Navigation
@onready var nav_raycast: RayCast3D = $nav_raycast
@export var node_with_the_position : Node3D
var goal : Vector3:
	set(v):
		goal = v
		$nav_goal_mesh.global_position = v
var subgoals : Array[Vector3] = []
const max_goal_distance = 20.0

func _ready() -> void:
	goal = $"..".global_position



func update():
	var angle = randf_range(0,TAU)
	var length = randf_range(0,max_goal_distance)
	var testpos = node_with_the_position.global_position + Vector3( length * cos(angle), 0, length * sin(angle))
	nav_raycast.global_position = Vector3(testpos.x, 50, testpos.z)
	#nav_raycast.enabled = true
	#print("waiting physics not")
	#await NOTIFICATION_PHYSICS_PROCESS
	#print("recieved physics not")
	#nav_raycast.enabled = false
	nav_raycast.force_raycast_update()
	var coll_p = nav_raycast.get_collision_point()
	if coll_p.y < 2.0:
		return
	goal = coll_p

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug_multiuse"):
		update()
