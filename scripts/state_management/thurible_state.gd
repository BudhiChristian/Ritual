extends BaseState

@export var smoke_prefab:PackedScene

func _ready() -> void:
	super()
	self.tool_name = "thurible"

func handle_input(event:InputEvent):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == 1:
			var new_smoke = smoke_prefab.instantiate()
			new_smoke.position = event.position
			get_tree().current_scene.add_child(new_smoke)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
