extends RitualDialogueHandler

# level details
var spirit_color = Color8(172, 91, 53)

# state
var spirit_found: bool = false
var learned_pin_removal: bool = false

# dialog
var _00_intro = preload("res://ritual_dialogues/00_tutorial/00_0_intro.dialogue")
var _01a_pins = preload("res://ritual_dialogues/00_tutorial/00_1a_use_pins.dialogue")
var _01b_pins_miss = preload("res://ritual_dialogues/00_tutorial/00_1b_use_pins_miss.dialogue")
var _01c_pins_miss_again = preload("res://ritual_dialogues/00_tutorial/00_1c_use_pins_miss_again.dialogue")
var _02_knife = preload("res://ritual_dialogues/00_tutorial/00_2_use_knife.dialogue")
var _03_two_spirits = preload("res://ritual_dialogues/00_tutorial/00_3_two_spirits_left.dialogue")
var _04_complete = preload("res://ritual_dialogues/00_tutorial/00_4_finished.dialogue")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	# TODO since this is the tutorial we should probably disable tools until they're introdued
	play_intro()
	
func play_intro():
	MessageBus.spawn_spirit_trio.emit(spirit_color)
	await progress_dialog(_00_intro, "start")
	MessageBus.thurible_smoke_changed.connect(play_use_pins)

func play_use_pins(_smoke_color):
	MessageBus.thurible_smoke_changed.disconnect(play_use_pins)
	await progress_dialog(_01a_pins, "start")
	MessageBus.spirit_revealed.connect(play_use_knife)
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
		
func play_use_knife():
	MessageBus.spirit_revealed.disconnect(play_use_knife)
	MessageBus.triangle_created.disconnect(triangle_created)
	MessageBus.triangle_created.disconnect(triangle_created_again)
	spirit_found = true
	await progress_dialog(_02_knife, "start")
	# TODO: This should be unlikely but there's be another branch for if the player doesn't extract the spirit before the triangle expires
	MessageBus.put_spirit_in_jar.connect(play_two_more)
	if !learned_pin_removal:
		# Subscribe to on pin expire?
		pass # TODO teach pin removal
	
func play_two_more(_spirit_in_jar):
	MessageBus.put_spirit_in_jar.disconnect(play_two_more)
	await progress_dialog(_03_two_spirits, "start")
	MessageBus.exorcise_spirits_in_jar.connect(play_finished)
	
func play_finished(_spirits_in_jar):
	MessageBus.exorcise_spirits_in_jar.disconnect(play_finished)
	await progress_dialog(_04_complete, "start")
	# TODO next scene
