class_name Player
extends CharacterBody2D

#128, -72
const SPEED = 300.0
const JUMP_VELOCITY = -800.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var curent_color: bool = false

var spawnpoint: Array[Vector2] = []


func _process(delta):
	if Input.is_action_just_pressed("switch_color") and (not(%Black_BG.visible) or not(%White_BG.visible)):
		curent_color = not(curent_color)

	if Input.is_action_just_pressed("highlight") and not($AnimationPlayer2.is_playing()):
		if curent_color:
			$AnimationPlayer2.play("Blackhole")
		else:
			$AnimationPlayer2.play("Flashlight")
	
	if $AnimationPlayer2.is_playing():
		pass
	else:
		$Flashlight.visible = false
		$Blackhole.visible = false

	if curent_color and %White_BG.scale[0] < 1.7:
		%Black_BG.set_z_index(0)
		%White_BG.set_z_index(1)
		%White_BG.turn_White(delta)
	elif not(curent_color) and %Black_BG.scale[0] < 1.7:
		%White_BG.set_z_index(0)
		%Black_BG.set_z_index(1)
		%Black_BG.turn_Black(delta)
	elif not(curent_color) and %Black_BG.scale[0] >= 1.7:
		%White_BG.scale = Vector2(0.01, 0.01)
		%White_BG.visible = false
		%White.visible = true
		if not($AnimationPlayer2.is_playing()):
			%Black.visible = false
		set_collision_mask_value(2, false) #1-white 2-black
		set_collision_mask_value(1, true) #1-white 2-black
	elif curent_color and %White_BG.scale[0] >= 1.7:
		%Black_BG.scale = Vector2(0.01, 0.01)
		%Black_BG.visible = false
		%Black.visible = true
		if not($AnimationPlayer2.is_playing()):
			%White.visible = false
		set_collision_mask_value(1, false) #1-white 2-black
		set_collision_mask_value(2, true) #1-white 2-black


func death():
	position = spawnpoint[-1]
	velocity = Vector2(0, 0)


func Checkpoint():
	spawnpoint.append(get_position())
	print("Checkpoint reached")


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = 0
		$AnimationPlayer.play("Idle")
	
	move_and_slide()
