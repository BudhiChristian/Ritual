extends Node2D

var _is_dragging = false
var is_exhausted = false:
	set(value):
		is_exhausted = value
		modulate = Color(modulate, 0.7) if is_exhausted else Color(modulate, 1) 

var is_outside_operating_area = false

var is_set_complete = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(self, "rotation", -0.05 * PI, 0.05)
	tween.tween_property(self, "rotation", 0.05 * PI, 0.1)
	tween.tween_property(self, "rotation", 0 * PI, 0.05)
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
				if is_outside_operating_area:
					MessageBus.pin_removed.emit(self)
					queue_free()
		elif mouse_button_event.button_index == 2:
			# right click !
			MessageBus.pin_removed.emit(self)
			queue_free()
				
	var mouse_motion_event = (event as InputEventMouseMotion)
	if mouse_motion_event and _is_dragging and !is_set_complete:
		position += (mouse_motion_event.relative * global_scale)


func _on_collision_checker_area_exited(area: Area2D) -> void:
	if area == OperatingArea.area:
		is_outside_operating_area = true


func _on_collision_checker_area_entered(area: Area2D) -> void:
	if area == OperatingArea.area:
		is_outside_operating_area = false
