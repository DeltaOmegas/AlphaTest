extends Area2D


func _on_body_entered(body):
	if body is Player: #Class check
			body.force_jump("spike")
