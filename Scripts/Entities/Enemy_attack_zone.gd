extends Area2D



func _on_body_entered(body):
	if body is Player:# and not $"..".dead:
		body.damage_by(2)
		if $".".name.ends_with('Right'):
			body.force_jump('enemy hit x+')
		else:
			body.force_jump('enemy hit x-')
		
