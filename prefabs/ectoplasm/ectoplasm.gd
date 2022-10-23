extends Node2D

var was_in_triangle: bool = false


func _ready():
	MessageBus.ectoplasm_manually_removed.connect(_on_ectoplasm_manually_removed)
	scale.x = 0
	scale.y = 0
	if get_is_in_triangle():
		# immediately spawned inside triangle (just don't spawn I guess)
		queue_free()
	else:
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(1, 1), 0.8).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		await tween.finished
		MessageBus.ectoplasm_spawned.emit()

func _process(delta):
	if !was_in_triangle && get_is_in_triangle():
		was_in_triangle = true
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(0, 0), 0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN)
		await tween.finished
		queue_free()

func get_is_in_triangle():
	var pin_groups = get_tree().get_nodes_in_group("triangles")
	var is_in_a_triangle = pin_groups.any(func(group): return group.is_active && Geometry2D.is_point_in_polygon(position, group.vector_points))
	return is_in_a_triangle

func _on_click_blocker_gui_input(event):
	if event is InputEventMouseButton && (event as InputEventMouseButton).button_index == 1 && event.is_pressed():
		MessageBus.ectoplasm_clicked.emit(self)
		
func _on_ectoplasm_manually_removed(ectoplasm):
	if ectoplasm == self:
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(0, 0), 0.3).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN)
		await tween.finished
		queue_free()
