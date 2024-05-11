extends Area2D




func _on_body_entered(body):
	if body is Player and not $"..".dead:
		$"..".death()
		body.force_jump("enemy_defeated")
