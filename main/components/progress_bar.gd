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
	var pos = min(1.0, max(self.playHeadPosition, 0.0));
	$AnimationPlayer.current_animation = "anim_progress";
	$AnimationPlayer.seek(pos * $AnimationPlayer.current_animation_length);
	pass
