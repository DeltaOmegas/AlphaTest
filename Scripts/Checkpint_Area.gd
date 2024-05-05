extends Area2D


func _on_body_entered(body):
	if body is Player:
		body.Checkpoint($CollisionShape2D.position)
		if get_collision_mask_value(3):
			print("White checkpoint")
		else:
			print("Black checkpoint")
