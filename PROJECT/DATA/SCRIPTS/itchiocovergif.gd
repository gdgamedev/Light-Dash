extends Node

func _ready():
	get_node("GUI").get_node("TRANSITION/ANIM").play("fade_out")

func _process(delta):
	$"AMBIENT".position = $"PLAYER_DEMO".position

func _on_GUI_transition_finished():
	get_tree().change_scene("res://DATA/SCENES/MAPS/HUB.tscn")
	pass # replace with function body
