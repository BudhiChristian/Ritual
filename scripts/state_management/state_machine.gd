extends Node
class_name StateMachine

@export var current_state:Node
@export var interaction_area:Area2D

func _ready() -> void:
	for state in get_children():
		if (state as BaseState):
			(state as BaseState).state_machine = self

func _on_interaction_area_input(viewport, event, shape):
	current_state.handle_input(event)
	pass

func set_state(new_state):
	current_state.on_exit()
	current_state = new_state
	current_state.on_enter()
