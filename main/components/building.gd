extends Area2D

@onready var tweenOnFire = get_tree().create_tween()
@onready var progress_bar_container = $progressBarContainer
@onready var progress_bar = $progressBarContainer/progressBar

var totalTimeOnFire = 1.0;
var isOnFire = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.signal_state_changed.connect(self.handleStateChanged);
	pass # Replace with function body.

func handleStateChanged(paramState):
	if (paramState == GameState.STATES_AVAILABLE.PLAY_FIRE_ALARM and self.isOnFire == true):
		self.onFire(GameState.currentFireAlarmTime);
	return;

func _on_area_entered(area):
	if (area.is_in_group("group_area_round_up_building")):
		GameState.addBuilding(self);
		self.isOnFire = true;
	pass # Replace with function body.


func _on_area_exited(area):
	if (area.is_in_group("group_area_round_up_building")):
		GameState.removeBuilding(self);
	pass # Replace with function body.

func onFire(paramTime):
	self.progress_bar_container.show();
	self.totalTimeOnFire = paramTime;
	self.tweenOnFire.kill();
	print("building on fire for ", self.totalTimeOnFire);
	self.tweenOnFire.tween_property(self.progress_bar, "playHeadPosition", 0.0, self.totalTimeOnFire);
	self.tweenOnFire.play();
	return;

func onAddWater(paramAmount = 10.0):
	var elapsedTime = self.tweenOnFire.get_total_elapsed_time();
	self.tweenOnFire.stop();
	self.tweenOnFire.kill();
	self.tweenOnFire.tween_property(self.progress_bar, "playHeadPosition", self.progress_bar + paramAmount, 0.125);
	
	self.tweenOnFire.tween_property(self.progress_bar, "playHeadPosition", 0.0, max(0.0, self.totalTimeOnFire - elapsedTime));
	self.tweenOnFire.play();
	return;
