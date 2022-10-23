extends RitualDialogueHandler

var _05_00 = preload("res://ritual_dialogues/05_story3/05_00_story.dialogue")

func _ready():
	super()
	await get_tree().current_scene.ready

	await progress_dialog(_05_00, "start")
	var next_scene: PackedScene = preload("res://scenes/06_chains.tscn")
	get_tree().change_scene_to_packed(next_scene)
