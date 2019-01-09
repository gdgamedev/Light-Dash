extends Node2D

#id do morph
export (int) var morph_id = 0

func _on_AREA_body_entered(body):
	if body.name == "PLAYER" and body.morph != morph_id:
		if morph_id == 0:
			body.SPD = body.dir * body.H_MAX_SPD
		
		if morph_id == 1:
			body.dir = body.SPD.normalized()
			body.prim_dir = body.SPD.normalized()
		
		body.get_node("MORPH_ANIM").play("morph_anim")
		body.get_node("CAM/ANIM").play("change_morph")
		game.change_game_spd(2, 0.9)
		body.morph = morph_id
		
		body.spawnpoint()
		
		#mudar a cor
#		var col = body.morph_col
#
#		if col == 2:
#			body.get_node("CHANGE_COLOR").play("G_B")
#			body.morph_col = 0
#		elif col == 1:
#			body.get_node("CHANGE_COLOR").play("R_G")
#			body.morph_col = 2
#		elif col == 0:
#			body.get_node("CHANGE_COLOR").play("B_R")
#			body.morph_col = 1
		
		
		
	pass # replace with function body
	
	
