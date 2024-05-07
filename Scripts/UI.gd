extends CanvasLayer

#func _ready():
#	$Flashlight_Timer.visible(true)
#	$Health_indicator.visible(true)
	
	
func update_timer(time:String):
	$Flashlight_Timer.set_text(time)
	
func update_health(health: int):
	$Health_indicator.set_text(health)
	
