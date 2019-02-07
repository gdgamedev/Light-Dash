extends KinematicBody2D

export (float) var ACC = 1000.0 #aceleração
export (float) var MAX_SPD_H = 500.0 #velocidade máxima horizontal
export (float) var MAX_SPD_V = 100.0 #velocidade máxima vertical
export (float) var GRV = 300.0 #gravidade
export (float) var FRICTION = 800.0 #fricção
export (float) var JUMP_FORCE = 200.0 #força de pulo
export (float) var DASH_FORCE = 20000 #força do dash
export (float) var TURN_SPD = 1000 #velocidade do giro
export (float) var ROCKET_SPD = 1000 #velocidade do foguete
export (int) var trail_size = 100 #tamanho do trail
export (float) var DASH_NODE_RANGE = 150 #range dos dash nodes
export (Color) var _col = Color(1.0, 1.0, 1.0, 1.0)

var spd_mult = 1 #multiplicador de velocidade para uso opcional
var SPD = Vector2(0, 0) #velocidade do cubo
var spd = Vector2(0, 0) #velocidade do foguete
var face = 1 #direção
var dash = 1 #dash
var dash_node = null #dash node mirado
var start_point = Vector2() #ponto inicial
var morph = 0 #morph atual
var controls_node = null #node de controles
var joy_pos = Vector2()

var dead = false #está morto

func _ready():
	start_point = position

func aesthestic():
	get_node("SPR").modulate = _col
	get_node("TRAIL/LINE").modulate = _col
	
	
	pass

func move(delta):
	if morph == 0:
		move_normal(delta)
	elif morph == 1:
		move_rocket(delta)

func move_normal(delta): #função para mover normalmente o KinematicBody2D
	if not dead:
		var right = Input.is_action_pressed("right")
		var left = Input.is_action_pressed("left")
		var jump = Input.is_action_just_pressed("jump")
		
		if right: #muda a direção
			face = 1
		if left:
			face = -1
		
		if right and SPD.x < MAX_SPD_H * spd_mult: #caso direita
			SPD.x += ACC * delta * spd_mult #aplica aceleração
		if left and SPD.x > -MAX_SPD_H * spd_mult: #caso esquerda
			SPD.x -= ACC * delta * spd_mult #aplica aceleração
		
		if not is_on_floor() and SPD.y < MAX_SPD_V * spd_mult: #aplica gravidade
			SPD.y += GRV * delta * spd_mult
		
		if is_on_floor(): #anula a velocidade vertical caso encostar no chão
			SPD.y = 10
			dash = 1
		
		if is_on_ceiling(): #anula a velocidade vertical caso encostar no teto
			SPD.y = 10
		
		if is_on_floor() and jump: #ação do pulo
			SPD.y = -JUMP_FORCE * delta
		
		if is_on_wall(): #pulo na parede
			print("a")
		
			SPD.x = 10 * face
			if not is_on_floor() and jump:
				SPD.y = (-JUMP_FORCE / 1.2) * delta
				SPD.x = (JUMP_FORCE / 100) * -face
			
		if not right and not left: #caso não direita nem esquerda
			if SPD.x < 0: #caso a velocidade x for menor que 0
				SPD.x += FRICTION * delta #aplica fricção
				if SPD.x > 0: #caso velocidade x for maior que 0
					SPD.x = 0 #anula a velocidade
			if SPD.x > 0: #caso a velocidade x for menor que 0
				SPD.x -= FRICTION * delta #aplica fricção
				if SPD.x < 0: #caso velocidade x for maior que 0
					SPD.x = 0 #anula a velocidade
		
		if not is_on_floor(): #ação do dash
			if not is_on_wall():
				if jump:
					if dash_node == null and dash > 0:
						dash -= 1
						SPD.x = MAX_SPD_H * face
						
					elif dash_node != null:
						var dir = (dash_node.global_position - global_position).normalized()
						SPD = dir * DASH_FORCE * 30 * delta
						
						global_position = dash_node.global_position
						dash = 1
						
						if dash_node.disable_on_dash:
							dash_node.disabled = true
						
						pass

		SPD = move_and_slide(SPD, Vector2(0, -1)) #move e desliza
		
		jump = false
	pass

func move_rocket(delta): #função para mover como foguete o KinematicBody2D
	if not dead:

		var boost = Input.is_action_pressed("jump")
		
		$SPR.look_at($SPR.global_position + joy_pos)
		
		if not boost:
			spd = Vector2(ROCKET_SPD, 0).rotated($SPR.rotation)
		else:
			spd = Vector2(ROCKET_SPD * 1.5, 0).rotated($SPR.rotation)
		
		move_and_slide(spd)

	pass

