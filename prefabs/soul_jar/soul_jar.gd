extends Node2D

var spirit_indicators: Array
var held_spirits: Array = []
var spirit_statuses: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	spirit_indicators = get_node("indicator_holder").get_children()
	MessageBus.put_spirit_in_jar.connect(_mark_captured)
	MessageBus.spirit_escapes_jar.connect(_spirit_escape)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in range(spirit_indicators.size()):
		var spirit_indicator = spirit_indicators[i]
		var spirit = held_spirits[i] if held_spirits.size() > i else null
		spirit_indicator.visible = spirit != null
		spirit_indicator.modulate = Color.GRAY if spirit == null else spirit.spirit_color
	
func _mark_captured(spirit: Node) -> void:
	if held_spirits.is_empty() or held_spirits[0].spirit_color == spirit.spirit_color:
		spirit.is_jarred = true
		held_spirits.append(spirit)
		if held_spirits.size() < 3:
			# setup escape indicatore
			var spirit_indicator = spirit_indicators[held_spirits.size() - 1] as Node2D
			spirit_indicator.rotation = -0.1 * PI
			var tween = create_tween()
			tween.tween_property(spirit_indicator, "rotation",0, 1).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
			var escape_indicator = SoulJarEscape.new(spirit_indicator.global_position, spirit)
			spirit_statuses.append(escape_indicator)
			get_tree().current_scene.add_child(escape_indicator)
		
	# we could add some process instead of automatically doing this
	if held_spirits.size() >= 3:
		MessageBus.exorcise_spirits_in_jar.emit(held_spirits)
		held_spirits = []
		spirit_statuses = []

func _spirit_escape(spirit: Node) -> void:
	held_spirits = held_spirits.filter(func(held): return held != spirit)
	spirit_statuses = spirit_statuses.filter(func(status): return status.spirit != spirit)
	for i in range(spirit_statuses.size()):
		spirit_statuses[i].center = spirit_indicators[i].global_position

func _on_click_handler_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
		MessageBus.soul_jar_clicked.emit()
		
func _on_click_handler_mouse_entered():
	var tween = create_tween()
	tween.tween_property(get_node("jar"), "rotation", 0.1 * PI, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)

func _on_click_handler_mouse_exited():
	var tween = create_tween()
	tween.tween_property(get_node("jar"), "rotation", 0, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
