extends CanvasLayer

#sinal
signal transition_finished()

#caso a animação acabar
func _on_ANIM_animation_finished(anim_name):
	if anim_name == "fade_in":
		emit_signal("transition_finished")
	pass # replace with function body
