extends CharacterBody2D
@onready var damagezone: Area2D = $damagezone
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = get_node("/root/Game/Player")
@export var movement_speed: float = 0
@onready var timer: Timer = $VisionArea/Timer
var character_direction: Vector2
var target: CharacterBody2D
var is_attached: bool = false
func _physics_process(delta: float) -> void:
	var direction: Vector2
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
	target = body
	timer.stop()

func _on_vision_area_body_exited(_body: Node2D) -> void:
	timer.start()

func _on_timer_timeout() -> void:
	movement_speed = 0
	
	 
