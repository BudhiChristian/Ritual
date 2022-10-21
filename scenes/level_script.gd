extends Node
class_name BaseLevelScript

func start():
	MessageBus.level_completed.connect(on_level_completed)
	MessageBus.level_failed.connect(on_level_failed)
	
func on_level_completed():
	print("complete!")
	
func on_level_failed():
	print("failed")
