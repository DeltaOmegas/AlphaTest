extends Area2D

var checkpoint_color: bool = get_collision_layer_value(1)

func _on_body_entered(body):
	if body is Player:
		if checkpoint_color: 
			body.Checkpoint([$"..".global_position + Vector2(24*5, -30*5), true]) 
		else:
			body.Checkpoint([$"..".global_position + Vector2(24*5, -30*5), false])
		$"../Checkpoint_Animation".stop()
		$"../Checkpoint_Animation".play("Reached")
		

func _ready():
		$"../Checkpoint_Animation".play("Idle")
