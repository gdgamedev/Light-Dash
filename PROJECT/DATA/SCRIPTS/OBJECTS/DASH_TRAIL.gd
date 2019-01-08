extends Line2D

export (float) var mod_alpha = 1.0

func _ready():
	$"ANIM".play("fade")

func _process(delta):
	modulate.a = mod_alpha

func _on_ANIM_animation_finished(anim_name):
	self.queue_free()
	pass # replace with function body
