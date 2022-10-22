extends Node2D

@export var health: float = 1000
@export var spirit_damage_per_second: float = 1
@export var spirit_exorcise_heal_amount: float = 100
@export var dispell_triangle_damage: float = 50

var health_bar: Node2D
var current_health: float = 100
var spirits_in_body: int = 0
var total_spirits: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	MessageBus.exorcise_spirits_in_jar.connect(_on_exorcise_spirits_in_jar)
	MessageBus.put_spirit_in_jar.connect(_on_put_spirit_in_jar)
	MessageBus.spirit_escapes_jar.connect(_on_spirit_escapes_jar)
	MessageBus.triangle_dispelled_early.connect(_on_triangle_dispelled_early)
	MessageBus.spawn_spirit_trio.connect(_on_spawn_spirit_trio)
	
	health_bar = get_node("health_bar/fill")
	current_health = health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var damage = spirits_in_body * spirit_damage_per_second * delta
	current_health = max(0, current_health - damage)
	if current_health == 0:
		MessageBus.host_is_possessed.emit()
	
	health_bar.modulate = Color8(152, 49, 47) if total_spirits > 0 else Color8(49, 104, 47)
	health_bar.material.set_shader_parameter("health", current_health / health)

func _on_spawn_spirit_trio(color, spirit_types):
	spirits_in_body += 3
	total_spirits += 3

func _on_exorcise_spirits_in_jar(spirits: Array):
	total_spirits -= spirits.size()
	current_health = min(health, current_health + spirit_exorcise_heal_amount)
	if total_spirits < 1:
		MessageBus.host_completely_exorcised.emit()
	
func _on_put_spirit_in_jar(spirit):
	spirits_in_body -= 1
	
func _on_spirit_escapes_jar(spirit):
	spirits_in_body += 1

func _on_triangle_dispelled_early():
	current_health = max(0, current_health - dispell_triangle_damage)
