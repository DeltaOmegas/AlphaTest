extends Node2D

@export var COLOR: bool = false


func switch_color():
		COLOR = not(COLOR)
		if COLOR:
			$Colors.play("to_White")
		else:
			$Colors.play("to_Black")

func get_current_color():
	return COLOR


func _ready():
	COLOR = bool(COLOR)
	if COLOR:
		$White.modulate[3] = 0
		$White.z_index = 3
		$Black.modulate[3] = 1
		$Black.z_index = 4
		%White_BG.scale = Vector2(1.7, 1.7)
		%White_BG.visible = true
		%Black_BG.scale = Vector2(0.01, 0.01)
		%Black_BG.visible = false
		$Player.set_collision_mask_value(1, false)
		$Player.set_collision_mask_value(2, true)
	else:
		$White.modulate[3] = 1
		$White.z_index = 4
		$Black.modulate[3] = 0
		$Black.z_index = 3
		%White_BG.scale = Vector2(0.01, 0.01)
		%White_BG.visible = false
		%Black_BG.scale = Vector2(1.7, 1.7)
		%Black_BG.visible = true
		$Player.set_collision_mask_value(1, true)
		$Player.set_collision_mask_value(2, false)

func _process(_delta):
	#var is_switching: bool = $Colors.is_playing()
	#var is_highlighting: bool = $Highlights.is_playing()
	var is_anything_playing: bool = $Highlights.is_playing() or $Colors.is_playing()
	
	if Input.is_action_just_pressed("switch_color") and not(is_anything_playing):
		switch_color()
	if Input.is_action_just_pressed("highlight") and not(is_anything_playing):
		if COLOR:
			$Highlights.play("Blackhole")
		else:
			$Highlights.play("Flashlight")
