extends Area2D


func _on_area_entered(area):
	if (area.is_in_group("group_area_firetruck")):
		if (GameState.currState != GameState.STATES_AVAILABLE.PLAY_FIRE_ALARM):
			GameState.createFireAlarm();
	pass # Replace with function body.
