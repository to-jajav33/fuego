extends RigidBody2D

@export var speed = 500.0;
@export var accel = 20.0;
var rotationSpeed = 2.0

const INPUT_STATES = {
	"DRIVING": "DRIVING",
	"WATER": "WATER"
}
var inputState = INPUT_STATES.DRIVING;

func _input(_event: InputEvent):
	if (Input.get_action_strength("ui_accept")):
		self.inputState = INPUT_STATES.WATER;
	else:
		self.inputState = INPUT_STATES.DRIVING;
	return;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (self.inputState == INPUT_STATES.WATER):
		var rotatDir = 0.0
		if (Input.get_action_raw_strength("ui_left")):
			rotatDir += -1.0;
		if (Input.get_action_raw_strength("ui_right")):
			rotatDir += 1.0;
		$hoseRoot.rotate(lerpf(0.0, rotationSpeed * rotatDir, delta));
	var dir = Vector2.ZERO;
	if (self.inputState == INPUT_STATES.DRIVING):
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
