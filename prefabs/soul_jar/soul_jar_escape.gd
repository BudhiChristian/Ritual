extends Node2D

class_name SoulJarEscape

var center: Vector2
var current_time: float = 100
var max_time: float = 100:
	set(value):
		max_time = value
		current_time = value
var color: Color = Color.PURPLE

func _init(indicator_center, spirit):
	self.center = indicator_center
	self.max_time = spirit.max_jarred_time
	self.color = spirit.spirit_color

func _process(delta: float) -> void:
	current_time -= delta
	current_time = current_time if current_time > 0 else 0
	queue_redraw()
	if current_time <= 0:
		queue_free()
		
func _draw() -> void:
	var radius = 20
	var final_angle = 2 * PI * (current_time/max_time)
	var segments = 360
	draw_arc(center, radius, 0, 2 * PI, segments, Color.WHITE, 3)
	draw_arc(center, radius, 0, final_angle, segments, color, 5)
