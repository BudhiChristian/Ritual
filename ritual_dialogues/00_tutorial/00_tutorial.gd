extends RitualDialogueHandler

# level details
var spirit_color = Color8(172, 91, 53)

# state
var spirit_found: bool = false
var learned_pin_removal: bool = false

# dialog
var _00_intro = preload("res://ritual_dialogues/00_tutorial/00_00_intro.dialogue")
var _01a_pins = preload("res://ritual_dialogues/00_tutorial/00_01a_use_pins.dialogue")
var _01b_pins_miss = preload("res://ritual_dialogues/00_tutorial/00_01b_use_pins_miss.dialogue")
var _01c_pins_miss_again = preload("res://ritual_dialogues/00_tutorial/00_01c_use_pins_miss_again.dialogue")
var _01d_pin_removing = preload("res://ritual_dialogues/00_tutorial/00_01d_use_pin_removing.dialogue")
var _02_knife = preload("res://ritual_dialogues/00_tutorial/00_02_use_knife.dialogue")
var _03_two_spirits = preload("res://ritual_dialogues/00_tutorial/00_03_two_spirits_left.dialogue")
var _04a_complete = preload("res://ritual_dialogues/00_tutorial/00_04a_finished.dialogue")
var _04b_possessed = preload("res://ritual_dialogues/00_tutorial/00_04b_possessed.dialogue")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	MessageBus.host_is_possessed.connect(possessed)

	MessageBus.disable_tool.emit("thurible")
	MessageBus.disable_tool.emit("dagger")
	MessageBus.disable_tool.emit("pins")
	
	MessageBus.spawn_spirit_trio.emit(spirit_color)
	play_intro()
	
func play_intro():
	MessageBus.enable_tool.emit("thurible")
	await progress_dialog(_00_intro, "start")
	MessageBus.thurible_smoke_changed.connect(play_use_pins)

func play_use_pins(_smoke_color):
	MessageBus.thurible_smoke_changed.disconnect(play_use_pins)
	MessageBus.enable_tool.emit("pins")
	await progress_dialog(_01a_pins, "start")
	MessageBus.spirit_revealed.connect(play_use_dagger)
	MessageBus.triangle_created.connect(triangle_created)
	
func triangle_created():
	MessageBus.triangle_created.disconnect(triangle_created)
	await wait(1)
	if !spirit_found:
		await progress_dialog(_01b_pins_miss, "start")
		MessageBus.triangle_created.connect(triangle_created_again)

func triangle_created_again():
	MessageBus.triangle_created.disconnect(triangle_created_again)
	await wait(1)
	if !spirit_found:
		await progress_dialog(_01c_pins_miss_again, "start")
		learned_pin_removal = true
		
func play_use_dagger():
	MessageBus.spirit_revealed.disconnect(play_use_dagger)
	MessageBus.triangle_created.disconnect(triangle_created)
	MessageBus.triangle_created.disconnect(triangle_created_again)
	spirit_found = true
	MessageBus.enable_tool.emit("dagger")
	await progress_dialog(_02_knife, "start")
	MessageBus.put_spirit_in_jar.connect(play_two_more)
	if !learned_pin_removal:
		MessageBus.triangle_expired.connect(triangle_exhausted)

func triangle_exhausted():
	MessageBus.triangle_expired.disconnect(triangle_exhausted)
	await progress_dialog(_01d_pin_removing, "start")
	
func play_two_more(_spirit_in_jar):
	MessageBus.put_spirit_in_jar.disconnect(play_two_more)
	await progress_dialog(_03_two_spirits, "start")
	MessageBus.exorcise_spirits_in_jar.connect(play_finished)
	
func play_finished(_spirits_in_jar):
	MessageBus.exorcise_spirits_in_jar.disconnect(play_finished)
	await progress_dialog(_04a_complete, "start")
	var next_scene: PackedScene = preload("res://scenes/01_story01.tscn")
	get_tree().change_scene_to_packed(next_scene)
	
func possessed():
	MessageBus.host_is_possessed.disconnect(possessed)
	await progress_dialog(_04b_possessed, "start")
	MessageBus.show_overlay_for.emit("retry")
	
