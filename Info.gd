extends CanvasLayer

func _unhandled_input(event):
	if event.is_action_released('cela_obrazovka'):
		var MOD = [
			DisplayServer.WINDOW_MODE_WINDOWED,
			DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
			]
		
		if DisplayServer.window_get_mode() == MOD[0]:
			DisplayServer.window_set_mode(MOD[1])
		else:
			DisplayServer.window_set_mode(MOD[0])
	
	elif event.is_action_released('zavreni'):
		get_tree().quit()
