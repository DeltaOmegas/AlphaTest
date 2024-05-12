extends Node2D

@export var COLOR: bool = false
var allow_flashlight: bool = true
var allow_switch_color: bool


var tween_black_bg
var tween_white_bg
var tween_black
var tween_white


func switch_color():
	if not COLOR:
		if tween_black_bg:
			print("IS BLACK: " + str(tween_black_bg.is_running()))
			if tween_black_bg.is_running():
				pass
			else:
				COLOR = not(COLOR)
				%Player.set_stuck_detectors(2)
				to_white(%Main_Camera.zoom.y, 0.75)
		else:
			%Player.set_stuck_detectors(2)
			to_white(%Main_Camera.zoom.y, 0.75)
	else:
		if tween_white_bg:
			print("IS WHITE: " + str(tween_white_bg.is_running()))
			if tween_white_bg.is_running():
				pass
			else:
				COLOR = not(COLOR)
				%Player.set_stuck_detectors(1)
				to_black(%Main_Camera.zoom.y, 0.75)
		else:
			%Player.set_stuck_detectors(1)
			to_black(%Main_Camera.zoom.y, 0.75)

func to_black(zoom: float, duration: float):
	zoom = 1/zoom
	
	tween_black_bg = %Black_BG.create_tween()
	tween_black_bg.finished.connect(_tween_black_bg_finished)
	%Black_BG.visible = true
	tween_black_bg.tween_property(%Black_BG, "scale", Vector2(1.75*zoom, 1.75*zoom), duration)
	%White.z_index = 4
	%Black.z_index = 3
	tween_black = %Black.create_tween()
	tween_black.tween_property(%Black, "modulate", Color("white", 0), duration)
	tween_white = %White.create_tween()
	tween_white.tween_property(%White, "modulate", Color("white", 1), duration)
	
	%Player.set_collision_layer_value(3, true)
	%Player.set_collision_layer_value(4, false)
	%Player.set_collision_mask_value(1, true)
	%Player.set_collision_mask_value(2, false)


func _tween_black_bg_finished(): #after black scaling
	RenderingServer.set_default_clear_color(Color.hex(0x0F0F1BFF))
	%White_BG.visible = false
	%White_BG.scale = Vector2(0.001, 0.001)
	%Black_BG.visible = false
	%Black_BG.scale = Vector2(0.001, 0.001)


func to_white(zoom: float, duration: float):
	zoom = 1/zoom
	
	tween_white_bg = %White_BG.create_tween()
	tween_white_bg.finished.connect(_tween_white_bg_finished)
	%White_BG.visible = true
	tween_white_bg.tween_property(%White_BG, "scale", Vector2(1.75*zoom, 1.75*zoom), duration)
	%Black.z_index = 4
	%White.z_index = 3
	tween_white = %White.create_tween()
	tween_white.tween_property(%White, "modulate", Color("WHITE", 0), duration)
	tween_black = %Black.create_tween()
	tween_black.tween_property(%Black, "modulate", Color("WHITE", 1), duration)
	%Player.set_collision_layer_value(4, true)
	%Player.set_collision_layer_value(3, false)
	%Player.set_collision_mask_value(2, true)
	%Player.set_collision_mask_value(1, false)


func _tween_white_bg_finished(): #after white scaling
	RenderingServer.set_default_clear_color(Color.hex(0xFAFBF6FF))
	%Black_BG.visible = false
	%Black_BG.scale = Vector2(0.001, 0.001)
	%White_BG.visible = false
	%White_BG.scale = Vector2(0.001, 0.001)


func get_current_color():
	return COLOR


func _ready():
	allow_switch_color = not $".".get_meta('is_1984_level')
	COLOR = bool(COLOR)
	if COLOR:
		RenderingServer.set_default_clear_color(Color.hex(0xFAFBF6FF))
		%White_BG.visible = false
		%Black_BG.visible = false
		%White_BG.scale = Vector2(0.001, 0.001)
		%Black_BG.scale = Vector2(0.001, 0.001)
		$White.modulate[3] = 0
		$Black.modulate[3] = 1
		$White.z_index = 3
		$Black.z_index = 4
		
		$Player.set_collision_mask_value(1, false)
		$Player.set_collision_mask_value(2, true)
		$Player.set_collision_layer_value(3, false)
		$Player.set_collision_layer_value(4, true)
		$Player.set_stuck_detectors(2)
	else:
		RenderingServer.set_default_clear_color(Color.hex(0x0F0F1BFF))
		%White_BG.visible = false
		%Black_BG.visible = false
		%White_BG.scale = Vector2(0.001, 0.001)
		%Black_BG.scale = Vector2(0.001, 0.001)
		$White.modulate[3] = 1
		$Black.modulate[3] = 0
		$White.z_index = 4
		$Black.z_index = 3
		
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
			
	if Input.is_action_just_pressed("switch_color") and allow_switch_color:
		switch_color()
		
		
	if Input.is_action_just_pressed("highlight") and not(is_anything_playing) and allow_flashlight:
		%Ui.start_timer()
		if COLOR:
			$Highlights.play("Blackhole")
		else:
			$Highlights.play("Flashlight")


func _on_flashlight_timer_timeout():
	allow_flashlight = true
