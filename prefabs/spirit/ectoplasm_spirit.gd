extends BaseSpirit

var ectoplasm_prefab: PackedScene = preload("res://prefabs/ectoplasm/ectoplasm.tscn")
var ectoplasm_to_spawn: int = 0

func _ready():
	spawns_ectoplasm = true
	#MessageBus.spirit_clicked.connect(on_spirit_clicked)

func spawn_ectoplasm():
	for i in ectoplasm_to_spawn:
		_spawn_single_ectoplasm()
		
func _spawn_single_ectoplasm():
	var ectoplasm = ectoplasm_prefab.instantiate() as Node2D
	ectoplasm.modulate = Color(spirit_color, 0.9)
	ectoplasm.rotation = randf() * 2 * PI
	# Get random point within a radius of spirit
	var random_angle = randf() * 2 * PI
	var random_distance = 50 + (50 * sqrt(randf())) # add 50 so it's less likely to spawn inside of triangle 
	var x = random_distance * cos(random_angle)
	var y = random_distance * sin(random_angle)
	ectoplasm.position = Vector2(position.x + x, position.y + y)
	get_tree().current_scene.add_child(ectoplasm)
