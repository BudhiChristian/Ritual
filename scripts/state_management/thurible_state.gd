extends BaseState

@export var smoke_prefab:PackedScene

var last_mouse_position = null
var is_mouse_held = false

func _ready() -> void:
	super()
	self.tool_name = "thurible"

func handle_input(event:InputEvent):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == 1:
			make_smoke_at(event.position)
			is_mouse_held = true
		if !event.is_pressed() and event.button_index == 1:
			last_mouse_position = null
			is_mouse_held = false
	
	if event is InputEventMouseMotion and is_mouse_held:
		if last_mouse_position.distance_to(event.position) > 80:
			make_smoke_at(event.position)

func make_smoke_at(p):
	var new_smoke = smoke_prefab.instantiate()
	new_smoke.position = p
	last_mouse_position = p
	get_tree().current_scene.add_child(new_smoke)

func on_exit():
	is_mouse_held = false
	last_mouse_position = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
