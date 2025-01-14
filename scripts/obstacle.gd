extends Node2D
@onready var sprite: Sprite2D = $"."
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if sprite.texture:
		var texture_width = sprite.texture.get_width()
		var texture_height = sprite.texture.get_height()
		print(texture_width, texture_height)
		collision_shape.shape.extents = Vector2(texture_width, texture_height)
		
