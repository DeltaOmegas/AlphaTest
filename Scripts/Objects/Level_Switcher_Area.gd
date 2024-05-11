extends Area2D

@onready var mode: int = $"..".mode

func _on_body_entered(body):
	if body is Player:
		if mode == 0:
			get_tree().change_scene_to_file("res://Levels/Level_1/level_1.tscn")
		else:
			get_tree().change_scene_to_file("res://Levels/Level_2/level_2.tscn")
