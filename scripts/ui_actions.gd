extends Control

func _ready():
	MessageBus.show_overlay_for.connect(show_overlay_for)
	pass

func retry_level():
	get_tree().reload_current_scene()

func show_overlay_for(option):
	visible = true
	get_node(option).visible = true
