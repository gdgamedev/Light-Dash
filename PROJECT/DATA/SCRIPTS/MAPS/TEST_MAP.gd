extends Node

#chamado quando iniciado
func _ready():
	$"GUI/TRANSITION/ANIM".play("fade_out")
	pass

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused
