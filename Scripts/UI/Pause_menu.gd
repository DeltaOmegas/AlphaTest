extends CanvasLayer



func _on_continue_button_pressed():
	$"..".pause_transfer()

func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://Objects/UI/Main_menu.tscn")

func _on_restart_button_pressed():
	$"..".pause_transfer()
	$"..".respawn_transfer()
	
