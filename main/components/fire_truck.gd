extends RigidBody2D

@export var speed = 500.0;
@export var accel = 20.0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var dir = Vector2.ZERO;
	if (Input.get_action_raw_strength("ui_down")):
		dir.y += 1
	if (Input.get_action_raw_strength("ui_up")):
		dir.y += -1
	if (Input.get_action_raw_strength("ui_right")):
		dir.x += 1
	if (Input.get_action_raw_strength("ui_left")):
		dir.x += -1
	
	if (dir.x != 0.0 or dir.y != 0.0):
		dir = dir.normalized();
	var targetVelocity = (dir * speed);
	self.apply_central_force((targetVelocity - self.linear_velocity) / (delta * (self.accel + 1.0))); # hard stop
	pass
