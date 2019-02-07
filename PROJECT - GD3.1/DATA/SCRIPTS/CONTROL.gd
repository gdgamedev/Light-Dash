extends "res://DATA/SCRIPTS/classes/CONTROL_CLASS.gd"

func _ready():
	save()
	load_map($"../DASH_NODES_", $"../DASH_NODES")

func _process(delta):

	
	music_sync($"../GUI/SHADERS/SHADER", $"../TILE_MAP")
	if Input.is_action_just_pressed("pause"):
		pause($"../GUI/SHADERS/SHADER", $"../MUSIC")
	
	pass

func save(): #para fins de testes
	var dir = Directory.new()
	var root_path = str(OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS))
	
	dir.open(root_path)
	
	if not dir.dir_exists("My Games"):
		dir.make_dir("My Games")
	
	root_path += "/My Games"
	
	dir.open(root_path)
	
	if not dir.dir_exists("SIMPLE GFX"):
		dir.make_dir("SIMPLE_GFX")
	
	root_path += "/SIMPLE_GFX"
	
	dir.open(root_path)
	
	if not dir.dir_exists("LIGHT DASH"):
		dir.make_dir("LIGHT DASH")
	
	root_path += "/LIGHT DASH"
	
	dir.open(root_path)
	
	
	pass








