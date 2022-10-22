extends RitualDialogueHandler

# level details
var spirit_color_1 = Color8(172, 91, 53)
var spirit_color_2 = Color8(55, 120, 81)
var spirit_types = ["normal", "normal", "normal"]

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
	MessageBus.spawn_spirit_trio.emit(spirit_color_1, spirit_types)
	MessageBus.spawn_spirit_trio.emit(spirit_color_1, spirit_types)
	
	MessageBus.exorcise_spirits_in_jar.connect(wait_theres_more)
	MessageBus.host_completely_exorcised.connect(second_set_of_spirits)
	
func wait_theres_more():
	MessageBus.exorcise_spirits_in_jar.disconnect(wait_theres_more)
	# TODO explain that there's more spirits
	
	
func second_set_of_spirits():
	MessageBus.host_completely_exorcised.disconnect(second_set_of_spirits)
	
	# TODO false success
	await wait(1)
	MessageBus.spawn_spirit_trio.emit(spirit_color_1, spirit_types)
	MessageBus.spawn_spirit_trio.emit(spirit_color_2, spirit_types)
	await wait(1)
	# TODO Ask why more spirits have shown up
	# TODO Hook on to color two being revealed by thurable
	
func thats_a_new_color():
	# TODO explain that spirits come in different colors and you can only put three of the same color in a jar
	pass

func possessed():
	MessageBus.host_is_possessed.disconnect(possessed)
	MessageBus.show_overlay_for.emit("retry")
