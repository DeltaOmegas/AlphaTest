extends Node2D

@export_node_path("Node2D") var elevator_path
@export var _global_scale = 5
@onready var elevator = get_node(elevator_path).get_child(0)


func _process(_delta):
	var length = ((elevator.global_position.y - global_position.y)/_global_scale)-16
	$Sprite2D.region_rect = Rect2(0, 0, 16, length)
