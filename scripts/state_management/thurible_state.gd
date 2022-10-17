extends BaseState

@export var smoke_prefab:PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func handle_input(event:InputEvent):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == 1:
			var new_smoke = smoke_prefab.instantiate()
			new_smoke.position = event.position
			get_tree().current_scene.add_child(new_smoke)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
