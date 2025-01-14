extends Node

var tasks: Array[String] = ["Cleanup", "Encourage", "Fix"]
@export var task_id: String
# Called when the node enters the scene tree for the first time.
var rng = RandomNumberGenerator.new()
func pick_task():
	var rand_task:int = rng.randf_range(0, tasks.size())
	return tasks[rand_task]
