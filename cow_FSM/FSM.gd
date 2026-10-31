extends Node
class_name FSM

var current_state : State


func _ready() -> void:
	pass
	#current_state = walk_state

func _physics_process(delta: float) -> void:
	current_state.PhysicsUpdate(delta)
