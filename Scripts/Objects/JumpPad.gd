extends Node2D


func _on_body_entered(body):
	body.force_jump("JumpPad")
	$"../../AnimationPlayer".play("JumpPad")
