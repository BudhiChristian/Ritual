extends Node2D

@export var health: float = 100
@export var aliments: Array = []

var health_bar: Node2D
var current_health: float
var spirits_in_body: int = 0
var total_spirits: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	MessageBus.exorcise_spirits_in_jar.connect(_on_exorcise_spirits_in_jar)
	MessageBus.put_spirit_in_jar.connect(_on_put_spirit_in_jar)
	MessageBus.spirit_escapes_jar.connect(_on_spirit_escapes_jar)
	
	health_bar = get_node("health_bar")
	current_health = health
	
	# spawn ailments
	for aliment in aliments:
		MessageBus.spawn_spirit_trio.emit(aliment)
	spirits_in_body = aliments.size() * 3
	total_spirits = spirits_in_body

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_exorcise_spirits_in_jar(spirits: Array):
	total_spirits -= spirits.size()
	
func _on_put_spirit_in_jar(spirit):
	spirits_in_body -= 1
	
func _on_spirit_escapes_jar(spirit):
	spirits_in_body += 1
