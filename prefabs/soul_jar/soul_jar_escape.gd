extends Node2D

class_name SoulJarEscape

var center: Vector2
var spirit: Node2D

func _init(center, spirit):
	self.center = center
	self.spirit = spirit

func _process(delta: float) -> void:
	if spirit == null || !spirit.is_jarred || spirit.jarred_time >= spirit.max_jarred_time:
		queue_free()
	else:
		queue_redraw()
		
func _draw() -> void:
	var radius = 20
	var remaining_time = spirit.max_jarred_time - spirit.jarred_time
	var final_angle = 2 * PI * (remaining_time/spirit.max_jarred_time)
	var segments = 360
	draw_arc(center, radius, 0, 2 * PI, segments, Color.BLACK, 10)
	draw_arc(center, radius, 0, 2 * PI, segments, Color.PLUM, 4)
	draw_arc(center, radius, 0, final_angle, segments, spirit.spirit_color, 4)
