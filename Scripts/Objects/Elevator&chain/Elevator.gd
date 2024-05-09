extends Node2D


@export var is_downward: bool = true
@export_range(1, 30) var length: int = 1
@export_range(1, 300) var lift_speed: int = 100
@export_range(1, 300) var drop_speed: int = 150
