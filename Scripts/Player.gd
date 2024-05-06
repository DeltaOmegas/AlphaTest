class_name Player
extends CharacterBody2D

@export var speed: int = 300
@export var jump_heigh: int = 800

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var spawnpoint: Array[Vector2] = []


func death():
	position = spawnpoint[-1]
	velocity = Vector2(0, 0)


func Checkpoint(pos: Vector2):
	spawnpoint.append(pos)
	print(pos)


func _ready():
	jump_heigh *= -1
	spawnpoint.append(get_position())
	$Flashlight.visible = false
	$Blackhole.visible = false


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_heigh
		
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = 0
		$AnimationPlayer.play("Idle")
	
	move_and_slide()
