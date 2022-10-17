extends Node
class_name BaseState

var state_machine: StateMachine
var is_usable: bool = true

func on_enter():
	pass
	
func handle_spirit_clicked(spirit):
	pass
	
func handle_soul_jar_clicked():
	pass

func handle_input(event:InputEvent):
	pass
	
func on_exit():
	pass

func start():
	state_machine.set_state(self)
