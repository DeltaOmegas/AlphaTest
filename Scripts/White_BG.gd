extends Sprite2D

func _process(_delta):
	position = %Main_Camera.get_screen_center_position() + Vector2(640, -360)
