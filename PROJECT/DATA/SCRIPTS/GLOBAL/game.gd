extends Node

#velocidade do jogo
var game_speed = 1

#variáveis para mudar a velocidade do jogo
var END_VALUE = 1

var is_active = false
var time_start
var duration_ms
var start_value

func _ready():
	OS.window_maximized = true

#função para mudar a velocidade do jogo
func change_game_spd(duration = 0.4, strength = 0.9):
	time_start = OS.get_ticks_msec()
	duration_ms = duration * 1000
	start_value = 1 - strength
	Engine.time_scale = start_value
	is_active = true

#chamado todo frame
func _process(delta):
	if is_active:
		var current_time = OS.get_ticks_msec() - time_start
		var value = circl_ease_in(current_time, start_value, END_VALUE, duration_ms)
		if current_time >= duration_ms:
			is_active = false
			value = END_VALUE
		Engine.time_scale = value
	pass

#easing
# t: tempo atual
# b: valor inicial
# c: valor final
# d: duração
func circl_ease_in(t, b, c, d):
	t /= d
	return -c * (sqrt(1 - t * t) - 1) + b






