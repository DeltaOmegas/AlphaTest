extends CharacterBody2D

var dead: bool = false
var hold: Array = [false, 0]

@export var speed: int = 100


func _ready():
	speed *= -1



func _physics_process(_delta):
	
	#if hold[0]: #ignore is_on_wall() for 5 ticks so enemy wouldnt flicker
	#	if hold[1] < 6:
	#		hold[1] += 1
	#	else:
	#		hold = [false, 0]
	#not requred anymore, but just in case
	
	if is_on_wall(): #and not hold[0]:
		speed *= -1
		hold = [true, 0]
	velocity.x = speed
	move_and_slide()
	

func death():
	dead = true
	$".".visible = false #add death animations
	$Attack_Zone_Left.collision_mask = 0
	$Attack_Zone_Right.collision_mask = 0
	$Defeat_Zone.collision_mask = 0
	$".".collision_layer = 0
