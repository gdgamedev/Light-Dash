extends CanvasLayer

#perfil selecionado
var select_profile = -1

#sinal
signal transition_finished()

#chamado todo frame
func _process(delta):
	if store_data.users != [] and not $"PROFILES/CONT/LIST".has_node("PROFILE0"):
		load_profiles()
	select_profile()
	
	change_profile_settings()
	if Input.is_action_just_pressed("ui_accept") and $"PROFILES".modulate.a == 0 and $"TRANSITION".color.a == 0:
		$"PROFILES/PROFILE_LOAD".play("fade")
		$"PRESS_START/ANIM".stop()
		$"PRESS_START".hide()

#função simples para carregar os perfis
func load_profiles():
	var current_user = 0
	for i in store_data.max_users:
		var profile = preload("res://DATA/SCENES/MISC/MAIN_MENU/PROFILE.tscn").instance()
		
		profile.get_node("BUTTON/PROFILE_NAME").text = store_data.users[current_user].username
		profile.name = "PROFILE" + str(current_user)
		profile.get_node("BUTTON/PROFILE_COLOR").color = store_data.users[current_user].data.player_color
		
		$"PROFILES/CONT/LIST".add_child(profile)
		
		current_user += 1

#caso a animação acabar
func _on_ANIM_animation_finished(anim_name):
	if anim_name == "fade_in":
		emit_signal("transition_finished")
	pass # replace with function body

#função para selecionar um perfil
func select_profile():
	for i in get_node("PROFILES/CONT/LIST").get_child_count():
		
		if select_profile == -1 and get_node("PROFILES/CONT/LIST/PROFILE" + str(i) + "/BUTTON").is_hovered() and Input.is_action_just_pressed("mouse_click"):
			select_profile = i
			$"PROFILES/PROFILE_LOADED/ANIM".play("OPEN_PROFILE")
			$"PROFILES/PROFILE_LOADED/PROFILE_NAME".text = store_data.users[i].username
			
			$"PROFILES/PROFILE_LOADED/PLAYER_COLOR/R".value = store_data.users[select_profile].data.player_color.r * 100
			$"PROFILES/PROFILE_LOADED/PLAYER_COLOR/G".value = store_data.users[select_profile].data.player_color.g * 100
			$"PROFILES/PROFILE_LOADED/PLAYER_COLOR/B".value = store_data.users[select_profile].data.player_color.b * 100
			
			
#para voltar na lista de perfis
func _on_BUTTON_pressed():
	$"PROFILES/PROFILE_LOADED/ANIM".play("CLOSE_PROFILE")
	select_profile = -1
	pass # replace with function body

#muda as configurações do perfil
func change_profile_settings():
	var _r = float($"PROFILES/PROFILE_LOADED/PLAYER_COLOR/R".value) / $"PROFILES/PROFILE_LOADED/PLAYER_COLOR/R".max_value
	var _g = float($"PROFILES/PROFILE_LOADED/PLAYER_COLOR/G".value) / $"PROFILES/PROFILE_LOADED/PLAYER_COLOR/G".max_value
	var _b = float($"PROFILES/PROFILE_LOADED/PLAYER_COLOR/B".value) / $"PROFILES/PROFILE_LOADED/PLAYER_COLOR/B".max_value
	
	$"PROFILES/PROFILE_LOADED/PLAYER_COLOR/COL".color = Color(_r, _g, _b, 1.0)
	
	pass

#começa o jogo
func _on_START_pressed():
	store_data.data.player_color = $"PROFILES/PROFILE_LOADED/PLAYER_COLOR/COL".color
	
	store_data.user = $"PROFILES/PROFILE_LOADED/PROFILE_NAME".text
	
	$"../PLAYER_DEMO".game_start()
	$"PROFILES/PROFILE_LOAD".play("out")
	
	store_data.save_profile()
	pass # replace with function body