extends RitualDialogueHandler

# level details
var spirit_color_1 = Color8(172, 91, 53)
var spirit_color_2 = Color8(55, 120, 81)
var spirit_types = ["normal", "normal", "normal"]

# dialog
var _00_intro = preload("res://ritual_dialogues/02_two_spirits/02_00_intro.dialogue")
var _01_wait_theres_more = preload("res://ritual_dialogues/02_two_spirits/02_01_but_wait_theres_more.dialogue")
var _02a_false_security = preload("res://ritual_dialogues/02_two_spirits/02_02a_second_set.dialogue")
var _02b_theyre_back = preload("res://ritual_dialogues/02_two_spirits/02_02b_second_set_realization.dialogue")
var _03_different_color = preload("res://ritual_dialogues/02_two_spirits/02_03_new_color.dialogue")
var _04a_finished = preload("res://ritual_dialogues/02_two_spirits/02_04a_finished.dialogue")
var _04b_possessed = preload("res://ritual_dialogues/02_two_spirits/02_04b_possessed.dialogue")

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
	
func wait_theres_more(_spirits_in_jar):
	MessageBus.exorcise_spirits_in_jar.disconnect(wait_theres_more)
	await progress_dialog(_01_wait_theres_more, "start")
	
func second_set_of_spirits():
	MessageBus.host_completely_exorcised.disconnect(second_set_of_spirits)
	
	await wait(3)
	await progress_dialog(_02a_false_security, "start")
	await wait(1)
	MessageBus.spawn_spirit_trio.emit(spirit_color_1, spirit_types)
	MessageBus.spawn_spirit_trio.emit(spirit_color_2, spirit_types)
	await wait(3)
	await progress_dialog(_02b_theyre_back, "start")
	MessageBus.spirit_revealed.connect(thats_a_new_color)
	MessageBus.host_completely_exorcised.connect(finished)
	
func thats_a_new_color(color):
	if (color == spirit_color_2):
		MessageBus.spirit_revealed.disconnect(thats_a_new_color)
		await progress_dialog(_03_different_color, "start")

func finished():
	MessageBus.host_completely_exorcised.disconnect(finished)
	await wait(3)
	await progress_dialog(_04a_finished, "start")
	var next_scene: PackedScene = preload("res://scenes/03_story2.tscn")
	get_tree().change_scene_to_packed(next_scene)

func possessed():
	MessageBus.host_is_possessed.disconnect(possessed)
	await progress_dialog(_04b_possessed, "start")
	MessageBus.show_overlay_for.emit("retry")
