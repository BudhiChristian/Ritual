extends Node2D
class_name TriangleManager

var triangle_points

var vector_points:
	get:
		return triangle_points.map(func(t): return t.position)

func _init(points):
	triangle_points = points

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("triangles")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
	
func _exit_tree() -> void:
	remove_from_group("triangles")

func _draw():
	for i in triangle_points.size():
		var line_start = triangle_points[i].position
		var j = (i+1) % triangle_points.size()
		var line_end = triangle_points[j].position
		draw_line(line_start, line_end, Color.WHITE, 2, true)
