extends Node

var spirit_instances: Array = []
var spirit_prefabs: Dictionary = {
	"normal": preload("res://prefabs/spirit/spirit.tscn"),
	"ectoplasm": preload("res://prefabs/spirit/ectoplasm_spirit.tscn"),
	"chains": preload("res://prefabs/spirit/chains_spirit.tscn"),
}

# triangles that spritis can spawn
var spawn_areas: Array = []
# accumulated average in ascending order (last is the the complete total areas)
var spawn_weights: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect listeners
	MessageBus.exorcise_spirits_in_jar.connect(_release_spirits)
	MessageBus.spawn_spirit_trio.connect(_spawn_spirit_trio)
	
	# Calculate spawn areas
	# extract polygon of spawn area and split into triangles
	var spawn_area_polygon = self.polygon
	var triangles = Geometry2D.triangulate_polygon(spawn_area_polygon)
	# instantiate accumulated spawn weights
	spawn_weights.resize(triangles.size()/3)
	spawn_weights[-1] = 0
	# for each group of three
	for i in range(triangles.size()/3):
		# place on global coordinates
		var a = self.to_global(spawn_area_polygon[triangles[3 * i]])
		var b = self.to_global(spawn_area_polygon[triangles[3 * i + 1]])
		var c = self.to_global(spawn_area_polygon[triangles[3 * i + 2]])
		# accumulate spawn weights and append to spawn areas list
		spawn_weights[i] = spawn_weights[i - 1] + _triangle_area(a, b, c)
		spawn_areas.append([a, b, c])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _spawn_spirit_trio(color: Color, spirit_types: Array) -> void:
	for spirit_type in spirit_types:
		_spawn_spirit(color, spirit_type, _get_random_position())

func _spawn_spirit(color: Color, spirit_type: String, position: Vector2) -> void:
	# for other configurations, let's separate them by underscore
	var spirit_type_parts = spirit_type.split("_")
	var spirit_prefab = spirit_prefabs.get(spirit_type_parts[0])
	var new_spirit = spirit_prefab.instantiate() as Node2D
	new_spirit.position = position
	new_spirit.spirit_color = color
	new_spirit.visible = false
	
	# custom args for different types
	if spirit_type_parts[0] == "ectoplasm":
		new_spirit.ectoplasm_to_spawn = spirit_type_parts[1].to_int()
	
	get_tree().current_scene.add_child(new_spirit)
	spirit_instances.append(new_spirit)
	return new_spirit
	
func _release_spirits(spirits: Array) -> void:
	spirit_instances = spirit_instances.filter(func(p): return p not in spirits)
	for spirit in spirits:
		spirit.queue_free()
	
func _get_random_position() -> Vector2:
	# pick a random number and find the closest weight
	var random_number = spawn_weights[-1] * randf()
	var spawn_index = spawn_weights.bsearch(random_number)
	# fetch triangle corresponding with weight
	var spawn = spawn_areas[spawn_index]
	# get a random point in the triangle
	return _random_triangle_point(spawn[0], spawn[1], spawn[2])
	
# found these on the internet
func _triangle_area(a: Vector2, b: Vector2, c: Vector2) -> float:
	return 0.5 * abs((c.x - a.x) * (b.y - a.y) - (b.x - a.x) * (c.y - a.y))

func _random_triangle_point(a: Vector2, b: Vector2, c: Vector2) -> Vector2:
	return a + sqrt(randf()) * (-a + b + randf() * (c - b))
