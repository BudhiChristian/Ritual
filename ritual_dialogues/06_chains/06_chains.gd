extends RitualDialogueHandler

# level details
var spirit_color_1 = Color8(55, 120, 81) # green
var spirit_color_2 = Color8(172, 91, 53) # orange
var spirit_types_1 = ["normal", "normal", "ectoplasm_2"]
var spirit_types_2 = ["chains", "chains", "chains"]
var spirit_types_3a = ["chains", "chains", "ectoplasm_2"]
var spirit_types_3b = ["chains", "chains", "ectoplasm_3"]

var _00_intro = preload("res://ritual_dialogues/06_chains/06_00_intro.dialogue")
var _01a_theres_more = preload("res://ritual_dialogues/06_chains/06_01a_theres_more.dialogue")
var _01b_chains = preload("res://ritual_dialogues/06_chains/06_01b_chains.dialogue")
var _02_the_final_challenge = preload("res://ritual_dialogues/06_chains/06_02_the_final_challenge.dialogue")
var _03a_finished = preload("res://ritual_dialogues/06_chains/06_03a_finished.dialogue")
var _03b_possessed = preload("res://ritual_dialogues/06_chains/06_03b_possessed.dialogue")

func _ready():
	super()
	await get_tree().current_scene.ready
	
	await progress_dialog(_00_intro, "start")
	MessageBus.spawn_spirit_trio.emit(spirit_color_1, spirit_types_1)
	
	MessageBus.host_completely_exorcised.connect(introduce_chains)
	MessageBus.host_is_possessed.connect(possessed)
	
func introduce_chains():
	MessageBus.host_completely_exorcised.disconnect(introduce_chains)
	
	await wait(1)
	await progress_dialog(_01a_theres_more, "start")
	MessageBus.spawn_spirit_trio.emit(spirit_color_2, spirit_types_2)
	
	MessageBus.host_completely_exorcised.connect(final_challenge)
	MessageBus.chains_created.connect(whats_a_chain)
	
func whats_a_chain():
	MessageBus.chains_created.disconnect(whats_a_chain)
	await progress_dialog(_01b_chains, "start")
	
func final_challenge():
	MessageBus.host_completely_exorcised.disconnect(final_challenge)
	
	await wait(1)
	MessageBus.spawn_spirit_trio.emit(spirit_color_1, spirit_types_3a)
	MessageBus.spawn_spirit_trio.emit(spirit_color_2, spirit_types_3b)
	await wait(3)
	await progress_dialog(_02_the_final_challenge, "start")
	
	MessageBus.host_completely_exorcised.connect(finished)
	
func finished():
	MessageBus.host_completely_exorcised.disconnect(finished)
	await wait(3)
	await progress_dialog(_03a_finished, "start")
	var next_scene: PackedScene = preload("res://scenes/credits.tscn")
	get_tree().change_scene_to_packed(next_scene)
	
func possessed():
	MessageBus.host_is_possessed.disconnect(possessed)
	await progress_dialog(_03b_possessed, "start")
	MessageBus.show_overlay_for.emit("retry")
