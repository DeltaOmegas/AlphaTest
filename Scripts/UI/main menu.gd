extends Control




func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Levels/Level_1/level_1.tscn")

func _on_tutorial_button_pressed():
	get_tree().change_scene_to_file("res://Levels/Tutorial_level/tutorial_level.tscn")
