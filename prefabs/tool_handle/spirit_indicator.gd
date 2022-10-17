extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MessageBus.set_spirit_stored.connect(func(is_stored):
		visible = is_stored
	)
