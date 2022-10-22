extends BaseState

@export var state_name:String
@export var pin_prefab:PackedScene
@export var pin_color:Color
var pin_instances:Array = []
var triangle_manager: TriangleManager = null

func _ready() -> void:
	super()
	self.tool_name = "pins"
	# it feels a bit odd to directly subscribe to a signal inside of a state-machine state.
	# but I think it makes some sense in this case because we want to handle this event no matter what
	MessageBus.pin_removed.connect(_remove_pin)

func handle_input(event:InputEvent):
	if event is InputEventMouseButton:
		if event.is_pressed() && event.button_index == 1:
			if pin_instances.size() < 3:
				var new_pin = pin_prefab.instantiate() as Node2D
				new_pin.position = (event as InputEventMouseButton).position
				new_pin.modulate = pin_color
				get_tree().current_scene.add_child(new_pin)
				pin_instances.append(new_pin)
				
				var all_pins_placed = pin_instances.size() == 3
				var all_pins_active = pin_instances.all(func(pin): return !pin.is_exhausted)
				if all_pins_placed and all_pins_active:
					# form triangle
					triangle_manager = TriangleManager.new(pin_instances)
					triangle_manager.z_index = -1
					get_tree().current_scene.add_child(triangle_manager)
					# lock pins in place
					for pin in pin_instances:
						pin.is_set_complete = true

func _remove_pin(pin):
	if triangle_manager != null && pin in pin_instances:
		# if we removed a pin while exposing ghosts it dispells triangle
		triangle_manager.queue_free()
		triangle_manager = null
		for pin_instance in pin_instances:
			pin_instance.is_set_complete = false
			pin_instance.is_exhausted = true
		MessageBus.triangle_dispelled_early.emit()
	pin_instances = pin_instances.filter(func(p): return p != pin)
