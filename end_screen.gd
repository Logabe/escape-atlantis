extends Control


func back():
	print("Aaaback")
	get_tree().change_scene_to_file("res://main.tscn")
