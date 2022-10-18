extends Node2D

@onready var click_handler: Control = %click_handler

var spirit_color: Color = Color.PURPLE
var is_capturable = false

var is_captured = false:
	set(value):
		is_captured = value
		_update_node_visibility()

var is_exposed = false:
	set(value):
		is_exposed = value
		_update_node_visibility()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var is_in_a_triangle = false
	for triangle in get_tree().get_nodes_in_group("triangles"):
		if triangle.is_active:
			if Geometry2D.is_point_in_polygon(position, triangle.vector_points):
				is_in_a_triangle = true
			
	is_capturable = is_in_a_triangle
	is_exposed = is_in_a_triangle
	modulate = Color.FOREST_GREEN if is_in_a_triangle else spirit_color


# TODO: we should disable the click handler if the ghost is not visible,
# because it blocks other interactions
func _on_click_handler_gui_input(event: InputEvent) -> void:
	if is_capturable:
		if (event is InputEventMouseButton):
			if (event as InputEventMouseButton).button_index == 1:
				if event.is_pressed():
					MessageBus.spirit_clicked.emit(self)
					
func _update_node_visibility():
	var is_node_visible = is_exposed and !is_captured
	visible = is_node_visible
	click_handler.process_mode = Node.PROCESS_MODE_INHERIT if is_node_visible else Node.PROCESS_MODE_DISABLED
