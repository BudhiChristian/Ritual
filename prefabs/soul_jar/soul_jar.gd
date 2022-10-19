extends Node2D

var spirit_indicators: Array
var held_spirits: Array = []

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
		draw_arc(spirit_indicator.position, 100, 0, 360, 100, Color.PURPLE, 10)
	
func _mark_captured(spirit: Node) -> void:
	if held_spirits.is_empty() or held_spirits[0].spirit_color == spirit.spirit_color:
		spirit.is_jarred = true
		held_spirits.append(spirit)
		if held_spirits.size() < 3:
			# setup escape indicatore
			var spirit_indicator = spirit_indicators[held_spirits.size() - 1] as Node2D
			var escape_indicator = SoulJarEscape.new(spirit_indicator.global_position, spirit)
			get_tree().current_scene.add_child(escape_indicator)
		
	# we could add some process instead of automatically doing this
	if held_spirits.size() >= 3:
		MessageBus.exorcise_spirits_in_jar.emit(held_spirits)
		held_spirits = []

func _spirit_escape(spirit: Node) -> void:
	held_spirits = held_spirits.filter(func(held): return held != spirit)

func _on_click_handler_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
		MessageBus.soul_jar_clicked.emit()
