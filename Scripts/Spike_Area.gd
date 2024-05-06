extends Area2D

var spikes_color: bool = get_collision_layer_value(1) #First layer belogs to white checkpoint

func _on_body_entered(body):
	if body is Player: #Class check
		if spikes_color:
			body.spike([$"..".global_position, true])
		else:
			body.spike([$"..".global_position, false])
