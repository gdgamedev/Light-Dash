extends BackBufferCopy

func _ready():
	$"ANIM".play("shock")
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _on_ANIM_animation_finished(anim_name):
	self.queue_free()
	pass # replace with function body
