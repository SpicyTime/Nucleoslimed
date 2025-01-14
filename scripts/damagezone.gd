extends Area2D

@onready var player = get_node("/root/Game/Player")



func _on_body_entered(body: Node2D) -> void:
	if body.has_method("reduce_health"):
		pass
		#body.reduce_health(1)
		 
	 
func _on_health_changed(new_value: int):
	print(new_value)
