extends Node2D

@export var locked_texture:Texture
@export var unlocked_texture:Texture
@onready var lock_sprite: Sprite2D = %lock_sprite
@onready var chain_line: Line2D = %chain_line

var is_unlocked = false
var base_position = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("hello!")
	chain_line.set_point_position(0, base_position-position)
	var t = create_tween()
	t.tween_property(self, "scale", Vector2.ONE, 0.4).from(Vector2.ZERO)
	t.tween_callback(func():
		MessageBus.chains_created.emit()
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var was_unlocked = is_unlocked
	var pin_groups = get_tree().get_nodes_in_group("triangles")
	is_unlocked = pin_groups.any(func(group): return group.is_active && Geometry2D.is_point_in_polygon(position, group.vector_points))
	lock_sprite.texture = unlocked_texture if is_unlocked else locked_texture
	if !was_unlocked and is_unlocked:
		pass # TODO: emit a "chain unlocked" signal here?
