extends Sprite2D

@export var TURNING_SPEED: int = 70

func turn_Black(delta):
	visible = true
	scale = Vector2(scale[0]*TURNING_SPEED*delta, scale[0]*TURNING_SPEED*delta)


func _ready():
	pass


func _process(_delta):
	position = %Main_Camera.get_screen_center_position() + Vector2(640, -360)
