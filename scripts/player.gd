extends CharacterBody2D

@export var movement_speed: float = 100
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
var character_direction: Vector2
const MAX_HEALTH: int = 3
var health = MAX_HEALTH
var is_dead = false
var is_hit = false
var current_anim: String = "idle"
var is_active: bool = true
var interactable_bodies: Array[Node2D]
var in_damage_zone = false
func play_animation(anim: String):
	if current_anim == anim:
		return
	current_anim = anim
	animated_sprite.play(current_anim)

func handle_input():
	character_direction.x = Input.get_axis("move_left", "move_right")
	character_direction.y = Input.get_axis("move_up", "move_down")
	if Input.is_action_just_pressed("interact"):
		var closest_character: CharacterBody2D = null
		var shortest_distance = INF
		for character in interactable_bodies:
			if character and character is CharacterBody2D:
				if not is_instance_valid(character):
					interactable_bodies.erase(character)
					continue
				var distance = position.distance_to(character.global_position)
				if distance < shortest_distance:
					shortest_distance = distance
					closest_character = character
		if closest_character:
			if closest_character.has_method("_on_interact"):
				closest_character._on_interact()
 
func handle_animations():
	if is_dead:
		play_animation("death")
	elif is_hit:
		play_animation("hit")
	elif character_direction:
		play_animation("walk")
	else:
		play_animation("idle")

func reduce_health(damage: int):
	health -= damage
	is_hit = true
	if health <= 0:
		is_dead = true

func _physics_process(delta: float) -> void:
	if not is_active:
		return
	if is_dead:
		animated_sprite.play("death")
		return
	handle_input()
	character_direction = character_direction.normalized()
	if character_direction.x > 0:
		animated_sprite.flip_h = false
	elif character_direction.x < 0:
		animated_sprite.flip_h = true
	
	if character_direction:
		velocity = character_direction * movement_speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, movement_speed)
	handle_animations()
	move_and_collide(velocity * delta)

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "death":
		animated_sprite.queue_free()
		collision_shape.queue_free()
		is_active = false
		timer.start()
	elif animated_sprite.animation == "hit":
		is_hit = false

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()

func _on_interact_zone_body_entered(body: Node2D) -> void:
	if body.has_method("handle_interaction") and not body in interactable_bodies:
		interactable_bodies.append(body)
func _on_interact_zone_body_exited(body: Node2D) -> void:
	if body in interactable_bodies:
		interactable_bodies.erase(body)
