extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.changeState(GameState.STATES_AVAILABLE.PLAY_NO_ALARM);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
