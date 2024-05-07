extends CharacterBody2D

var dead: bool = false
var hold: Array = [false, 0]

@export var base_velocity: int = -100

func _ready():
	pass



func _process(delta):
	pass
	

func _physics_process(delta):
	
	#if hold[0]: #ignore is_on_wall() for 5 ticks so enemy wouldnt flicker
	#	if hold[1] < 6:
	#		hold[1] += 1
	#	else:
	#		hold = [false, 0]
	#not requred anymore, but just in case
	
	if is_on_wall(): #and not hold[0]:
		base_velocity *= -1
		hold = [true, 0]
	velocity.x = base_velocity
	move_and_slide()
	

func death():
	dead = true
	$".".visible = false #add death animations
	$Attack_Zone.collision_mask = 0
	$Defeat_Zone.collision_mask = 0
	$".".collision_layer = 0
