extends Area2D

@onready var direction: bool = $"../..".is_downward
@onready var length: int = $"../..".length
@onready var is_up: bool = not direction
@onready var lift_speed: int = $"../..".lift_speed
@onready var drop_speed: int = $"../..".drop_speed
var tween



func elevator_down():
	if tween:
		tween.kill()
		tween = false
	tween = $"..".create_tween()
	if direction:
		tween.tween_property($"..", "position", Vector2(0, 16*length-6), ((Vector2(0, 16*length-6)-$"..".position)/drop_speed).y)
	else:
		tween.tween_property($"..", "position", Vector2(0, 0), ($"..".position/drop_speed).y)


func elevator_up():
	if tween:
		tween.kill()
		tween = false
	tween = $"..".create_tween()
	if direction:
		tween.tween_property($"..", "position", Vector2(0, 0), ($"..".position/lift_speed).y)
	else:
		tween.tween_property($"..", "position", Vector2(0, -16*length), ((Vector2(0, -16*length)-$"..".position)/lift_speed).y)
		
		
func _on_body_entered(body):
	if body is Player:
		body.is_on_elevator = $"."


func _on_body_exited(body):
	if body is Player:
		body.is_on_elevator = null
