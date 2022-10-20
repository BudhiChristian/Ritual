extends Node2D

@export var host_sprite: Sprite2D
@export var health: float = 100

var health_bar: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	health_bar = get_node("health_bar")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
