extends Node

# test code
@export var timer_label:Label
var time_elapsed = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_elapsed += delta
	timer_label.text = str(floor(time_elapsed))
	pass
	
func toggle_ritual_pause():
	get_tree().paused = !get_tree().paused
