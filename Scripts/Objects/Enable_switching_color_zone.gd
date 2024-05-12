extends Area2D




func _on_body_entered(body):
	if body is Player:
		$"..".allow_switch_color[0] = true


func _on_body_exited(body):
	if body is Player:
		$"..".allow_switch_color[0] = false
