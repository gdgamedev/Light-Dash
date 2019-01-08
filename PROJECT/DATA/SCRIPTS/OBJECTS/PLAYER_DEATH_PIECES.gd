extends RigidBody2D

func _on_LIFETIME_timeout():
	$"ANIM".play("fade_out")
	pass # replace with function body

func _on_ANIM_animation_finished(anim_name):
	self.queue_free()
	pass # replace with function body
