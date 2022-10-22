extends Node
class_name RitualDialogueHandler

signal advance_dialogue()
var dialogue_box: Control
var dialogue_label: Control
var level_ui_prefab: PackedScene = preload("res://prefabs/level_ui.tscn")

# In the future, I think each ritual can be a unique node like this one
# and we can swap them out depending on what level the player is on
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var level_ui = level_ui_prefab.instantiate()
	dialogue_box = level_ui.get_node("dialogue_box")
	dialogue_label = dialogue_box.get_node('Label')
	dialogue_box.visible = false
	add_child(level_ui)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() && event.button_index == 1:
			advance_dialogue.emit()

func progress_dialog(resource, title):
	dialogue_box.visible = true
	set_ritual_paused(true)
	dialogue_label.visible = true
	var dialog_line:Dictionary = await DialogueManager.get_next_dialogue_line(resource, title)
	if dialog_line.is_empty():
		dialogue_label.visible = false
		set_ritual_paused(false)
		return
	dialogue_label.dialogue_line = dialog_line
	dialogue_label.type_out()
	await dialogue_label.finished_typing
	await advance_dialogue
	await progress_dialog(resource, dialog_line.next_id)
	dialogue_box.visible = false
	
func set_ritual_paused(is_paused):
	get_tree().paused = is_paused
	
func wait(time_in_seconds: float):
	var t = Timer.new()
	t.set_wait_time(time_in_seconds)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	await t.timeout
	t.queue_free()
