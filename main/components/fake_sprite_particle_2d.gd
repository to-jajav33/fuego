@tool
extends Node2D

signal signal_sprite_removed(global_pos);
signal signal_sprite_spawned();

@export var texture: Texture2D;
@export var emitting := false;
@export var maxVel := Vector2.LEFT;
@export var minVel := Vector2.ZERO;
@export var maxNumberOfSprites :int= 4;
@export var maxLifeSpanSeconds :float = 0.75;
@export var minLifeSpanSeconds :float = 0.5;
@export var spawnRateMax :float = 1.0;
@export var spawnRateMin :float = 1.0;

var spawnedSprites = [];
@onready var lastTimer = get_tree().create_timer(0.01);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if (self.spawnedSprites.size() < self.maxNumberOfSprites):
		self.spawnSprite();
	
	for sprite in self.spawnedSprites:
		sprite.move_and_slide();
	pass

func spawnSprite():
	if (self.texture and self.emitting and self.lastTimer.time_left <= 0.0):
		self.lastTimer = get_tree().create_timer(randf_range(spawnRateMin, spawnRateMax));
		var kBody = CharacterBody2D.new();
		var sprite = Sprite2D.new();
		var area2d = Area2D.new();
		var collisionShape = CollisionShape2D.new();
		collisionShape.shape = CircleShape2D.new();
		collisionShape.shape.radius = self.texture.get_size().x;
		area2d.add_child(collisionShape);
		kBody.add_child(area2d);
		sprite.texture = self.texture;
		kBody.add_child(sprite);
		self.spawnedSprites.append(kBody);
		var vel = Vector2(randf_range(minVel.x, maxVel.x), randf_range(minVel.y, maxVel.y));
		var layer = get_tree().get_nodes_in_group("group_layer_bullet")[0];
		kBody.global_transform = self.global_transform
		kBody.velocity = vel.length() * Vector2.from_angle(self.global_rotation + vel.angle() - (PI * 0.5)).normalized();
		layer.add_child(kBody);
		var timer = get_tree().create_timer(randf_range(self.minLifeSpanSeconds, self.maxLifeSpanSeconds));
		self.signal_sprite_spawned.emit();
		await timer.timeout;
		self.removeSprite(kBody);
	return;

func removeSprite(paramSprite):
	if (self.spawnedSprites.has(paramSprite)):
		var gPos = paramSprite.global_position;
		self.spawnedSprites.erase(paramSprite);
		paramSprite.queue_free();
		self.signal_sprite_removed.emit(gPos);
	return;
