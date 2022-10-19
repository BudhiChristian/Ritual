extends Node

var held_spirits: Array = []
var jar_color: Color = Color.GRAY

# Called when the node enters the scene tree for the first time.
func _ready():
	MessageBus.put_spirit_in_jar.connect(_mark_captured)
	MessageBus.spirit_escapes_jar.connect(_spirit_escape)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_parent().modulate = Color.GRAY if held_spirits.is_empty() else jar_color
	get_node("spirit_indicator_1").visible = held_spirits.size() > 0
	get_node("spirit_indicator_2").visible = held_spirits.size() > 1
	
func _mark_captured(spirit: Node) -> void:
	if held_spirits.is_empty() or jar_color == spirit.spirit_color:
		jar_color = spirit.spirit_color
		spirit.is_jarred = true
		held_spirits.append(spirit)
	# we could add some process instead of automatically doing this
	if held_spirits.size() >= 3:
		MessageBus.exorcise_spirits_in_jar.emit(held_spirits)
		held_spirits = []

func _spirit_escape(spirit: Node) -> void:
	held_spirits = held_spirits.filter(func(held): return held != spirit)
