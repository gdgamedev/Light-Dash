extends Node

#velocidade do jogo
var game_speed = 1

#variáveis para mudar a velocidade do jogo
var END_VALUE = 1

var is_active = false
var time_start
var duration_ms
var start_value

#chamado quando iniciado
func _ready():
	display_message()
	pass

#função para exibir mensagem
func display_message():
	print("")
	print("")
	print("")
	print("------------------------------------------ATENTION!!---------------------------------------------------------")
	print("")
	print("--ENGLISH--")
	print("")
	print("hello user, this window will be used to display what is happening in-game (please don't close it),")
	print("if somehow you found a bug, please see the messages that is displaying and")
	print("report on the issue tab of the GitHub: https://github.com/gdgamedev/Light-Dash/issues")
	print("this window will be remove in next major update, replacing for log files.")
	print("")
	print("thanks! =)")
	print("")
	print("ASS: Gabriel Henrique")
	print("")
	print("")
	print("------------------------------------------ATENÇÃO!!----------------------------------------------------------")
	print("")
	print("--PORTUGUÊS--")
	print("")
	print("olá usuário, essa janela vai ser usado para mostrar o que está acontecendo no jogo (por favor não feche-o),")
	print("se de alguma forma você encontrou um bug, por favor veja as mensagens que estão")
	print("aparecendo e reporte-o na aba de problemas no GitHub: https://github.com/gdgamedev/Light-Dash/issues")
	print("essa janela será removida no próximo grande atualização, substituindo por arquivos de log.")
	print("")
	print("obrigado! =)")
	print("")
	print("ASS: Gabriel Henrique")
	print("")
	print("-------------------------------------------------------------------------------------------------------------")
	print("")
	print("")
	print("")

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






