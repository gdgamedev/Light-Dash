extends Node

var pause = false 
var time = 0

#variáveis para mudar a velocidade do jogo
var END_VALUE = 1

var is_active = false
var time_start
var duration_ms
var start_value

func _process(delta):
	update_game_spd()

func pause(shader_node, music_node): #função para pausar o jogo
	pause = !pause 
	
	get_tree().paused = pause
	
	if pause:
		shader_node.get_node("TW").interpolate_property(
			shader_node.get_material(),
			"shader_param/blur_size",
			shader_node.get_material().get_shader_param("blur_size"),
			4,
			0.5,
			Tween.TRANS_SINE,
			Tween.EASE_OUT
		)
		shader_node.get_node("TW").start()
		
		music_node.get_node("ANIM").play("pause")
		
	else:
		shader_node.get_node("TW").interpolate_property(
			shader_node.get_material(),
			"shader_param/blur_size",
			shader_node.get_material().get_shader_param("blur_size"),
			0,
			0.5,
			Tween.TRANS_SINE,
			Tween.EASE_OUT
		)
		shader_node.get_node("TW").start()
		
		music_node.get_node("ANIM").play("resume")
	
	pass
	
func music_sync(shader_node, tile_map_node):
	
	
	var volume = (AudioServer.get_bus_peak_volume_right_db(0, 0) + 72 + AudioServer.get_bus_peak_volume_right_db(0, 0) + 72) / 2
	
	var vol_perc = stepify(volume / 72, 0.01) * 1
	
	tile_map_node.modulate.a = vol_perc
	
	pass

func random(_max, _min):
	randomize()
	return rand_range(_max, _min)

func add_effect(effect, pos):
	if effect == "shockwave":
		var sc = preload("res://DATA/SCENES/SHOCKWAVE.tscn").instance()
		sc.global_position = pos
		
		$"../EFFECTS".add_child(sc)

#função para mudar a velocidade do jogo
func change_game_spd(duration = 0.4, strength = 0.9):
	time_start = OS.get_ticks_msec()
	duration_ms = duration * 1000
	start_value = 1 - strength
	Engine.time_scale = start_value
	is_active = true
	
func update_game_spd():
	if is_active:
		var current_time = OS.get_ticks_msec() - time_start
		var value = circl_ease_in(current_time, start_value, END_VALUE, duration_ms)
		if current_time >= duration_ms:
			is_active = false
			value = END_VALUE
		Engine.time_scale = value
	pass

func load_map(dash_nodes_tilemap, dash_nodes_node):
	var dash_nodes = dash_nodes_tilemap.get_used_cells_by_id(0)
	var dash_nodes_dis = dash_nodes_tilemap.get_used_cells_by_id(1)
	
	for i in dash_nodes:
		var sc = preload("res://DATA/SCENES/DASH_NODE.tscn").instance()
		
		sc.global_position = dash_nodes_tilemap.map_to_world(i) + Vector2(8, 8)
		sc.name = "DASH_NODE"
		sc.disable_on_dash = false
		
		dash_nodes_node.add_child(sc)
		
		dash_nodes_tilemap.set_cellv(i, -1)
	
	for i in dash_nodes_dis:
		var sc = preload("res://DATA/SCENES/DASH_NODE.tscn").instance()
		
		sc.global_position = dash_nodes_tilemap.map_to_world(i) + Vector2(8, 8)
		sc.name = "DASH_NODE"
		sc.disable_on_dash = true
		
		dash_nodes_node.add_child(sc)
		
		dash_nodes_tilemap.set_cellv(i, -1)
	
func change_input_method(method):
	if method == 0:
		
		pass
	
	
	pass
	
	
	
#easing
# t: tempo atual
# b: valor inicial
# c: valor final
# d: duração
func circl_ease_in(t, b, c, d):
	t /= d
	return -c * (sqrt(1 - t * t) - 1) + b





