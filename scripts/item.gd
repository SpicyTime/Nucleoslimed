extends StaticBody2D
@onready var sprite: Sprite2D = $Sprite2D

@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@export var sprite_texture: Texture2D

var id: String
func is_item():
	pass
func handle_interaction():
	pass
func get_id():
	return id
# Called when the node enters the scene tree for the first time.
func set_texture():
	sprite.texture = sprite_texture
func resize_collision_shape():
	if sprite_texture:
		var texture_width = sprite_texture.get_width()
		var texture_height = sprite_texture.get_height()
		print(texture_width, texture_height)
		collision_shape.shape.extents = Vector2(texture_width, texture_height)
func _ready() -> void:
	set_texture()
	resize_collision_shape()
	 
