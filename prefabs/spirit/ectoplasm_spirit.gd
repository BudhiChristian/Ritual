extends BaseSpirit

var ectoplasm_prefab: PackedScene = preload("res://prefabs/ectoplasm/ectoplasm.tscn")
var ectoplasm_to_spawn: int = 0

func _ready():
	MessageBus.spirit_clicked.connect(on_spirit_clicked)

func on_spirit_clicked(spirit):
	if spirit == self:
		for i in ectoplasm_to_spawn:
			spawn_ectoplasm()
		
func spawn_ectoplasm():
	var ectoplasm = ectoplasm_prefab.instantiate() as Node2D
	ectoplasm.modulate = Color(spirit_color, 0.9)
	ectoplasm.rotation = randf() * 2 * PI
	var random_angle = randf() * 2 * PI
	var random_distance = 30 + (50 * sqrt(randf())) 
	var x = random_distance * cos(random_angle)
	var y = random_distance * sin(random_angle)
	ectoplasm.position = Vector2(position.x + x, position.y + y)
	get_tree().current_scene.add_child(ectoplasm)
