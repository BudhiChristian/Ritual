extends Node

@export var spirit_prefab:PackedScene

var spirit_instances:Array = []

# we could make these fit within the target depending on what the object is

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# TODO just an example... we would want to call spawn_spirit_trio from some
	# level logic
	if len(spirit_instances) < 1:
		spawn_spirit_trio(Color.PURPLE, Color.PLUM)
	
func spawn_spirit_trio(color: Color, found_color: Color) -> void:
	for i in 3:
		# TODO: Some logic for making these not spawn so close to each other
		spawn_spirit(color, found_color, _get_random_position())

func spawn_spirit(color: Color, found_color: Color, position: Vector2) -> void:
	var new_spirit = spirit_prefab.instantiate() as Node2D
	new_spirit.position = position
	new_spirit.spirit_color = color
	new_spirit.spirit_color_found = found_color
	get_tree().current_scene.add_child(new_spirit)
	spirit_instances.append(new_spirit)
	return new_spirit
	
func _get_random_position() -> Vector2:
	# TODO: make play area fit to host
	var play_area_size = get_viewport().get_visible_rect().size
	# TODO: make these not "magic numbers"
	# play area start is (180, 0) adding 50 to allow room for needle
	var random_x = randf_range(230, play_area_size.x-50)
	var random_y = randf_range(50, play_area_size.y-50)
	return Vector2(random_x, random_y)
