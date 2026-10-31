extends State
class_name StateWalk

func PhysicsUpdate(delta, sheep : Node):
	var navigation = sheep.navigation
	if have_reached_goal():
		navigation.update()
	var goal_direction2D = Vector2(navigation.goal.x - sheep.global_position.x, navigation.goal.z - sheep.global_position.z).normalized()
	#var direction =  sheep.velocity.normalized().slerp( (navigation.goal-position-sheep.position).normalized(), 0.1)
	var dir2D = Vector2( sheep.velocity.x, sheep.velocity.z).normalized().slerp(goal_direction2D,0.04)
	sheep.rotation.y = -dir2D.angle() -PI/2 #forward = -z, angle 0 = +x
	var look = -goal_direction2D.angle()-PI/2
	look = look +TAU if look < 0 else look
	look = lerp_angle( sheep.head.rotation.y ,( look  - sheep.rotation.y) ,  0.1)
	look = clampf(look, -1, 1)
	sheep.head.rotation.y = look 
	sheep.velocity.x = dir2D.x * sheep.walk_speed
	sheep.velocity.z = dir2D.y * sheep.walk_speed
	
	if not sheep.is_on_floor():
		sheep.velocity += sheep.get_gravity() * delta
	
	sheep.move_and_slide()

func have_reached_goal() -> bool:
	var diffish = abs(sheep.global_position.x - navigation.goal.x) + abs(sheep.global_position.z - navigation.goal.z)
	return diffish < 1.0 #meters from goal ish 
