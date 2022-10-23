extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	scale.x = 0
	scale.y = 0
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.8).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
