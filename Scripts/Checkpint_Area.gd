extends Area2D


func _on_body_entered(body):
	if body is Player:
		body.Checkpoint($"..".global_position + Vector2(24*5, -24*5))
		$"../Checkpoint_Animation".stop()
		$"../Checkpoint_Animation".play("Reached")
		

func _ready():
		$"../Checkpoint_Animation".play("Idle")
