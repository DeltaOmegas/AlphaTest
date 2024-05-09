extends Node2D


@export_range(1, 30) var length: int = 1
@export_range(1, 100) var speed: int = 25

var tween


func _ready():
	$Middle_Part.region_rect = Rect2(0, 0, 16*length, 16)
	$End_Part.position.x = 16*(length+1)+8
	tween = $AnimatableBody2D.create_tween()
	tween.tween_property($AnimatableBody2D, "position", Vector2((length+1)*16, 0), ((length+1)*16)/speed)
	tween.tween_property($AnimatableBody2D, "position", Vector2(0, 0), ((length+1)*16)/speed)
	tween.set_loops()
	
