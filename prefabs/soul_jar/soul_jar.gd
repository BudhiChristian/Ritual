extends Node2D

func _on_click_handler_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
		MessageBus.soul_jar_clicked.emit()
