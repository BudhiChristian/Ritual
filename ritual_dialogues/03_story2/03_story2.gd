extends RitualDialogueHandler

var _03_00 = preload("res://ritual_dialogues/03_story2/03_00_story.dialogue")

func _ready():
	super()
	await get_tree().current_scene.ready
	
	await progress_dialog(_03_00, "start")
	var next_scene: PackedScene = preload("res://scenes/04_ectoplasm.tscn")
	get_tree().change_scene_to_packed(next_scene)
