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
var H_MAX_SPD = 1500.0
#velocidade máxima horizontal
var V_MAX_SPD = 1500.0
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

#cor atual
var morph_col = 0

#warp
var warp = false

#chamado quando iniciar
func _ready():
	load_assets()
	
	#trail
	match start_morph:
		0:
			$"TRAILS/NORMAL".emitting = true
		1:
			$"TRAILS/ROCKET".emitting = true

#chamado todo frame
func _process(delta):
	if warp and get_node("MORPH_ANIM").current_animation != 'morph_anim' and can_move:
		can_move = false
		$"CAM/ANIM".play("warp")
		$"..".get_node("GUI/TRANSITION/ANIM").play("fade_in")
	
	
	$"TRAILS".modulate = $"SPR".modulate
	$"MORPH_PART".modulate = $"SPR".modulate
	$"MORPH/MORPH".modulate = $"SPR".modulate
	
	$"MORPH_PART".speed_scale = 3.5 * (1 / Engine.time_scale)
	
	if $"..".get_node("GUI/TRANSITION").color.a <= 0.1 and Input.is_action_just_pressed("ui_accept"):
		warp = true
		#$"CAM/ANIM".play("warp")
		
		$"..".get_node("GUI/GAME_START").play("start")
		
		get_node("COLOR_TW").interpolate_property(
			$"SPR",
			"modulate",
			$"SPR".modulate,
			Color(0.0, 0.97647058823529411764705882352941, 1.0, 1.0),
			1,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN)
		get_node("COLOR_TW").start()
		
		get_node("MORPH_ANIM").play("morph_anim")
		morph = 0
		
		#$"..".get_node("GUI/TRANSITION/ANIM").play("fade_in")
		pass
	
	if can_move:
		if morph == 0:
			move_normal(delta)
		elif morph == 1:
			move_rocket(delta)
	
	

#função para carregar elementos antes de serem usados
func load_assets():
	preload("res://DATA/SCENES/EFFECTS/SHOCKWAVE.tscn")
	preload("res://DATA/SCENES/OBJECTS/PLAYER_DEATH_PIECES.tscn")
	pass
	
#função para calcular e mover o player no morph normal
func move_normal(delta):
	get_node("SPR").texture = preload("res://DATA/SPRITES/PLAYER.png")
	
	#move o player com a velocidade atual
	move_and_slide(Vector2(H_MAX_SPD, 0), Vector2(0, -1))
	pass

#função para calcular e mover o player no morph foguete
func move_rocket(delta):
	get_node("SPR").texture = preload("res://DATA/SPRITES/PLAYER_ROCKET.png")
	
	#move e desliza
	move_and_slide(Vector2(H_MAX_SPD, 0))
	pass

#caso o morph acabar
func _on_MORPH_ANIM_animation_finished(anim_name):
	match morph:
		0:
			$"TRAILS/NORMAL".emitting = true
		1:
			$"TRAILS/ROCKET".emitting = true
	pass # replace with function body
