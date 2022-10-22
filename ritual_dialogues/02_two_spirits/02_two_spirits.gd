extends RitualDialogueHandler

# level details
var spirit_color_1 = Color8(172, 91, 53)
var spirit_color_2 = Color8(55, 120, 81)

# dialog
var _00_intro = preload("res://ritual_dialogues/02_two_spirits/02_00_intro.dialogue")

# TODO dialogue
func _ready() -> void:
	super()
	await get_tree().current_scene.ready
	MessageBus.host_is_possessed.connect(possessed)

	first_set_of_spirits()
	
func first_set_of_spirits():
	await progress_dialog(_00_intro, "start")
	MessageBus.spawn_spirit_trio.emit(spirit_color_1)
	MessageBus.spawn_spirit_trio.emit(spirit_color_1)
	
	MessageBus.host_completely_exorcised.connect(second_set_of_spirits)
	
func second_set_of_spirits():
	MessageBus.host_completely_exorcised.disconnect(second_set_of_spirits)
	
	MessageBus.spawn_spirit_trio.emit(spirit_color_1)
	MessageBus.spawn_spirit_trio.emit(spirit_color_2)
	
func possessed():
	MessageBus.host_is_possessed.disconnect(possessed)
	MessageBus.show_overlay_for.emit("retry")
