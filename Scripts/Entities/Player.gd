class_name Player
extends CharacterBody2D

@export var speed: int = 300
@export var jump_height: int = 800
@export var on_start_position: bool = true



var _health: int = 8#STOP! DO NOT MODIFY _health WITHOUT set_health THIS CAN CAUSE TERRIBLE BUGS
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var checkpoints: Array # 2d array e.g [[Vector2(position), checkpoint_color(true/false)
var is_on_elevator
var forcepushed: Array = [0,0,false] #[reqd speed, iterator, is turned on]
var forcejump_in_progress: int = 0 #to fix animations
var list_of_collisions: Array
var zoom_tween
var kill_slowly_in_progress: bool = false
var kill_slowly_immunity: int = 0


func set_zoom(zoom: float):
	if zoom_tween:
		zoom_tween.kill()
		zoom_tween = null
	zoom_tween = %Main_Camera.create_tween()
	zoom_tween.tween_property(%Main_Camera, "zoom", Vector2(zoom, zoom), 0.5)
	
func respawn(): #Used in Death_Zone to respawn player
	if $"..".get_current_color() != get_last_checkpoint_color(): #Current color and checkpoint must be different
		position = checkpoints[-1][0]
		velocity = Vector2(0, 0) #Fix the "portal effect"
		set_health(8)
		kill_slowly_in_progress = false
		kill_slowly_immunity = 10
	else:
		$"..".switch_color()
		position = checkpoints[-1][0]
		velocity = Vector2(0, 0) #Fix the "portal effect"
		set_health(8)
		kill_slowly_in_progress = false
		kill_slowly_immunity = 10
		
	

func death():
	respawn() #put death menus and animations here


func checkpoint(data: Array): #Used in Checkpoint_Area to add new checkpoint
	if not (data in checkpoints): #Anti-garbage protection
		checkpoints.append(data)


func get_last_checkpoint_color(): #Used in Death_Zone to switch color if it is necessary
	return checkpoints[-1][1]

func force_jump(data): #force player to jump by a third force
	$Animation.play("Jump")
	forcejump_in_progress = 10
	if typeof(data) == 2:
		velocity.y = data
	elif typeof(data) == 4:
		if data == "spike":
			velocity.y = -700
		elif data == "JumpPad":
			velocity.y = -1000
		elif data == "enemy_defeated":
			velocity.y = -300
		elif data == 'enemy hit x-':
			forcepushed = [-500,10,true] #setting desired speed and amount of ticks
			velocity = Vector2(-500, -500)
		elif data == 'enemy hit x+':
			forcepushed = [500,10,true]
			velocity = Vector2(500, -500)
		

func set_health(desired_health: int):#USE ONLY THIS FOR SETTING HEALTH, NOT _health ITSELF
	if desired_health <= 0:
		_health = 0
		%Ui.update_health(_health)
		death()
		return 1
	_health = desired_health
	%Ui.update_health(_health)
	return 0
	
func kill_slowly() -> void:
	kill_slowly_in_progress = true
	if not set_health(_health - 1):
		%Kill_timer.start()
	#TODO NEONX's health policy (c):
	#Player start with 8hp, 0 hp - no hp, i need to add func wich heals to 10 hp instantly



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
	if on_start_position:
		position = Vector2(-1152, -430)

func set_stuck_detectors(color:int):
	$Stuck_detector.collision_mask = color
	$Stuck_detector2.collision_mask = color
	$Stuck_detector3.collision_mask = color
	$Stuck_detector4.collision_mask = color

func _process(_delta):
	if Input.is_action_just_pressed("down") and is_on_elevator != null:
		is_on_elevator.elevator_down()
	if Input.is_action_just_pressed("up") and is_on_elevator != null:
		is_on_elevator.elevator_up()
	if kill_slowly_immunity:
		kill_slowly_immunity -= 1

func _physics_process(delta):
	var last_collision = get_last_slide_collision()
	if not list_of_collisions.has(last_collision):
		list_of_collisions.append(last_collision)
		
	if not is_on_floor():
		velocity.y += gravity * delta
		if (not $Animation.get_animation() == 'Jump' or velocity.y>0) and not ($Animation.get_animation() == 'Fall 2'):
			$Animation.play('Fall 2')
		if forcejump_in_progress:
			forcejump_in_progress -= 1
	elif not forcepushed[1] and not forcejump_in_progress:
		forcepushed = [0,0, false] # == if on_the_floor and forcepushed timer has ran out already, stop forcepushed shit
		# this is requred to stop player from correcting his position even after 9 ticks
		$Animation.play('Idle')
		
		
	if $Stuck_detector.has_overlapping_bodies() and $Stuck_detector2.has_overlapping_bodies() and $Stuck_detector3.has_overlapping_bodies() and $Stuck_detector4.has_overlapping_bodies() and not kill_slowly_in_progress and not kill_slowly_immunity:
		kill_slowly()
		print('starting to kill')
	

	
	if not forcepushed[1]: #to keep the speed for the firs 9 ticks, fix for the bug
		forcepushed[0] = 0 
	else: #the timer itself
		forcepushed[1] -= 1

	
	var direction = Input.get_axis("left", "right")
	if direction and not forcepushed[2]: # if forcepushed is active, get ur hands off the keyboard
		if direction == -1:
			$Animation.set_flip_h(true)
		else:
			$Animation.set_flip_h(false)
		velocity.x = direction * speed
		if is_on_floor() and not forcejump_in_progress:
			$Animation.play('Move')
	elif forcepushed[2]: #forcepushed speed enforcement(if we just declared speed and turned off velocty = 0, it will bug out eventually)
		if forcepushed[0]: #keeping the speed for 9 ticks part
			velocity.x = forcepushed[0]
	else:
		velocity.x = 0
		
	if Input.is_action_just_pressed("jump") and is_on_floor(): #if it causes problems, try moving it in front of the direction block
		velocity.y = jump_height
		$Animation.play('Jump')
		
	move_and_slide()


func _on_kill_timer_timeout():
	kill_slowly()
