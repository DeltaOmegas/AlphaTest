extends CanvasLayer


#func _ready():
#	$Flashlight_Timer.visible(true)
#	$Health_indicator.visible(true)
	
func set_pause(pause_state: bool):
	$Flashlight_Timer.visible = not pause_state
	$Health_indicator.visible = not pause_state
	$PauseMenu.visible = pause_state
	
func update_timer(time:String):
	$Flashlight_Timer.set_text(time)
	
func update_health(health: int):
	$Health_indicator.set_text(str(health))
	
