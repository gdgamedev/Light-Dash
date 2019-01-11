extends Node

var pause = false

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pause = !pause
		
		get_tree().paused = pause

