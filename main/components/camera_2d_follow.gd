extends Node2D

@export_node_path("Node2D") var nodePathToFollow;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (self.nodePathToFollow):
		var targetNode = self.get_node(self.nodePathToFollow);
		var newX = lerpf(self.global_position.x, targetNode.global_position.x, delta);
		var newY = lerpf(self.global_position.y, targetNode.global_position.y, delta);
		
		self.global_position = Vector2(newX, newY);
	pass
