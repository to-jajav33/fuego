extends Area2D


func _on_body_entered(body):
	if (body.is_in_group("group_body_firetruck")):
		if (GameState.currState != GameState.STATES_AVAILABLE.PLAY_FIRE_ALARM):
			GameState.createFireAlarm();
	pass # Replace with function body.
