class_name Player
extends CharacterBody2D

@export var speed: int = 300
@export var jump_heigh: int = 800

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var checkpoints: Array = [] # 2d array e.g [[Vector2(position), checkpoint_color(true/false)]]


func death():
	position = checkpoints[-1][0]
	velocity = Vector2(0, 0)


func Checkpoint(data: Array):
	checkpoints.append(data)
	

func get_last_checkpoint_color():
	return checkpoints[-1][1]


func _ready():
	jump_heigh *= -1
	checkpoints.append([get_position(), not($"..".get_current_color())])
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
