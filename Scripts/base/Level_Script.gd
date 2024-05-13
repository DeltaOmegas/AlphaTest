extends Node2D

@export var background_color: bool = false
@export_range(0.05, 2) var color_switch_duration: float = 0.5
@export_range(0.1, 5) var color_switch_delay: float = 0.4
@export_range(0.05, 2) var highlight_transition_time: float = 0.25
var allow_flashlight: bool = true
var allow_switch_color: Array[bool] = [true, true] #[by zone, by timer]


var tween_black_bg
var tween_white_bg
var tween_black
var tween_white


func switch_color():
	background_color = not(background_color)
	if background_color:
		if tween_black_bg:
			tween_black_bg.kill()
			tween_black_bg = false
			tween_black.kill()
			tween_black = false
			tween_white.kill()
			tween_white = false
			RenderingServer.set_default_clear_color(Color.hex(0x0F0F1BFF))
			%Black.modulate = Color("white", 0)
			%White.modulate = Color("white", 1)
			%White_BG.visible = false
			%White_BG.scale = Vector2(0.001, 0.001)
			%Black_BG.visible = false
			%Black_BG.scale = Vector2(0.001, 0.001)
		%Player.set_stuck_detectors(2)
		to_white(%Main_Camera.zoom.y, color_switch_duration)
	else:
		if tween_white_bg:
			tween_white_bg.kill()
			tween_white_bg = false
			tween_black.kill()
			tween_black = false
			tween_white.kill()
			tween_white = false
			RenderingServer.set_default_clear_color(Color.hex(0xFAFBF6FF))
			%Black.modulate = Color("white", 1)
			%White.modulate = Color("white", 0)
			%Black_BG.visible = false
			%Black_BG.scale = Vector2(0.001, 0.001)
			%White_BG.visible = false
			%White_BG.scale = Vector2(0.001, 0.001)
		%Player.set_stuck_detectors(1)
		to_black(%Main_Camera.zoom.y, color_switch_duration)

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

func highlight_on(transition):
	if background_color:
		tween_black = %Black.create_tween()
		tween_black.tween_property(%Black, "modulate", Color("white", 0.5), transition)
		tween_white = %White.create_tween()
		tween_white.tween_property(%White, "modulate", Color("white", 1), transition)
		%White.z_index = 4
		%Black.z_index = 3
	else:
		tween_black = %Black.create_tween()
		tween_black.tween_property(%Black, "modulate", Color("white", 1), transition)
		tween_white = %White.create_tween()
		tween_white.tween_property(%White, "modulate", Color("white", 0.5), transition)
		%White.z_index = 3
		%Black.z_index = 4


func highlight_off(transition):
	if background_color:
		tween_black = %Black.create_tween()
		tween_black.tween_property(%Black, "modulate", Color("white", 1), transition)
		tween_white = %White.create_tween()
		tween_white.finished.connect(_on_white_finished)
		tween_white.tween_property(%White, "modulate", Color("white", 0), transition)
		%White.z_index = 3
		%Black.z_index = 4
	else:
		tween_black = %Black.create_tween()
		tween_black.finished.connect(_on_black_finished)
		tween_black.tween_property(%Black, "modulate", Color("white", 0), transition)
		tween_white = %White.create_tween()
		tween_white.tween_property(%White, "modulate", Color("white", 1), transition)
		%White.z_index = 4
		%Black.z_index = 3


func _on_black_finished():
	%White.z_index = 4
	%Black.z_index = 3
	
func _on_white_finished():
	%White.z_index = 3
	%Black.z_index = 4
	
	
func get_current_color():
	return background_color


func _ready():
	allow_switch_color[0] = not $".".get_meta('is_1984_level')
	background_color = bool(background_color)
	if background_color:
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

func pause():
	if get_tree().paused:
		get_tree().paused = false
		%Ui.set_pause(false)
	else:
		get_tree().paused = true
		%Ui.set_pause(true)

func _process(_delta):
	print(allow_switch_color)
	if Input.is_action_just_pressed('pause'):
		pause()
	if Input.is_action_just_pressed("switch_color") and allow_switch_color == [true, true]:
		switch_color()
		allow_switch_color[1] = false
		%Color_switch_timer.start(color_switch_delay)
		
		
	if Input.is_action_just_pressed("highlight") and allow_flashlight:
		highlight_on(highlight_transition_time)
	if Input.is_action_just_released("highlight") and allow_flashlight:
		highlight_off(highlight_transition_time)
		$Ui.start_timer()

func _on_color_switch_timer_timeout():
	allow_switch_color[1] = true


func _on_flashlight_timer_timeout():
	allow_flashlight = true
