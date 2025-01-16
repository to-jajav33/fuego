extends RigidBody2D

@export var speed = 500.0;
@export var accel = 20.0;
@onready var cpu_particles_2d = $hoseRoot/nozzle/fakeSpriteParticle2D
@onready var progress_bar = $progressBar;

var maxWaterDroplets = 200.0;
@onready var currentWaterDroplets = maxWaterDroplets
@onready var waterInTank = 100.0;
var rotationSpeed = 2.0
var isFillingWater = false;

const INPUT_STATES = {
	"DRIVING": "DRIVING",
	"WATER": "WATER"
}
var inputState = INPUT_STATES.DRIVING;

func _ready():
	self.cpu_particles_2d.signal_sprite_spawned.connect(_on_signal_signal_sprite_spawned);
	return;

func _input(_event: InputEvent):
	if (Input.get_action_strength("ui_accept") and self.waterInTank > 0.0):
		self.inputState = INPUT_STATES.WATER;
		self.cpu_particles_2d.emitting = true;
	else:
		self.inputState = INPUT_STATES.DRIVING;
		self.cpu_particles_2d.emitting = false;
	return;

func _process(delta):
	if (self.isFillingWater == true and self.currentWaterDroplets < self.maxWaterDroplets):
		self.currentWaterDroplets += 1;
	self.waterInTank = (self.currentWaterDroplets / self.maxWaterDroplets) * 100.0;
	
	if (self.cpu_particles_2d.emitting):
		if (self.waterInTank > 0.0):
			self.progress_bar.changePlayHeadPosition(self.waterInTank / 100.0);
		else:
			self.waterInTank = 0.0;
			self.progress_bar.changePlayHeadPosition(self.waterInTank / 100.0);
			self.cpu_particles_2d.emitting = false;
	elif (self.isFillingWater == true):
		self.progress_bar.changePlayHeadPosition(self.waterInTank / 100.0);
	return;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var dir = Vector2.ZERO;
	if (GameState.currState == GameState.STATES_AVAILABLE.PLAY_NO_ALARM or GameState.currState == GameState.STATES_AVAILABLE.PLAY_FIRE_ALARM):
		var rotatDir = 0.0
		if (Input.get_action_raw_strength("action_rotate_host_counterclockwise")):
			rotatDir += -1.0;
		if (Input.get_action_raw_strength("action_rotate_host_normalclockwise")):
			rotatDir += 1.0;
		$hoseRoot.rotate(lerpf(0.0, rotationSpeed * rotatDir, delta));
		
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


func _on_area_2d_area_entered(area):
	if (area.is_in_group("group_area_firestation")):
		self.isFillingWater = true;
	pass # Replace with function body.


func _on_area_2d_area_exited(area):
	if (area.is_in_group("group_area_firestation")):
		self.isFillingWater = false;
	pass # Replace with function body.

func _on_signal_signal_sprite_spawned():
	self.currentWaterDroplets -= 1;
	return;
