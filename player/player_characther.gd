extends CharacterBody3D

var world_data
var speed
var hovering : bool = true
const WALK_SPEED = 3.5
const HOVER_SPEED = 10.0
const HOVER_SPRINT_SPEED = 20.0
const HOVER_Y_SPEED = 15
const SPRINT_SPEED = 5.5
const JUMP_VELOCITY = 3.5
@onready var timer: Timer = $Timer

@onready var camera: Camera3D = $Camera3D
var look_around_sensitivity := 0.006


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == 2:
			rotation.y -= event.relative.x * look_around_sensitivity
			camera.rotation.x -= event.relative.y * look_around_sensitivity
	elif Input.is_action_just_pressed("toggle_captured_mouse"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if Input.mouse_mode != 2 else Input.MOUSE_MODE_VISIBLE)
		get_viewport().gui_release_focus()
	elif Input.is_action_just_pressed("move up"):
		if timer.is_stopped():
			timer.start()
		else:
			hovering = not hovering
			timer.stop()


func _process(delta: float) -> void:
	if hovering:
		velocity.y = lerp(velocity.y, Input.get_axis("move down" ,"move up") * HOVER_Y_SPEED, delta * 10.0)
		if is_on_floor():
			hovering = false
		# Handle Sprint #
		if Input.is_action_pressed("sprint"):
			speed = HOVER_SPRINT_SPEED
		else:
			speed = HOVER_SPEED
	else:
		#if is_in_water():
			#velocity -= get_gravity() * delta  *0.25
			#velocity.y *= 0.98
		if not is_on_floor():
			velocity += get_gravity() * delta * (1.4 if velocity.y < 0 else 1.0)
		elif Input.is_action_pressed("move up"):
			velocity.y = JUMP_VELOCITY
		# Handle Sprint #
		if Input.is_action_pressed("sprint"):
			speed = SPRINT_SPEED
		else:
			speed = WALK_SPEED

	# Get the input direction and handle the movement/deceleration #
	# As good practice, you should replace UI actions with custom gameplay actions #
	var input_dir = Input.get_vector("move left", "move right", "move forward", "move back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y))#.normalized()
	if is_on_floor():
		if direction: #walk
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else: #walk decel
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 12.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 12.0)
	else: #in air
		if hovering:
			if direction: #hover
				velocity.x = lerp(velocity.x, direction.x * speed, delta * 8.0)
				velocity.z = lerp(velocity.z, direction.z * speed, delta * 8.0)
			else: #hover decel
				velocity.x = lerp(velocity.x, direction.x * speed, delta * 1.0)
				velocity.z = lerp(velocity.z, direction.z * speed, delta * 1.0)
		#jum air controll
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 4.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 4.0)
	
	move_and_slide()
