extends Node

@export var spirit_indicators:Array

var held_souls: Array = []
var jar_color: Color = Color.GRAY

# Called when the node enters the scene tree for the first time.
func _ready():
	spirit_indicators = get_children()
	MessageBus.put_spirit_in_jar.connect(_mark_captured)
	MessageBus.spirit_escapes_jar.connect(_spirit_escape)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	spirit_indicators[0].visible = held_souls.size() > 0
	spirit_indicators[1].visible = held_souls.size() > 1
	get_parent().modulate = Color.GRAY if held_souls.is_empty() else jar_color
	
func _mark_captured(spirit: Node) -> void:
	if held_souls.is_empty() or jar_color == spirit.spirit_color:
		jar_color = spirit.spirit_color
		held_souls.append(spirit)
	# we could add some process instead of automatically doing this
	if held_souls.size() >= 3:
		MessageBus.exorcise_spirits_in_jar.emit(held_souls)
		held_souls = []

func _spirit_escape(spirit: Node) -> void:
	held_souls = held_souls.filter(func(held): return held != spirit)
