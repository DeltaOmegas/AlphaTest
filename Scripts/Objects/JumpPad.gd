extends Node2D
@onready var is_custom: bool = $"../..".custom_velosity
@onready var velosity: int = $"../..".velosity

func _on_body_entered(body):
	if is_custom:
		body.force_jump(velosity*-1)
		$"../../AnimationPlayer".play("JumpPad")
	else:
		body.force_jump("JumpPad")
		$"../../AnimationPlayer".play("JumpPad")
