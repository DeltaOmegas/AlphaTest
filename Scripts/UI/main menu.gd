extends Control







func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://Levels/Tutorial_level/tutorial_level.tscn")


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Levels/Level_1/level_1.tscn")
