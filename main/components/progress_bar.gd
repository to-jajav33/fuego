extends Node2D

const TYPES_AVAILABLE = {
	"FIRE": "FIRE",
	"WATER": "WATER",
	"TIME": "TIME",
}
var progressType = TYPES_AVAILABLE.FIRE;
var playHeadPosition = 0;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func changePlayHeadPosition(paramPos):
	self.playHeadPosition = paramPos;
	print("playhead ", self.playHeadPosition);
	var pos = min(1.0, max(self.playHeadPosition, 0.0));
	$AnimationPlayer.active = true;
	$AnimationPlayer.current_animation = "anim_progress";
	var shouldUpdate = true;
	$AnimationPlayer.seek(pos * $AnimationPlayer.current_animation_length, shouldUpdate);
	var shouldKeepState = true;
	$AnimationPlayer.stop(shouldKeepState);
	return;
