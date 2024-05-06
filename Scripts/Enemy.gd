extends CharacterBody2D

var dead: bool = false

func _ready():
	pass 



func _process(delta):
	pass

func death():
	dead = true
	$".".visible = false #add death animations
	$Attack_Zone.collision_mask = 0
	$Defeat_Zone.collision_mask = 0
	$".".collision_layer = 0
