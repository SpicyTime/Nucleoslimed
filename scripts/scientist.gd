extends CharacterBody2D

@onready var mask: AnimatedSprite2D = $Mask
@onready var anim: AnimatedSprite2D = $Mask/Anim
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var task = $Task
@onready var label: Label = $Label
@export var movement_speed = 80
@export var bounds: Array[int] = [-190, 190, -128, 128]
@export var wait_time: float = 2.5
@onready var player: CharacterBody2D = get_node("%Player")  # Use get_node() in 4.x
var current_task: String
var is_dead: bool = false
var is_hit: bool = false
const MAX_HEALTH: int = 3
var health: int = MAX_HEALTH
var wander_position: Vector2
var waiting: bool = false
var current_animation: String = "idle"
var is_satisfied: bool = false
var is_interacting: bool = false
func handle_interaction():
	is_satisfied = true
	label.text = "Satisfied"
	#is_interacting = true
	#print("Scientist is being interacted with")

func reduce_health(damage: int):
	health -= damage
	is_hit = true
	current_animation = "hit"
	if health <= 0:
		is_dead = true
		current_animation = "death"

func set_wander_pos() -> void:
	var rng = RandomNumberGenerator.new()
	var rand_x: int = rng.randf_range(bounds[0], bounds[1])
	var rand_y: int = rng.randf_range(bounds[2], bounds[3])
	wander_position = Vector2(rand_x, rand_y)
	waiting = false

func handle_animations() -> void:
	if current_animation == "death" or current_animation == "hit":
		play(current_animation)
	elif abs(velocity.x) > 0 or abs(velocity.y) > 0:
		current_animation = "walk"
		play("walk")
	else:
		current_animation = "idle"
		play("idle")

func play(animation: String) -> void:
	if mask.sprite_frames.has_animation(animation) and anim.sprite_frames.has_animation(animation):
		mask.play(animation)
		anim.play(animation)

func handle_flip(direction):
	if direction.x > 0:
		mask.flip_h = false
		anim.flip_h = false
	if direction.x < 0:
		mask.flip_h = true
		anim.flip_h = true

func wait_at_point() -> void:
	if is_satisfied:
		print("freeing by satisfaction")
		queue_free()
		return
	waiting = true
	
	await get_tree().create_timer(wait_time).timeout
	set_wander_pos()

func _ready() -> void:
	set_wander_pos()
	current_task = task.pick_task()
	label.text = current_task
func _process(_f):
	if is_satisfied:
		waiting = false
		is_interacting = false
		wander_position = Vector2(-250, -250)
func _physics_process(delta: float) -> void:
	var direction = (wander_position - global_position).normalized()
	if not waiting and not is_interacting:
		if global_position.distance_to(wander_position) < 2:
			velocity = Vector2()
			wait_at_point()
		else:
			velocity = direction * movement_speed
	else:
		velocity = Vector2()
	handle_flip(direction)
	handle_animations()
	move_and_collide(velocity * delta)

func _on_anim_animation_finished() -> void:
	if anim.animation == "death":
		queue_free()
	elif anim.animation == "hit":
		is_hit = false
		current_animation = "idle"

func _on_interact() -> void:
	handle_interaction()
func interact():
	pass
