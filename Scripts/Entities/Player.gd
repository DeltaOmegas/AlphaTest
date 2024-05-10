class_name Player
extends CharacterBody2D

@export var speed: int = 300
@export var jump_height: int = 800




var _health: int = 8#STOP! DO NOT MODIFY _health WITHOUT set_health THIS CAN CAUSE TERRIBLE BUGS
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var checkpoints: Array # 2d array e.g [[Vector2(position), checkpoint_color(true/false)
var is_on_elevator
var forcepushed: Array = [0,0,false] #[reqd speed, iterator, is turned on]


func animation(type):
	pass
func respawn(): #Used in Death_Zone to respawn player
	position = checkpoints[-1][0]
	velocity = Vector2(0, 0) #Fix the "portal effect"
	set_health(8)

func death():
	respawn() #put death menus and animations here

func checkpoint(data: Array): #Used in Checkpoint_Area to add new checkpoint
	if not (data in checkpoints): #Anti-garbage protection
		checkpoints.append(data)


func get_last_checkpoint_color(): #Used in Death_Zone to switch color if it is necessary
	return checkpoints[-1][1]

func force_jump(data): #force player to jump by a third force
	$Animation.play("Jump")
	if typeof(data) == 2:
		velocity.y = data
	elif typeof(data) == 4:
		if data == "spike":
			velocity.y = -700
		elif data == "JumpPad":
			velocity.y = -1000
		elif data == 'enemy hit x-':
			forcepushed = [-500,10,true]
			velocity = Vector2(-500, -500)
		elif data == 'enemy hit x+':
			forcepushed = [500,10,true]
			velocity = Vector2(500, -500)
		

func set_health(desired_health: int):#USE ONLY THIS FOR SETTING HEALTH, NOT _health ITSELF
	if desired_health <= 0:
		_health = 0
		%Ui.update_health(_health)
		death()
		return
	_health = desired_health
	%Ui.update_health(_health)

func damage_by(damage: int):#damage from spikes and enemies
	if damage >= _health:
		set_health(0)
		return
	set_health(_health - damage)

func get_health():
	return(_health)

func _ready():
	jump_height *= -1
	checkpoints.append([get_position(), not($"..".get_current_color())]) #Make a virtual checkpoint on start position
	$Flashlight.visible = false
	$Blackhole.visible = false
	%Ui.update_health(_health)


func _process(_delta):
	if Input.is_action_just_pressed("down") and is_on_elevator != null:
		is_on_elevator.elevator_down()
	if Input.is_action_just_pressed("up") and is_on_elevator != null:
		is_on_elevator.elevator_up()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	elif not forcepushed[1]:
		forcepushed = [0,0, false]
		
	if not forcepushed[1]:
		forcepushed[0] = 0
	else:
		forcepushed[1] -= 1

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_height
	var direction = Input.get_axis("left", "right")
	if direction and not forcepushed[2]:
		if direction == -1:
			$Animation.set_flip_h(false)
		else:
			$Animation.set_flip_h(true)
		velocity.x = direction * speed
	elif forcepushed[2]:
		if forcepushed[0]:
			velocity.x = forcepushed[0]
	else:
		velocity.x = 0
	
	move_and_slide()
	
