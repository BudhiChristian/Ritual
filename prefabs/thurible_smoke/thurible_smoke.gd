extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rotation = randf_range(0, PI)
	var possible_directions = [-1, 1]
	possible_directions.shuffle()
	var final_rotation = rotation + (
		randf_range(PI / 10, PI / 12) * possible_directions.front()
	)
	
	var tween = create_tween()
#	tween.tween_property(self, "modulate:a", 1, 0.1)
	tween.tween_property(self, "rotation", final_rotation, 1.5).set_ease(Tween.EASE_IN)
	tween.parallel()
	tween.tween_property(self, "modulate:a", 0, 0.5).set_delay(1.0)
	tween.parallel()
	tween.tween_property(self, "scale", Vector2.ONE * 1.3, 1.1)
	tween.tween_callback(queue_free)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_collision_detector_area_entered(area: Area2D) -> void:
	var node = area.get_parent()
	var spirit_color = node.spirit_color
	var tween = create_tween()
	tween.tween_property(self, "modulate:r", spirit_color.r, 0.3)
	tween.parallel()
	tween.tween_property(self, "modulate:g", spirit_color.g, 0.3)
	tween.parallel()
	tween.tween_property(self, "modulate:b", spirit_color.b, 0.3)
	tween.tween_callback(func(): MessageBus.thurible_smoke_changed.emit(spirit_color))
	pass # Replace with function body.
