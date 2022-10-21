extends RitualDialogueHandler

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	# TODO since this is the tutorial we should probably disable tools until they're introdued
	play_intro()
	
func play_intro():
	var dialog = preload("res://ritual_dialogues/00_tutorial/intro.dialogue")
	await progress_dialog(dialog, "start")
	MessageBus.thurible_smoke_changed.connect(play_use_pins)

func play_use_pins(_smoke_color):
	MessageBus.thurible_smoke_changed.disconnect(play_use_pins)
	var dialog = preload("res://ritual_dialogues/00_tutorial/use_pins.dialogue")
	await progress_dialog(dialog, "start")
	MessageBus.spirit_revealed.connect(play_use_knife)
	
func play_use_knife():
	MessageBus.spirit_revealed.disconnect(play_use_knife)
	var dialog = preload("res://ritual_dialogues/00_tutorial/use_knife.dialogue")
	await progress_dialog(dialog, "start")
	MessageBus.put_spirit_in_jar.connect(play_two_more)
	
func play_two_more(_spirit_in_jar):
	MessageBus.put_spirit_in_jar.disconnect(play_two_more)
	var dialog = preload("res://ritual_dialogues/00_tutorial/two_spirits_left.dialogue")
	await progress_dialog(dialog, "start")
	MessageBus.exorcise_spirits_in_jar.connect(play_finished)
	
func play_finished(_spirits_in_jar):
	MessageBus.exorcise_spirits_in_jar.disconnect(play_finished)
	var dialog = preload("res://ritual_dialogues/00_tutorial/finished.dialogue")
	await progress_dialog(dialog, "start")
	# TODO: If we wanted to, we could emit a signal here to spawn another three ghosts or something.
