extends Area2D

@onready var is_to_bottom = $"../..".is_to_bottom
@onready var is_up: bool = is_to_bottom

func elevator_down():
	if not($"../Elevator_Animation".is_playing()):
		if is_up and is_to_bottom:
			$"../Elevator_Animation".play("Fall_from_neutral")
			is_up = false
		elif is_up and not is_to_bottom:
			$"../Elevator_Animation".play("Fall_from_top")
			is_up = false
		

func elevator_up():
	if not($"../Elevator_Animation".is_playing()):
		if not is_up and is_to_bottom:
			$"../Elevator_Animation".play("Lift_from_bottom")
			is_up = true
		elif not is_up and not is_to_bottom:
			$"../Elevator_Animation".play("Lift_from_neutral")
			is_up = true

func _ready():
	$"..".position = Vector2(0,0)

func _on_body_entered(body):
	if body is Player:
		body.is_on_elevator = $"."


func _on_body_exited(body):
	if body is Player:
		body.is_on_elevator = null
