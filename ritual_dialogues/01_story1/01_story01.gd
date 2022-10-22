extends RitualDialogueHandler

var _01_00 = preload("res://ritual_dialogues/01_story1/01_00_story.dialogue")

func _ready():
	super()
	await get_tree().current_scene.ready
	
	await progress_dialog(_01_00, "start")
	var next_scene: PackedScene = preload("res://scenes/02_two_spirits.tscn")
	get_tree().change_scene_to_packed(next_scene)
