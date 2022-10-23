extends BaseSpirit

@export var chain_prefab:PackedScene
# I feel like this isn't really the cleanest way to do it but for now it is the fastest
var revealed_time_remaining = 0
var locks = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if revealed_time_remaining > 0:
		revealed_time_remaining -= delta
		
	for lock in locks:
		if get_is_capturable():
			lock.modulate = Color.YELLOW_GREEN
		elif lock.is_unlocked:
			lock.modulate = Color.YELLOW
		else:
			lock.modulate = Color.WHITE
			
	
	super(delta)

func get_is_exposed():
	return revealed_time_remaining > 0
	
func get_is_capturable():
	return locks.all(func(l): return l.is_unlocked)
	
func on_expose():
	MessageBus.spirit_revealed.emit(spirit_color)
	for i in range(2):
		print("adding chain")
		var new_chain = chain_prefab.instantiate()
		print(position)
		var p = position + (Vector2.RIGHT * 180).rotated(randf_range(0, PI*2))
		# I had to hardcode this due to time constraints. Sorry :(
		p.x = clamp(p.x, 250, 970)
		p.y = clamp(p.y, 80, 600)
		new_chain.position = p
		new_chain.base_position = position
		get_tree().current_scene.add_child(new_chain)
		locks.append(new_chain)
	
func on_hide():
	for lock in locks:
		lock.queue_free()
	locks = []
	
func on_capture():
	for lock in locks:
		lock.queue_free()
	locks = []

func _on_thurible_collider_area_entered(area: Area2D) -> void:
	if revealed_time_remaining <= 0:
		revealed_time_remaining = 25 # 25 seconds
