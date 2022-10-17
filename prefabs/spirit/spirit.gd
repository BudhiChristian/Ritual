extends Node2D

var is_capturable = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var is_in_a_triangle = false
	for triangle in get_tree().get_nodes_in_group("triangles"):
		if Geometry2D.is_point_in_polygon(position, triangle.vector_points):
			is_in_a_triangle = true
			
	is_capturable = is_in_a_triangle
	modulate = Color.FOREST_GREEN if is_in_a_triangle else Color.PURPLE


# TODO: we should disable the click handler if the ghost is not visible,
# because it blocks other interactions
func _on_click_handler_gui_input(event: InputEvent) -> void:
	if is_capturable:
		if (event is InputEventMouseButton):
			if (event as InputEventMouseButton).button_index == 1:
				if event.is_pressed():
					MessageBus.spirit_clicked.emit(self)
