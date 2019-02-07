extends Node2D

export (int) var morph_id = 0

func _on_AREA_body_entered(body):
	if body.name == "PLAYER":
		if body.morph != morph_id:
			body.change_morph(morph_id)
		
	pass # replace with function body
