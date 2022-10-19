extends Node

@export var spirit_prefab:PackedScene

var spirit_instances: Array = []

# triangles that spritis can spawn
var spawn_areas: Array = []
# accumulated average in ascending order (last is the the complete total areas)
var spawn_weights: Array = []

# we could make these fit within the target depending on what the object is

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect listeners
	MessageBus.exorcise_spirits_in_jar.connect(_release_spirits)
	
	# Calculate spawn areas
	# extract polygon of spawn area and split into triangles
	var spawn_area = (get_node("spawn_area") as Polygon2D)
	var spawn_area_polygon = spawn_area.polygon
	var triangles = Geometry2D.triangulate_polygon(spawn_area_polygon)
	# instantiate accumulated spawn weights
	spawn_weights.resize(triangles.size()/3)
	spawn_weights[-1] = 0
	# for each group of three
	for i in range(triangles.size()/3):
		# place on global coordinates
		var a = spawn_area.to_global(spawn_area_polygon[triangles[3 * i]])
		var b = spawn_area.to_global(spawn_area_polygon[triangles[3 * i + 1]])
		var c = spawn_area.to_global(spawn_area_polygon[triangles[3 * i + 2]])
		# accumulate spawn weights and append to spawn areas list
		spawn_weights[i] = spawn_weights[i - 1] + _triangle_area(a, b, c)
		spawn_areas.append([a, b, c])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# TODO just an example... we would want to call spawn_spirit_trio from some
	# level logic
	if len(spirit_instances) < 1:
		spawn_spirit_trio(Color.ORANGE_RED, Color.ORANGE)
	
func spawn_spirit_trio(color: Color, found_color: Color) -> void:
	for i in 3:
		_spawn_spirit(color, found_color, _get_random_position())

func _spawn_spirit(color: Color, found_color: Color, position: Vector2) -> void:
	var new_spirit = spirit_prefab.instantiate() as Node2D
	new_spirit.position = position
	new_spirit.spirit_color = color
	new_spirit.spirit_color_found = found_color
	new_spirit.visible = false
	get_tree().current_scene.add_child(new_spirit)
	spirit_instances.append(new_spirit)
	return new_spirit
	
func _release_spirits(spirits: Array) -> void:
	spirit_instances = spirit_instances.filter(func(p): return p not in spirits)
	
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
