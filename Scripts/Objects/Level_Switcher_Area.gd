extends Area2D

@onready var path: String = $"..".switch_to

func _on_body_entered(body):
	if body is Player:
			get_tree().change_scene_to_file(path)
