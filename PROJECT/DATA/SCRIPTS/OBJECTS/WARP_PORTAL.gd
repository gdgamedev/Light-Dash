extends Node2D

#cena para teleportar o player
export (int) var scene_id = 0
#player
var player = null
#warp
var warp = false

#chamado quando iniciado
func _ready():
	$"ANIM".play("ROTATION")

#chamado todo frame
func _process(delta):
	#nome da fase
	$"LVL_NAME".text = warps.warp[scene_id].warp_name
	
	#caso o player não for nulo
	if player != null and not warp:
		#caso o player não estiver morto e interagir
		if not player.die and Input.is_action_just_pressed("interact"):
			#diminui o tempo
			game.change_game_spd(2, 0.8)
			#spawna a onda de choque
			var sc = preload("res://DATA/SCENES/EFFECTS/SHOCKWAVE.tscn").instance()
			sc.global_position = player.global_position
			$"../../SHD_EFFECTS".add_child(sc)
			
			#warp
			warp = true
			#player não se move
			player.can_move = false
			#muda a posição global do player
			player.global_position = global_position
			
			#esconde o player
			player.get_node("SPR").hide()
			for i in player.get_node("TRAILS").get_children():
				i.emitting = false
			
			#timer
			$"WARP_TIME".wait_time = 1
			$"WARP_TIME".start()
			
	#caso o player não for nulo e morrer
	if (player != null and player.die) or warp:
		#muda o texto de ação
		player.get_node("ACTION").text = ""

#warp
func warp():
	if warp == true:
		pass
	pass

#caso o player entrar na Area2D
func _on_AREA_body_entered(body):
	if body.name == "PLAYER":
		player = body
		player.get_node("ACTION").text = "E"
		$"LVL_NAME/ANIM".play("in")
	pass # replace with function body
	
#caso o player sair da Area2D
func _on_AREA_body_exited(body):
	if body.name == "PLAYER":
		player.get_node("ACTION").text = ""
		player = null
		$"LVL_NAME/ANIM".play("out")
	pass # replace with function body

#caso o tempo acabar
func _on_WARP_TIME_timeout():
	$"../../GUI/TRANSITION/ANIM".play("fade_in")
	player.get_node("CAM/ANIM").play("warp")
	pass # replace with function body

#teleporta para a cena
func _on_GUI_transition_finished():
	get_tree().change_scene(warps.warp[scene_id].sc)
	pass # replace with function body
