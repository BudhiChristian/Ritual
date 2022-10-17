extends Node2D

var _is_dragging = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# TODO: do we want to limit when dragging can happen? Or does dragging always override your current selected tool?
# TODO: we should figure out a way to detect a single brief click as a way to "retreive" the pin.
# I guess actually you could also just drag it back to the "tool handle," as well.
func _on_pin_head_gui_input(event: InputEvent) -> void:
	var mouse_button_event = (event as InputEventMouseButton)
	if mouse_button_event:
		if mouse_button_event.button_index == 1:
			if mouse_button_event.is_pressed():
				_is_dragging = true
			else:
				_is_dragging = false
	var mouse_motion_event = (event as InputEventMouseMotion)
	if mouse_motion_event and _is_dragging:
		position += (mouse_motion_event.relative * global_scale)
