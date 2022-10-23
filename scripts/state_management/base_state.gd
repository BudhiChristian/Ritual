extends Node
class_name BaseState

var state_machine: StateMachine
var is_usable: bool = true
var tool_name: String = ""

func _ready():
	MessageBus.enable_tool.connect(enable_tool)
	MessageBus.disable_tool.connect(disable_tool)

func on_enter():
	pass
	
func handle_spirit_clicked(spirit):
	pass
	
func handle_soul_jar_clicked():
	pass

func handle_ectoplasm_clicked(ectoplasm):
	pass

func handle_input(event:InputEvent):
	pass
	
func on_exit():
	pass

func start():
	state_machine.set_state(self)
	
func enable_tool(tool):
	if tool == tool_name:
		is_usable = true
func disable_tool(tool):
	if tool == tool_name:
		is_usable = false
