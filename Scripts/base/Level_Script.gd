extends Node2D

@export var COLOR: bool = false
var allow_flashlight: bool = true

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
		$Player.set_collision_layer_value(3, false)
		$Player.set_collision_layer_value(4, true)
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
		$Player.set_collision_layer_value(3, true)
		$Player.set_collision_layer_value(4, false)
		
	for node in get_children():
		if not node.name.ends_with('IgnorePause'):
			node.process_mode = 1

func _process(_delta):
	var is_anything_playing: bool = $Highlights.is_playing() or $Colors.is_playing()
	
	if Input.is_action_just_pressed('pause'):
		if get_tree().paused == true:
			get_tree().paused = false
		else:
			get_tree().paused = true
			
	if Input.is_action_just_pressed("switch_color") and not(is_anything_playing):
		switch_color()
		
	if Input.is_action_just_pressed("highlight") and not(is_anything_playing) and allow_flashlight:
		$Flashlight_timer.start()
		allow_flashlight = false
		if COLOR:
			$Highlights.play("Blackhole")
		else:
			$Highlights.play("Flashlight")
			
	if not allow_flashlight:
		$Ui.update_timer(str(round($Flashlight_timer.get_time_left())))
	else:
		$Ui.update_timer('Flashlight is availible')


func _on_flashlight_timer_timeout():
	allow_flashlight = true
