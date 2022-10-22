extends Control

func go_to_game():
	var tutorial: PackedScene = preload("res://scenes/00_tutorial.tscn")
	get_tree().change_scene_to_packed(tutorial)
