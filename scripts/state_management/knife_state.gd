extends BaseState

var held_spirit = null:
	set(value):
		held_spirit = value
		MessageBus.set_spirit_stored.emit(value != null)

func _ready() -> void:
	super()
	self.tool_name = "dagger"
	
# TODO: It might be kinda neat if the red pins had a wide area but a short active time,
# and the blue pins had the opposite
func handle_spirit_clicked(spirit:Node2D):
	if held_spirit == null:
		spirit.is_captured = true
		held_spirit = spirit
	
func handle_soul_jar_clicked():
	if held_spirit != null:
		MessageBus.put_spirit_in_jar.emit(held_spirit)
		held_spirit = null
		
func handle_ectoplasm_clicked(ectoplasm):
	MessageBus.ectoplasm_manually_removed.emit(ectoplasm)
	

func on_exit():
	if held_spirit != null:
		held_spirit.is_captured = false
		held_spirit = null
