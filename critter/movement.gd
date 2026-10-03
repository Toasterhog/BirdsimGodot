extends CharacterBody3D

@onready var character_body_3d: CharacterBody3D = $"."
@onready var body: Node3D = $body
@onready var head: Node3D = body.get_node("head")

@onready var navigation: Navigation = $"../navigation"
var walk_speed = 0.6

#func _ready() -> void:
	#navigation.update()

func _physics_process(delta: float) -> void:
	if have_reached_goal():
		navigation.update()
	var goal_direction2D = Vector2(navigation.goal.x - character_body_3d.global_position.x, navigation.goal.z - character_body_3d.global_position.z).normalized()
	#var direction =  character_body_3d.velocity.normalized().slerp( (navigation.goal-position-character_body_3d.position).normalized(), 0.1)
	var dir2D = Vector2( character_body_3d.velocity.x, character_body_3d.velocity.z).normalized().slerp(goal_direction2D,0.04)
	character_body_3d.rotation.y = -dir2D.angle() -PI/2 #forward = -z, angle 0 = +x
	var look = -goal_direction2D.angle()-PI/2
	look = look +TAU if look < 0 else look
	look = lerp_angle( head.rotation.y ,( look  - character_body_3d.rotation.y) ,  0.1)
	look = clampf(look, -1, 1)
	head.rotation.y = look 
	character_body_3d.velocity.x = dir2D.x * walk_speed
	character_body_3d.velocity.z = dir2D.y * walk_speed
	
	if not character_body_3d.is_on_floor():
		character_body_3d.velocity += character_body_3d.get_gravity() * delta
	
	character_body_3d.move_and_slide()

func have_reached_goal() -> bool:
	var diffish = abs(character_body_3d.global_position.x - navigation.goal.x) + abs(character_body_3d.global_position.z - navigation.goal.z)
	return diffish < 1.0 #meters from goal ish 
