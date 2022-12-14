extends Node2D

class_name BaseSpirit

@onready var click_handler: Control = %click_handler
@onready var thurible_collider: Area2D = %thurible_collider


var spirit_color_debug: Color = Color(Color.PURPLE, 0.5)
var spirit_color: Color = Color.PURPLE:
	set(value):
		spirit_color = value
		spirit_color_debug = Color(value, 0.5)
var max_jarred_time: float = 60 # seconds

var jarred_time: float = 0
var is_jarred = false:
	set(value):
		is_jarred = value
		jarred_time = 0


var is_capturable = false

var is_captured = false:
	set(value):
		if !is_captured and value:
			on_capture()
		is_captured = value
		_update_node_visibility()

var is_exposed = false:
	set(value):
		is_exposed = value
		_update_node_visibility()

var spawns_ectoplasm: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var was_exposed = is_exposed
	is_exposed = get_is_exposed()
	is_capturable = get_is_capturable()
	if !was_exposed and is_exposed:
		on_expose()
		
	if was_exposed and !is_exposed:
		on_hide()

	modulate = spirit_color if is_exposed else spirit_color_debug
	
	if is_jarred:
		jarred_time += delta
		if jarred_time > max_jarred_time:
			_spirit_escapes()

func get_is_exposed():
	var pin_groups = get_tree().get_nodes_in_group("triangles")
	var is_in_a_triangle = pin_groups.any(func(group):
		# expand the polygon a little to catch ghosts that are _just_ on the border
		var polygon_to_check = Geometry2D.offset_polygon(group.vector_points, 35)[0]
		return group.is_active && Geometry2D.is_point_in_polygon(position, polygon_to_check)
	)
	return is_in_a_triangle
	
func get_is_capturable():
	return is_exposed
	
func on_expose():
	MessageBus.spirit_revealed.emit(spirit_color)
	
func on_hide():
	pass
	
func on_capture():
	pass

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
	var pm = Node.PROCESS_MODE_INHERIT if is_node_visible else Node.PROCESS_MODE_DISABLED
	click_handler.process_mode = pm
	thurible_collider.monitoring = !is_captured
	thurible_collider.monitorable = !is_captured

func _spirit_escapes():
	self.is_capturable = false
	self.is_captured = false
	self.is_exposed = false
	self.is_jarred = false
	MessageBus.spirit_escapes_jar.emit(self)
