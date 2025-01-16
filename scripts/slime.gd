extends CharacterBody2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attach_radius: Area2D = $VisionArea/attach_radius
@onready var timer: Timer = $VisionArea/Timer
@onready var damage_area: Area2D = $damage_area
@onready var player: CharacterBody2D = get_node("/root/Game/Player")
@onready var slime: CharacterBody2D = $"."
@export var movement_speed: float = 0
var character_direction: Vector2
var target: CharacterBody2D
var is_attached: bool = false
var in_damage_zone = false
var target_frame_size
func find_animated_sprite(body: Node) -> AnimatedSprite2D:
	for child in body.get_children():
		if child is AnimatedSprite2D:
			return child
	return null
func attach(body: CharacterBody2D):
	if is_attached or body.has_slime_attached:
		
		return 
	print(body, " is attached to ", self)
	is_attached = true
	body.has_slime_attached = true
	#return
	var sprite = find_animated_sprite(body)
	
	if sprite:
		var frame_texture = animated_sprite.sprite_frames.get_frame_texture("idle" ,0)
		var frame_size: Vector2 = frame_texture.get_size()
		is_attached = true
		target_frame_size = frame_size
		global_position = Vector2(body.global_position.x + frame_size[0], body.global_position.y + frame_size[1])
		global_rotation_degrees = 45
func detach():
	is_attached = false
	global_rotation =  0
func _physics_process(delta: float) -> void:
	var direction: Vector2
	if is_attached :
		if is_instance_valid(target):
			global_position =  Vector2(target.global_position.x + target_frame_size[0] / 2, target.global_position.y - target_frame_size[1] + 4)
			animated_sprite.play("idle")
		else:
			detach()
	if target and is_instance_valid(target):
		direction = (target.global_position - global_position).normalized()
	if direction.x != 0 or direction.y != 0:
		animated_sprite.play("bounce")
	else:
		animated_sprite.play("idle")
	
	velocity = direction  * movement_speed
	if is_attached:
		pass
		#velocity = Vector2()
	move_and_collide(velocity * delta)
 
func _on_vision_area_body_entered(body: Node2D) -> void:
	movement_speed = 50
	if not is_attached:
		if body.has_method("set_wander_pos"):
			if not body.is_satisfied:
				target = body
		else:
			target = body
	timer.stop()
func _on_vision_area_body_exited(_body: Node2D) -> void:
	timer.start()

func _on_timer_timeout() -> void:
	movement_speed = 0
	
func _on_attach_radius_body_entered(body: Node2D) -> void:
	# Check if the body is a CharacterBody2D and not the player or self
	if not (body is CharacterBody2D and body != player and body != self):
		return
	# Prevent attaching to other slimes without the "attach" method
	if body.has_method("attach"):
		return
 	# If the body has "set_wander_position" and is not satisfied, attach it
	if body.has_method("set_wander_pos"):
		if not body.is_satisfied:
			attach(body)


func _on_damage_area_body_entered(body: Node2D) -> void: 
	if( body.has_method("reduce_health") and is_attached) or (body == player and not is_attached):
		body.reduce_health(1)
