extends Area2D



func _on_body_entered(body):
	if body is Player:# and not $"..".dead:
		body.respawn() #replace with damage
