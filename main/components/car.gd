extends RigidBody2D

@onready var navigation_agent_2d :NavigationAgent2D= $NavigationAgent2D

var movement_speed = 200.0;
var coolDownMax = 10.0; # seconds
var coolDownCurrent = 0.0;


# Called when the node enters the scene tree for the first time.
func _ready():
	self.movement_speed = randf_range(200.0, 300.0);
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	#self.navigation_agent_2d.path_desired_distance = 20.0
	#self.navigation_agent_2d.target_desired_distance = 100.0

	# Make sure to not await during _ready.
	self.navAgentSetup.call_deferred()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	self.coolDownCurrent += delta;
	var finalPos = self.navigation_agent_2d.get_final_position();
	if (finalPos.distance_to(global_position) <= self.navigation_agent_2d.target_desired_distance):
		self.navAgentSetup.call_deferred();
		return
	
	if (self.coolDownCurrent >= self.coolDownMax):
		self.coolDownCurrent = 0.0;
		self.navAgentSetup.call_deferred();
		return;
	
	var current_agent_position: Vector2 = self.global_position;
	var next_path_position: Vector2 = self.navigation_agent_2d.get_next_path_position()

	var targVel = current_agent_position.direction_to(next_path_position) * movement_speed;
	self.apply_central_force(targVel - self.linear_velocity);
	pass


func navAgentSetup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame;
	
	var randomAngle = randf() * 2.0 * PI; # Generate a random angle between 0 and 2π
	var signX1 = randi_range(-1, 1); # Sine will be positive or negative
	var signX2 = randi_range(-1, 1); # Sine will be positive or negative
	var signY1 = randi_range(-1, 1); # Sine will be positive or negative
	var signY2 = randi_range(-1, 1); # Sine will be positive or negative

	# Now that the navigation map is no longer empty, set the movement target.
	self.setNavAgentTargetPosition(Vector2(randf_range(1000.0 * signX1, 2000.0 * signY1), randf_range(1000.0 * signX2, 2000.0 * signY2)) + global_position);
	return;

func setNavAgentTargetPosition(movement_target: Vector2):
	self.navigation_agent_2d.target_position = movement_target
	return;
