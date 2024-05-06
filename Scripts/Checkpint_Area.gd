extends Area2D


func _on_body_entered(body):
	if body is Player:
		body.Checkpoint(position+Vector2(0, -1000))
		$"../Checkpoint_Animation".stop()
		$"../Checkpoint_Animation".play("Reached")
		

func _ready():
		$"../Checkpoint_Animation".play("Idle")
