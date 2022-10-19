extends Node2D
@onready var click_handler: Control = %click_handler

var spirit_color: Color = Color.PURPLE
var spirit_color_debug: Color = Color.PLUM

var jarred_time: float = 0
var is_jarred = false:
	set(value):
		is_jarred = value
		jarred_time = 0


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
	var pin_groups = get_tree().get_nodes_in_group("triangles")
	var is_in_a_triangle = pin_groups.any(func(group): return group.is_active && Geometry2D.is_point_in_polygon(position, group.vector_points))

	is_capturable = is_in_a_triangle
	is_exposed = is_in_a_triangle
	# TODO some other indicator, 2 colors is confusing (Metal Geal exclamation?)
	modulate = spirit_color if is_in_a_triangle else spirit_color_debug
	
	if is_jarred:
		jarred_time += delta
		if jarred_time > 5:
			_spirit_excapes()


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

# TODO: When captured start timer for escape
func _spirit_excapes():
	self.is_capturable = false
	self.is_captured = false
	self.is_exposed = false
	MessageBus.spirit_escapes_jar.emit(self)
