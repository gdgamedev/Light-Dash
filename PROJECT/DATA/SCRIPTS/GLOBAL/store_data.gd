extends Node

#data é um dicionário de valores que pode ser usado em qualquer cena em qualquer node
var data = {
	"player_color" : Color(1.0, 1.0, 1.0, 1.0)
	}

#users é um array com os usuários carregados
var users = [
]

#usuário atual
var user = ""

#máximo de usuários
var max_users = 3

func _ready():
	load_profiles()

#função para salvar o perfil
func save_profile():
	#classe de diretório
	var dir = Directory.new()
	
	#caso o diretório do perfil não exite
	if not dir.dir_exists("user://" + user):
		
		#cria o diretório
		dir.make_dir("user://" + user)
	
	#classe de arquivo
	var file = File.new()
	
	#abre o arquivo na localização
	file.open("user://" + user + "/save.dat", File.WRITE)
	
	#salva a data
	file.store_var(data)
	
	#fecha o arquivo
	file.close()
	
	pass

#função para carregar perfis
func load_profiles():
	#usuários carregados
	var loaded_users = []
	
	#insere o nome "new" para espaços não carregados
	for i in max_users:
		loaded_users.insert(i, "new")
	
	#classe de diretório
	var dir = Directory.new()
	
	#abre a pasta usuário
	dir.open("user://")
	
	#começa a listar as pastas no diretório
	dir.list_dir_begin()
	
	#id do arquivo atual
	var current_file = 0
	
	#loop simples para listar as pastas
	while true:
		
		#classe de arquivo
		var file = dir.get_next()
		
		#caso o arquivo atual for nulo
		if file == "":
			
			#quebra o loop
			break
			
		#e caso o arquivo não começar com . (arquivo oculto)
		elif not file.begins_with("."):
			
			#caso o número de arquivos carregados não for maior que o número máximo de usuários
			if not current_file > max_users - 1:
				
				#carrega o nome do arquivo
				loaded_users[current_file] = file
			
			#próximo arquivo
			current_file += 1
			
			#caso o arquivo atual for maior que o número máximo de usuários
			if current_file > max_users:
				
				#remove a pasta
				dir.remove("user://" + file)
	
	for i in loaded_users.size():
		if loaded_users[i] != "new":
			loaded_users[i] = {
				"username" : loaded_users[i],
				"data" : load_profile(loaded_users[i])
			}
		else:
			loaded_users[i] = {
				"username" : "new",
				"data" : data.duplicate()
			}
	
	users = loaded_users
	
#função para carregar o perfil selecionado
func load_profile(profile_name):
	#classe de diretório
	var dir = Directory.new()
	
	if not dir.dir_exists("user://" + profile_name):
		print("load data error")
		print("the profile" + profile_name + "don't exist")
		print("verify the profile name")
		return
	
	#classe de arquivo
	var file = File.new()
	
	#caso o arquivo não existe
	if not file.file_exists("user://" + profile_name + "/save.dat"):
		#print do erro
		print("load data error")
		print("the profile" + profile_name + "is corrupted, please delete it")
		print("and create another profile")
		#retorna para não dar erro no jogo depois
		return
	
	#abre o arquivo na localização
	file.open("user://" + profile_name + "/save.dat", File.READ)
	
	#carrega a data
	return file.get_var()
	
	#fecha o arquivo
	file.close()
	
	pass

