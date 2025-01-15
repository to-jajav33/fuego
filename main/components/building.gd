extends Area2D

@onready var progress_bar_container = $progressBarContainer
@onready var progress_bar = $progressBarContainer/progressBar
@onready var label_time_left = $Label_time_left

var totalTimeOnFire = 1.0;
var isOnFire = false;
var isSelectedToBeOnFire = false;
var totalHealth = 100.0;

# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.signal_state_changed.connect(self.handleStateChanged);
	pass # Replace with function body.

func _process(delta):
	if (self.isOnFire):
		self.totalHealth -= delta;
		self.updateLabelTimeLeft();
	return;

func handleStateChanged(paramState):
	if (paramState == GameState.STATES_AVAILABLE.PLAY_FIRE_ALARM and self.isSelectedToBeOnFire == true):
		self.onFire();
	return;

func _on_area_entered(area):
	if (area.is_in_group("group_area_round_up_building")):
		GameState.addBuilding(self);
		self.isSelectedToBeOnFire = true;
		self.totalHealth = randf_range(20.0, 100.0);
		self.updateLabelTimeLeft();
	pass # Replace with function body.


func _on_area_exited(area):
	if (area.is_in_group("group_area_round_up_building")):
		GameState.removeBuilding(self);
		self.isSelectedToBeOnFire = false;
	pass # Replace with function body.

func onFire(startHealth = self.totalHealth):
	self.isOnFire = true;
	self.totalHealth = startHealth;
	self.updateLabelTimeLeft();
	return;

func onAddWater(paramAmount = 10.0):
	if (self.totalHealth > 0.0):
		self.totalHealth += paramAmount;
		self.updateLabelTimeLeft();
	return;

func updateLabelTimeLeft():
	self.progress_bar_container.show();
	self.label_time_left.text = str(ceil(self.totalHealth));
	self.progress_bar.changePlayHeadPosition(min(100.0, max(0.0, self.totalHealth / 100.0)));
	return;
	
