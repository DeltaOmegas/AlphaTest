class_name Player
extends CharacterBody2D

@export var speed: int = 300
@export var jump_height: int = 800

#settings for forced jumps
@export var spike_jump_height: int = 800


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var checkpoints: Array = [] # 2d array e.g [[Vector2(position), checkpoint_color(true/false)]]
var spikes: Array = [] # Same as checkpoints


func respawn(): #Used in Death_Zone to respawn player
	position = checkpoints[-1][0]
	velocity = Vector2(0, 0) #Fix the "portal effect"


func checkpoint(data: Array): #Used in Checkpoint_Area to add new checkpoint
	if not (data in checkpoints): #Anti-garbage protection
		checkpoints.append(data)

func get_last_checkpoint_color(): #Used in Death_Zone to switch color if it is necessary
	return checkpoints[-1][1]

func force_jump(data): #force player to jump by a third force
	if typeof(data) == 2:
		velocity.y = data
	elif typeof(data) == 4:
		if data == "spike":
			velocity.y = spike_jump_height
	


func _ready():
	spike_jump_height *= -1
	jump_height *= -1
	checkpoints.append([get_position(), not($"..".get_current_color())]) #Make a virtual checkpoint on start position
	$Flashlight.visible = false
	$Blackhole.visible = false


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_height
		
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = 0
		$AnimationPlayer.play("Idle")
	
	move_and_slide()
