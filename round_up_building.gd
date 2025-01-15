extends Area2D

@onready var collision_shape_2d = $CollisionShape2D

func changeShapeSizeTo(paramRadius = 10.0):
	collision_shape_2d.shape.radius = paramRadius;
	return;
