extends Area2D

var checkpoint_color: bool = get_collision_layer_value(1) #First layer belogs to white checkpoint

func _on_body_entered(body):
	if body is Player: #Class check
		if checkpoint_color:
			body.checkpoint([$"..".global_position + Vector2(24*5, -30*5), true]) 
		else:
			body.checkpoint([$"..".global_position + Vector2(24*5, -30*5), false])
		$"../Checkpoint_Animation".stop()
		$"../Checkpoint_Animation".play("Reached") # Hide core
		

func _ready():
		$"../Checkpoint_Animation".play("Idle") #Flying checkpoint core
