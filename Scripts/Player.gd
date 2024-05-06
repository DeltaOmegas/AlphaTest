class_name Player
extends CharacterBody2D

@export var speed: int = 300
@export var jump_heigh: int = 800

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var checkpoints: Array = [] # 2d array e.g [[Vector2(position), checkpoint_color(true/false)]]
var spikes: Array = [] # Same as checkpoints


func respawn(): #Used in Death_Zone to respawn player
	position = checkpoints[-1][0]
	velocity = Vector2(0, 0) #Fix the "portal effect"


func checkpoint(data: Array): #Used in Checkpoint_Area to add new checkpoint
	if not (data in checkpoints): #Anti-garbage protection
		checkpoints.append(data)

func spike(data: Array): #Same as checkpoint
	if not (data in spikes): #Anti-garbage protection
		spikes.append(data)

func get_last_checkpoint_color(): #Used in Death_Zone to switch color if it is necessary
	return checkpoints[-1][1]


func _ready():
	jump_heigh *= -1
	checkpoints.append([get_position(), not($"..".get_current_color())]) #Make a virtual checkpoint on start position
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
