extends Node

const STATES_AVAILABLE = {
	"MENUS": "MENUS",
	"PLAY_NO_ALARM": "PLAY_NO_ALARM",
	"PLAY_CINEMATICS": "PLAY_CINEMATICS",
	"PLAY_FIRE_ALARM": "PLAY_FIRE_ALARM",
}
var currState = STATES_AVAILABLE.MENUS;
var buildingsOnFire = [];

func addBuilding(paramBuilding):
	print("adding building ", paramBuilding);
	if (!self.buildingsOnFire.has(paramBuilding)):
		self.buildingsOnFire.append(paramBuilding);
	return;

func removeBuilding(paramBuilding):
	print("remove building ", paramBuilding);
	if (self.buildingsOnFire.has(paramBuilding)):
		self.buildingsOnFire.erase(paramBuilding);
	return;

func changeState(paramState):
	print("change state to ", paramState);
	self.currState = paramState;
	return;

func createFireAlarm():
	if (self.currState == self.STATES_AVAILABLE.PLAY_NO_ALARM):
		print("create fire alarm");
		var buildings = get_tree().get_nodes_in_group("group_area_building");
		var singleBuilding = buildings.pick_random();
		var roundUpBuilding = get_tree().get_nodes_in_group("group_area_round_up_building")[0];
		roundUpBuilding.global_position = singleBuilding.global_position;
		
		roundUpBuilding.set_deferred("monitoring", true);
		roundUpBuilding.set_deferred("monitorable", true);
		self.changeState(self.STATES_AVAILABLE.PLAY_CINEMATICS);
		
		var fireTruck = get_tree().get_nodes_in_group("group_body_firetruck")[0];
		var camera = get_tree().get_nodes_in_group("group_node2d_cameraFollow")[0];
		var tween = get_tree().create_tween();
		tween.tween_property(camera, "nodePathToFollow", camera.get_path_to(roundUpBuilding), 3.0);
		tween.tween_property(camera, "nodePathToFollow", camera.get_path_to(fireTruck), 3.0);
		tween.tween_callback(self.changeState.bind(self.STATES_AVAILABLE.PLAY_FIRE_ALARM));
		
		tween.play();
	return;