func trail(trail_node, trail_pos): #função para o trail
	if not dead:
		trail_node.add_point(trail_pos.global_position)
	elif trail_node.points.size() > 0:
		trail_node.remove_point(0)
	while trail_node.get_point_count() > trail_size:
		trail_node.remove_point(0)
		
		pass
	
	
	pass

func cam(cam_node): #função para a câmera
	if morph == 0:
		cam_node.position = SPD / 4 #câmera dinâmica, vai um pouco a frente do player para ajudar a visualização dos obstáculos em alta velocidade
	elif morph == 1:
		cam_node.position = spd / 4 #câmera dinâmica, vai um pouco a frente do player para ajudar a visualização dos obstáculos em alta velocidade
	
	pass

func spd_ind(spd_node, motion_blur_node):
	var spd_perc = 0
	if morph == 0:
		spd_node.max_value = MAX_SPD_H
	
		var target_spd_x = 0
	
		if SPD.x < 0:
			target_spd_x = -SPD.x
			spd_perc = -SPD.x / MAX_SPD_H
		else:
		
			target_spd_x = SPD.x
			spd_perc = SPD.x / MAX_SPD_H
	
		spd_node.value = target_spd_x
	
	elif morph == 1:
		spd_node.max_value = ROCKET_SPD * 1.5
	
		var target_spd_x = 0
		
		spd_perc = 1
	
		spd_node.value = ROCKET_SPD * 1.5
	
	var motion_blur = spd_perc * 3
	
	motion_blur = clamp(motion_blur, 0, 3)
	
	motion_blur_node.get_material().set_shader_param("disp_size", motion_blur)

func change_morph(morph_id):
	morph = morph_id
	if morph_id == 0:
		if controls_node != null:
			controls_node._method = controls_node.method.button
		
		$"SPR".texture = preload("res://DATA/SPRITES/player.png")
		$"SPR".rotation_degrees = 0
		$"SPR/TRAIL_POS".position = Vector2(0, 0)
		
		SPD = spd
		
	elif morph_id == 1:
		if controls_node != null:
			controls_node._method = controls_node.method.joystick
		
		$"SPR".texture = preload("res://DATA/SPRITES/player_rocket.png")
		$"SPR/TRAIL_POS".position = Vector2(-7, 0)
		
		spd = SPD
		$"SPR".look_at($"SPR".global_position + spd.normalized())
		

func dash_node():
	#objetos no range da mira
	var aimable_obj_in_range = 0
	
	var dash_nodes = get_tree().get_nodes_in_group("DASH_NODE")
	
	if morph == 0 and not dead:
		#caso estiver no ar
		if not is_on_floor():
			#pega todos os nodes do grupo
			for i in dash_nodes:
				#caso o node não estiver desativado
				if not i.disabled:
					#calcula a distância até ele
					var dist = global_position.distance_to(i.global_position)
					#calcula o vetor x da distância
					var x_dist = (i.global_position - global_position).x
					
					if (x_dist < 0 and face < 0) or (x_dist > 0 and face > 0):
						#caso a distância estiver no range
						if dist <= DASH_NODE_RANGE:
							#objetos no range da mira + 1
							aimable_obj_in_range += 1
							#caso o alvo for nulo
							if dash_node == null:
								#o alvo é o node
								dash_node = i
							#senão
							else:
								#calcula a distância a distância até o node já alvo
								var dist_2 = global_position.distance_to(dash_node.global_position)
								#e caso a distância do node for menor do que do alvo
								if dist < dist_2:
									#o alvo é o node
									dash_node = i

	#caso o números de objetos no range for 0
	if aimable_obj_in_range == 0:
		#o alvo é nulo
		dash_node = null
	
	#pega todos os nodes do grupo
	for i in dash_nodes:
		#caso o alvo não for esse node
		if dash_node != i:
			#e caso tenha um node da mira
			if i.get_node("ANIM").current_animation == "rotation" or i.get_node("ANIM").current_animation == "aim":
				#remove a mira
				i.n_aim()
				
	#caso o alvo não for nulo
	if dash_node != null:
		#caso o node ainda não tenha a mira como filho
		if not dash_node.get_node("ANIM").current_animation == "rotation" and not dash_node.get_node("ANIM").current_animation == "aim":
			#é adicionado a mira como filho
			dash_node.aim()

func die():
	$"../CONTROL".add_effect("shockwave", global_position)
	$"../CONTROL".change_game_spd(1, 0.9)
	
	$"SPR".hide()
	
	dead = true
	
	SPD = Vector2(0, 0)

func restart():
	dead = false
	position = start_point
	
	$"SPR".show()
	




