extends StaticBody2D

export (bool) var disable_on_dash = false
var disabled = false

func _ready():
	$"ANIM".play("pulse")

func _process(delta):
	if disabled:
		self.modulate.a = 0.1

func _on_ANIM_animation_finished(anim_name):
	if anim_name == "ULTRA_PULSE":
		$"ANIM".play("pulse")
	pass # replace with function body
