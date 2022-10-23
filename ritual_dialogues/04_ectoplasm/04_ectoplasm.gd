extends RitualDialogueHandler

# level details
var spirit_color_1 = Color8(55, 120, 81) # green
var spirit_color_2 = Color8(172, 91, 53) # orange
var spirit_types_1_1 = ["ectoplasm_2", "normal", "normal"]
var spirit_types_1_2 = ["ectoplasm_2", "normal", "normal"]
var spirit_types_2_1 = ["ectoplasm_2", "ectoplasm_3", "normal"]
var spirit_types_2_2 = ["ectoplasm_2", "ectoplasm_3", "normal"]

var _00_intro
var _01a_ectoplasm
var _01b_football
var _02a_just_wait
var _02b_of_course
var _03a_finished
var _03b_possessed

func _ready():
	super()
	await get_tree().current_scene.ready
	
	MessageBus.spawn_spirit_trio.emit(spirit_color_1, spirit_types_1_1)
	MessageBus.spawn_spirit_trio.emit(spirit_color_2, spirit_types_1_2)
	
	await progress_dialog(_00_intro, "start")
	MessageBus.ectoplasm_spawned.connect(ectoplasm_spawned)
	MessageBus.exorcise_spirits_in_jar.connect(little_break_football)
	MessageBus.host_completely_exorcised.connect(second_set_of_spirits)
	MessageBus.host_is_possessed.connect(possessed)
	
func ectoplasm_spawned():
	MessageBus.ectoplasm_spawned.disconnect(ectoplasm_spawned)
	await progress_dialog(_01a_ectoplasm, "start")
	
func little_break_football(_spirits_in_jar):
	MessageBus.exorcise_spirits_in_jar.disconnect(little_break_football)
	await progress_dialog(_01b_football, "start")
	
func second_set_of_spirits():
	MessageBus.host_completely_exorcised.disconnect(second_set_of_spirits)
	await progress_dialog(_02a_just_wait, "start")
	await wait(1)
	MessageBus.spawn_spirit_trio.emit(spirit_color_1, spirit_types_2_1)
	MessageBus.spawn_spirit_trio.emit(spirit_color_2, spirit_types_2_2)
	await wait(3)
	await progress_dialog(_02b_of_course, "start")
	
func finished():
	MessageBus.host_completely_exorcised.disconnect(finished)
	await wait(3)
	await progress_dialog(_03a_finished, "start")
	# TODO
	# var next_scene: PackedScene = preload("res://scenes/05_chains.tscn")
	# get_tree().change_scene_to_packed(next_scene)
	
func possessed():
	MessageBus.host_is_possessed.disconnect(possessed)
	await progress_dialog(_03b_possessed, "start")
	MessageBus.show_overlay_for.emit("retry")
