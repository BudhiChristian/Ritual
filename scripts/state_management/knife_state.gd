extends BaseState

var held_spirit = null:
	set(value):
		held_spirit = value
		MessageBus.set_spirit_stored.emit(value != null)
var spirits_in_jar = []

# TODO: It might be kinda neat if the red pins had a wide area but a short active time,
# and the blue pins had the opposite
func handle_spirit_clicked(spirit:Node2D):
	if held_spirit == null:
		spirit.is_captured = true
		held_spirit = spirit
	
func handle_soul_jar_clicked():
	if held_spirit != null:
		spirits_in_jar.append(held_spirit)
		held_spirit = null

func on_exit():
	if held_spirit != null:
		held_spirit.is_captured = false
		held_spirit = null
