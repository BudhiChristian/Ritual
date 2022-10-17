extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var is_in_a_triangle = false
	for triangle in get_tree().get_nodes_in_group("triangles"):
		if Geometry2D.is_point_in_polygon(position, triangle.vector_points):
			is_in_a_triangle = true
	modulate = Color.FOREST_GREEN if is_in_a_triangle else Color.PURPLE
