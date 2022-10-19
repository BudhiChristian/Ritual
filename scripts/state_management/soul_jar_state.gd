extends Node

var held_souls: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	MessageBus.put_spirit_in_jar.connect(_mark_captured)
	MessageBus.spirit_escapes_jar.connect(_spirit_escape)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_node("spirit_count").text = str(held_souls.size())
	
func _mark_captured(spirit: Node) -> void:
	if held_souls.size() == 0 || held_souls[0].spirit_color == spirit.spirit_color:
		held_souls.append(spirit)
	# we could add some process instead of automatically doing this
	if held_souls.size() == 3:
		MessageBus.exorcise_spirits_in_jar.emit(held_souls)
		held_souls = []

func _spirit_escape(spirit: Node) -> void:
	held_souls = held_souls.filter(func(held): return held != spirit)	
