extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_area_entered(area):
	if (area.is_in_group("group_area_round_up_building")):
		GameState.addBuilding(self);
	pass # Replace with function body.


func _on_area_exited(area):
	if (area.is_in_group("group_area_round_up_building")):
		GameState.removeBuilding(self);
	pass # Replace with function body.
