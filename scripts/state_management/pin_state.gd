extends BaseState

@export var state_name:String
@export var pin_prefab:PackedScene
@export var pin_color:Color
var pin_instances:Array = []

func _ready() -> void:
	# it feels a bit odd to directly subscribe to a signal inside of a state-machine state.
	# but I think it makes some sense in this case because we want to handle this event no matter what
	MessageBus.pin_removed.connect(_remove_pin)

func handle_input(event:InputEvent):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if pin_instances.size() < 3:
				var new_pin = pin_prefab.instantiate() as Node2D
				new_pin.position = (event as InputEventMouseButton).position
				new_pin.modulate = pin_color
				get_tree().current_scene.add_child(new_pin)
				pin_instances.append(new_pin)
				
				var all_pins_placed = pin_instances.size() == 3
				var all_pins_active = pin_instances.all(func(pin): return !pin.is_exhausted)
				if all_pins_placed and all_pins_active:
					var triangle_manager = TriangleManager.new(pin_instances)
					triangle_manager.z_index = -10
					get_tree().current_scene.add_child(triangle_manager)

func _remove_pin(pin):
	pin_instances = pin_instances.filter(func(p): return p != pin)
