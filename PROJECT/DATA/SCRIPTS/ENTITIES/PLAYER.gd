extends KinematicBody2D

#morph atual
var morph = 0

#posição de origem
var start_point = Vector2(0, 0)
#morph de origem
var start_morph = 0

#morph normal
#aceleração
var ACC = 2000.0
#velocidade máxima horizontal
var H_MAX_SPD = 2500.0
#velocidade máxima horizontal
var V_MAX_SPD = 2500.0
#fricção
var FRICTION = 500.0
#gravidade
var GRV = 1000.0
#força do pulo
var JUMP_FORCE = 800.0
#velocidade
var SPD = Vector2(0, 0)
#velocidade inicial
var START_SPD = Vector2(0, 0)
#número de dashes que pode usar
var dash = 1
#está morto
var die = false
#pode se mover
var can_move = true
#range do alvo de dash
var aim_dash_range = 1000
#alvo do dash
var dash_target = null
#direção
var face = 1

#morph foguete
#motion
var motion = Vector2(0, 0)
#velocidade de rotação
var rot_spd = 0
#velocidade máxima de rotação
var max_rot_spd = 8
#fricção da rotação
var rot_spd_fric = 5
#aceleração
var rot_spd_acc = 10
#direção
var dir = Vector2(1, 0)
#direção primária
var prim_dir = Vector2(1, 0)
#direção inicial
var start_dir = Vector2(1, 0)

#chamado quando iniciar
func _ready():
	get_node("MORPH/MORPH").modulate = get_node("SPR").modulate
	get_node("MORPH_PART").modulate = get_node("SPR").modulate
	load_assets()
	spawnpoint()
	
	#trail
	match start_morph:
		0:
			$"TRAILS/NORMAL".emitting = true
		1:
			$"TRAILS/ROCKET".emitting = true

#chamado todo frame
func _process(delta):
	$"MORPH_PART".speed_scale = 3.5 * (1 / Engine.time_scale)
	
	if Input.is_action_just_pressed("die") and die == false and can_move:
		die()
	if die and Engine.time_scale == 1 and Input.is_action_just_pressed("restart"):
		respawn()
	if not die and can_move:
		if morph == 0:
			move_normal(delta)
		elif morph == 1:
			move_rocket(delta)

#função para carregar elementos antes de serem usados
func load_assets():
	preload("res://DATA/SCENES/EFFECTS/SHOCKWAVE.tscn")
	preload("res://DATA/SCENES/OBJECTS/PLAYER_DEATH_PIECES.tscn")
	pass
	
#função para o dash
func dash(dir):
	#caso o alvo do dash for nulo
	if dash_target == null and dash > 0:
		#diminui o dash
		dash -= 1
		#aumenta a velocidade baseado na direção
		SPD.x = (H_MAX_SPD * 2 * game.game_speed) * dir
		SPD.y = -200 * game.game_speed
	#senão
	elif dash_target != null:
		#animação do node de dash
		dash_target.get_node("ANIM").play("ULTRA_PULSE")
		
		#cria uma linha
		var line = preload("res://DATA/SCENES/OBJECTS/DASH_TRAIL.tscn").instance()
		#pontos
		var points = [dash_target.position, position]
		line.modulate = $"SPR".modulate
		line.points = points
		$"../../PART".add_child(line)
		
		#pega a direção normalizada
		dir = (dash_target.global_position - global_position).normalized()
		#muda a velocidade para a direção muliplicada por 2000
		SPD = dir * Vector2(1500, 1500) * Vector2(game.game_speed, game.game_speed)
		#muda a localização
		global_position = dash_target.global_position
		dash = 1
		pass
	pass

