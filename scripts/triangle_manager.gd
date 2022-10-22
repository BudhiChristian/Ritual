extends Node2D
class_name TriangleManager

var max_duration = 12.0
var duration = max_duration
var triangle_points

var max_distance_for_points = 240
var is_active = false

var vector_points:
	get:
		return triangle_points.map(func(t): return t.position)

func _init(points):
	triangle_points = points

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("triangles")
	MessageBus.triangle_created.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	duration -= delta
	queue_redraw()
	if duration <= 0:
		queue_free()
	
func _exit_tree() -> void:
	for pin in triangle_points:
		pin.is_exhausted = true
	MessageBus.triangle_expired.emit()
	remove_from_group("triangles")

func _draw():
	var total_length_of_lines = 0
	for i in triangle_points.size():
		var line_start:Vector2 = triangle_points[i].position
		var j = (i+1) % triangle_points.size()
		var line_end = triangle_points[j].position
		total_length_of_lines += line_start.distance_to(line_end)
	
	var countdown_line_length = total_length_of_lines * (duration / max_duration)
	
	var is_valid = true
	var length_of_lines_so_far = 0
	for i in triangle_points.size():
		# initial calculations
		var line_start = triangle_points[i].position
		var j = (i+1) % triangle_points.size()
		var line_end = triangle_points[j].position
		var current_line_length = line_start.distance_to(line_end)
		
		# draw the underlying line
		if current_line_length > max_distance_for_points:
			is_valid = false # arguably this is kind of a side effect but w/e. It's game jam code
			draw_dashed_line(line_start, line_end, Color.WHITE, 2, 5)
		else:
			draw_line(line_start, line_end, Color.WHITE, 2, true)
		
		# draw the countdown line
		var countdown_line_width = lerp(4.0, 11.0, (sin(duration * PI * 1.25)/2) + 0.5)
		if countdown_line_length >= length_of_lines_so_far + current_line_length:
			draw_line(line_start, line_end, Color(Color.BLUE, 0.4), countdown_line_width, true)
		elif countdown_line_length >= length_of_lines_so_far:
			var remaining_segment_length = (countdown_line_length - length_of_lines_so_far)
			var unit_direction = (line_end - line_start).normalized()
			var countdown_line_end = line_start + (unit_direction * remaining_segment_length)
			draw_line(line_start, countdown_line_end, Color(Color.BLUE, 0.4), countdown_line_width, true)
		
		length_of_lines_so_far += current_line_length
	is_active = is_valid
