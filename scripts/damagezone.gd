extends Area2D

@onready var player = get_node("/root/Game/Player")

var parent = get_parent()
func _ready():
	parent = get_parent()
func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body != player and body != parent:
		parent.is_attached = true
		print("Attached to " , body)
	if body.has_method("_on_interact"):
		body._on_interact()
		
	if body.has_method("reduce_health"):
		body.reduce_health(1)
	 
		 
	 
func _on_health_changed(new_value: int):
	print(new_value)