#função para calcular e mover o player no morph normal
func move_normal(delta):
	#rotação
	rotation_degrees = 0
	
	#camera
	$"CAM".rotating = true
	
	#sprite
	get_node("SPR").texture = preload("res://DATA/SPRITES/PLAYER.png")
	
	#movimentação horizontal
	#inputs
	var left = Input.is_action_pressed("left")
	var right = Input.is_action_pressed("right")
	var jump = Input.is_action_just_pressed("jump")
	
	#zerar a velocidade vertical caso encostar no teto
	if is_on_ceiling():
		SPD.y = -10
	
	#zerar a velocidade horizontal caso encostar na parede
	if is_on_wall():
		SPD.x = 10 * -face
		#caso o botão pulo for pressionado, irá dar um pulo na parede
		if not is_on_floor():
			#if left and jump:
			#	SPD.x = JUMP_FORCE / 2
			#	SPD.y = -JUMP_FORCE / 1.1
			#elif right and jump:
			#	SPD.x = -JUMP_FORCE / 2
			#	SPD.y = -JUMP_FORCE / 1.1
			if jump:
				SPD.x = (JUMP_FORCE / 2) * -face
				SPD.y = -JUMP_FORCE / 1.1
	
	#movimentação para esquerda
	if left:
		face = -1
		if SPD.x > -H_MAX_SPD * game.game_speed:
			SPD.x -= ACC * delta * game.game_speed
	
	#movimentação para direita
	if right:
		face = 1
		if SPD.x < H_MAX_SPD * game.game_speed:
			SPD.x += ACC * delta * game.game_speed
	
	#caso nem o botão para direita e nem para esquerda é pressionado, aplica fricção
	if( not left and not right ) or SPD.x > H_MAX_SPD * game.game_speed or SPD.x < -H_MAX_SPD * game.game_speed:
		if SPD.x > 0:
			SPD.x -= FRICTION * delta * game.game_speed
			if SPD.x < 0:
				SPD.x = 0
		
		if SPD.x < 0:
			SPD.x += FRICTION * delta * game.game_speed
			if SPD.x > 0:
				SPD.x = 0
		
		pass
	
	#movimentação vertical
	#gravidade
	if SPD.y < V_MAX_SPD * game.game_speed:
		SPD.y += (GRV * game.game_speed) * delta
		if SPD.y > V_MAX_SPD * game.game_speed:
			SPD.y = V_MAX_SPD * game.game_speed
	
	#caso estiver no ar
	if not is_on_floor() and not is_on_wall() and jump:
		#dash
		dash(face)
	
	#zerar a velocidade vertical caso encostar no chão
	if is_on_floor():
		dash = 1
		SPD.y = 10
	
	#ação de pulo
	if is_on_floor() and jump:
		SPD.y = -JUMP_FORCE * game.game_speed
	
	#move o player com a velocidade atual
	move_and_slide(SPD, Vector2(0, -1))
	
	#dash
	aim_dash()
	pass

#função para calcular e mover o player no morph foguete
func move_rocket(delta):
	#camera
	$"CAM".rotating = false
	
	#sprite
	get_node("SPR").texture = preload("res://DATA/SPRITES/PLAYER_ROCKET.png")
	
	#inputs
	var up = Input.is_action_pressed("up")
	var down = Input.is_action_pressed("down")
	var left = Input.is_action_pressed("left")
	var right = Input.is_action_pressed("right")
	
	#horizontal
	if left:
		prim_dir.x = -1
	if right:
		prim_dir.x = 1
	if (right or left) and not (up or down):
		prim_dir.y = 0
	
	#vertical
	if up:
		prim_dir.y = -1
	if down:
		prim_dir.y = 1
	if (up or down) and not (left or right):
		prim_dir.x = 0
	
	#caso o movimento for inverso da velocidade, para evitar mudança brusca de direção
	if (dir.y > -1 and dir.y < 1) and ( ( dir.x > 0 and prim_dir.x < 0 ) or (dir.x < 0 and prim_dir.x > 0) ):
		prim_dir.y = prim_dir.x
	if (dir.x > -1 and dir.x < 1) and ( ( dir.y > 0 and prim_dir.y < 0 ) or (dir.y < 0 and prim_dir.y > 0) ):
		prim_dir.x = prim_dir.y
	
	#horizontal
	if dir.x < prim_dir.x:
		dir.x += 10 * delta
		if dir.x > prim_dir.x:
			dir.x = prim_dir.x
	if dir.x > prim_dir.x:
		dir.x -= 10 * delta
		if dir.x < prim_dir.x:
			dir.x = prim_dir.x
	
	#vertical
	if dir.y < prim_dir.y:
		dir.y += 10 * delta
		if dir.y > prim_dir.y:
			dir.y = prim_dir.y
	if dir.y > prim_dir.y:
		dir.y -= 10 * delta
		if dir.y < prim_dir.y:
			dir.y = prim_dir.y
	
	#rotação
	look_at(global_position + dir)
	
	#boost
	if not Input.is_action_pressed("jump"):
		#motion
		motion = Vector2(H_MAX_SPD - 1000, 0).rotated(rotation)
		$"TRAILS/ROCKET".process_material.scale = 50
	else:
		#motion
		motion = Vector2(H_MAX_SPD - 100, 0).rotated(rotation)
		$"TRAILS/ROCKET".process_material.scale = 70
	
	#move e desliza
	move_and_slide(motion)
	pass

