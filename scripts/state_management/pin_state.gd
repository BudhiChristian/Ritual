extends BaseState

@export var state_name:String
@export var pin_prefab:PackedScene
@export var pin_color:Color
var pin_instances:Array = []

func handle_input(event:InputEvent):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if pin_instances.size() < 3:
				var new_pin = pin_prefab.instantiate() as Node2D
				new_pin.position = (event as InputEventMouseButton).position
				new_pin.modulate = pin_color
				get_tree().current_scene.add_child(new_pin)
				pin_instances.append(new_pin)
				if pin_instances.size() == 3:
					var triangle_manager = TriangleManager.new(pin_instances)
					triangle_manager.z_index = -10
					get_tree().current_scene.add_child(triangle_manager)
