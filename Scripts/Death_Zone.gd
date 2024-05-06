extends Area2D

var curent_color: bool = true


func _on_body_entered(body):
	if body is Player:
		if $"..".get_current_color() != body.get_last_checkpoint_color():
			body.death()
		else:
			$"..".switch_color()
			#timer is required here
			body.death()