#spawnpoint
func spawnpoint():
	start_point = global_position
	start_morph = morph
	
	if start_morph == 0:
		START_SPD = SPD
	
	if start_morph == 1:
		start_dir = dir

#função para morrer
func die():
	#morre
	die = true
	#fica invisível
	$"SPR".hide()
	#desabilita o trail
	for i in $"TRAILS".get_children():
		i.emitting = false
	#desabilita a colisão
	$"COL".disabled = true
	#quantas partículas aparecem
	var qtd = math._rand(20, 50, false)
	
	game.change_game_spd(2, 0.9)
	
	#spawna as partículas
	for i in qtd:
		#tamanho
		var size = math._rand(0.5, 1, true)
		#cena
		var sc = preload("res://DATA/SCENES/OBJECTS/PLAYER_DEATH_PIECES.tscn").instance()
		#velocidade
		var velocity = Vector2(math._rand(-2000, 2000, true), math._rand(-2000, 2000, true))
		#velocidade
		sc.linear_velocity =velocity
		#cor
		sc.get_node("SPR").modulate = $"SPR".modulate
		#tamanho do sprite
		sc.get_node("SPR").scale *= size
		#tamanho da colisão
		sc.get_node("COL").scale *= size
		#posição
		sc.global_position = self.global_position + Vector2(math._rand(-32, 32, true), math._rand(-10, 10, true))
		#adicionar a cena
		$"../../PART".add_child(sc)
		pass
	
	#onda de choque
	#cena
	var _sc = preload("res://DATA/SCENES/EFFECTS/SHOCKWAVE.tscn").instance()
	#posição
	_sc.global_position = self.global_position
	$"../../SHD_EFFECTS".add_child(_sc)
	
	pass

#função para respawnar
func respawn():
	#retorna o morph inicial
	morph = start_morph
	#trail
	match start_morph:
		0:
			$"TRAILS/NORMAL".emitting = true
			SPD = START_SPD
		1:
			$"TRAILS/ROCKET".emitting = true
			dir = start_dir
			prim_dir = start_dir
	
	#volta para a posição inicial
	self.global_position = start_point
	#volta a ser visível
	$"SPR".show()
	#variável die falso
	die = false
	#colisão habilitada
	$"COL".disabled = false
	pass

#função para mira do dash
func aim_dash():
	#objetos no range da mira
	var aimable_obj_in_range = 0
	#caso estiver no ar
	if not is_on_floor():
		#pega todos os nodes do grupo
		for i in get_tree().get_nodes_in_group("aimable"):
			#calcula a distância até ele
			var dist = global_position.distance_to(i.global_position)
			#calcula o vetor x da distância
			var x_dist = (i.global_position - global_position).x
			if (x_dist < 0 and face < 0) or (x_dist > 0 and face > 0):
				#caso a distância estiver no range
				if dist <= aim_dash_range:
					#objetos no range da mira + 1
					aimable_obj_in_range += 1
					#caso o alvo for nulo
					if dash_target == null:
						#o alvo é o node
						dash_target = i
					#senão
					else:
						#calcula a distância a distância até o node já alvo
						var dist_2 = global_position.distance_to(dash_target.global_position)
						#e caso a distância do node for menor do que do alvo
						if dist < dist_2:
							#o alvo é o node
							dash_target = i
	#caso o números de objetos no range for 0
	if aimable_obj_in_range == 0:
		#o alvo é nulo
		dash_target = null
	
	#pega todos os nodes do grupo
	for i in get_tree().get_nodes_in_group("aimable"):
		#caso o alvo não for esse node
		if dash_target != i:
			#e caso tenha um node da mira
			if i.has_node("DASH_AIM"):
				#remove a mira
				i.remove_child(i.get_node("DASH_AIM"))
	#caso o alvo não for nulo
	if dash_target != null:
		#caso o node ainda não tenha a mira como filho
		if not dash_target.has_node("DASH_AIM"):
			#é adicionado a mira como filho
			var sc = preload("res://DATA/SCENES/OBJECTS/DASH_AIM.tscn").instance()
			dash_target.add_child(sc)
		pass

#caso um corpo entrar na Area2D
func _on_AREA_body_entered(body):
	if body.is_in_group("THORN"):
		die()
	pass # replace with function body

#caso o morph acabar
func _on_MORPH_ANIM_animation_finished(anim_name):
	match morph:
		0:
			$"TRAILS/NORMAL".emitting = true
		1:
			$"TRAILS/ROCKET".emitting = true
	pass # replace with function body
