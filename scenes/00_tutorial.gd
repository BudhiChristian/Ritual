extends BaseLevelScript

# Called when the node enters the scene tree for the first time.
func _ready():
	self.start()
	# for other levels we can spawn more spirits after a certain time or event
	MessageBus.spawn_spirit_trio.emit(Color8(172, 91, 53))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# override level complete
func on_level_completed():
	pass
	
#override level failed
func on_level_failed():
	pass
