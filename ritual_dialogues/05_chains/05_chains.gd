extends RitualDialogueHandler

# level details
var spirit_color_1 = Color8(55, 120, 81) # green
var spirit_color_2 = Color8(172, 91, 53) # orange
var spirit_types = ["chains", "chains", "chains"]

func _ready():
	super()
	await get_tree().current_scene.ready
	
	MessageBus.spawn_spirit_trio.emit(spirit_color_1, spirit_types)
