extends CanvasLayer

@export var flashlight_time:int = 5
var tween
#func _ready():
#	$Flashlight_Timer.visible(true)
#	$Health_indicator.visible(true)
	


func set_pause(pause_state: bool):
	$Time_indicator.visible = not pause_state
	$Health_indicator.visible = not pause_state
	$PauseMenu.visible = pause_state
	


func start_timer():
	tween = $Time_indicator.create_tween()
	tween.tween_property($Time_indicator, 'frame', 30, flashlight_time)
	tween.finished.connect(_on_finished)
	$"..".allow_flashlight = false


func _on_finished():
	$"..".allow_flashlight = true
	$Time_indicator.frame = 0


func update_health(health: int):
	$Health_indicator.frame = health
