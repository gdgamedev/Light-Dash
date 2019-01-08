extends StaticBody2D

func _ready():
	$"ANIM".play("pulse")

func _on_ANIM_animation_finished(anim_name):
	if anim_name == "ULTRA_PULSE":
		$"ANIM".play("pulse")
	pass # replace with function body
