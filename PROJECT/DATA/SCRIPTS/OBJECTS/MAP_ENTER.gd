extends Node2D

onready var p_sc = preload("res://DATA/SCENES/ENTITIES/PLAYER.tscn")

func _ready():
	$"PART/ANIM".play("spawn")
	pass

#spawna o player
func _on_ANIM_animation_finished(anim_name):
	$"KILL_TIME".wait_time = $"PART".lifetime + 1
	
	$"KILL_TIME".start()
	
	var p = p_sc.instance()
	
	p.get_node("CAM").current = true
	
	remove_child($"CAM")
	
	p.global_position = global_position
	
	$"../PLAYER".add_child(p)
	
	pass # replace with function body

func _on_KILL_TIME_timeout():
	self.queue_free()
	pass # replace with function body
