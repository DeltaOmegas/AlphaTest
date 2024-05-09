extends Node2D


@export_range(1, 30) var length: int = 1
@onready var collision_array: PackedVector2Array = $Spike/CollisionPolygon2D.get_polygon()
@onready var attack_collision_aray: PackedVector2Array = $Spike/Spike_Area/CollisionPolygon2D.get_polygon()
var extended_collision: PackedVector2Array

func add(array: PackedVector2Array, depth: int):
	if depth:
		for i in range(array.size()):
			array[i] += Vector2(16,0)
		extended_collision += array
		return add(array, depth-1)
	

func _ready():
	add(collision_array.slice(1), length-1)
	extended_collision[-1].y = 0
	collision_array += extended_collision
	$Spike/CollisionPolygon2D.set_polygon(collision_array)
	extended_collision.clear()
	add(attack_collision_aray.slice(1), length-1)
	extended_collision[-1].y = 0
	attack_collision_aray += extended_collision
	$Spike/Spike_Area/CollisionPolygon2D.set_polygon(attack_collision_aray)
	$Spike/Texture.region_rect = Rect2(0, 0, 16*length, 16)
	
	
