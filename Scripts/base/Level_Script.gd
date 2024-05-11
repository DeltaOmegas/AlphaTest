extends Node2D

@export var COLOR: bool = false
var allow_flashlight: bool = true
var allow_switch_color: bool

func switch_color():
		COLOR = not(COLOR)
		if COLOR:
			$Player.set_stuck_detectors(2)
			$Colors.play("to_White")
		else:
			$Player.set_stuck_detectors(1)
			$Colors.play("to_Black")


func get_current_color():
	return COLOR


func _ready():
	allow_switch_color = not $".".get_meta('is_1984_level')
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
		$Player.set_stuck_detectors(2)
		
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
		$Player.set_stuck_detectors(1)

		
	for node in get_children():
		if node == %Ui:
			node.set_process_mode(PROCESS_MODE_ALWAYS)
		else:
			node.set_process_mode(PROCESS_MODE_PAUSABLE)

func _process(_delta):
	var is_anything_playing: bool = $Highlights.is_playing() or $Colors.is_playing()
	
	if Input.is_action_just_pressed('pause'):
		if get_tree().paused:
			get_tree().paused = false
			%Ui.set_pause(false)
		else:
			get_tree().paused = true
			%Ui.set_pause(true)
			
	if Input.is_action_just_pressed("switch_color") and not(is_anything_playing) and allow_switch_color:
		switch_color()
		
	if Input.is_action_just_pressed("highlight") and not(is_anything_playing) and allow_flashlight:
		%Ui.start_timer()
		if COLOR:
			$Highlights.play("Blackhole")
		else:
			$Highlights.play("Flashlight")


func _on_flashlight_timer_timeout():
	allow_flashlight = true
