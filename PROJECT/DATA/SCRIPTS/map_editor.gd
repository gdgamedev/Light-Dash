extends Node2D

#tileset normal
onready var normal_tile = $"TILE_MAP"
#tileset de espinhos
onready var thorn_tile = $"THORN"
#câmera
onready var cam = $"VIEW"

#posição
var pos = Vector2(0, 0)

#bloco a editar
var block_indx = 0

#chamado quando iniciado
func _ready():
	set_process_input(true)

#input
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			if event.is_pressed() and block_indx < 2 and not Input.is_action_pressed("zoom"):
				block_indx += 1
			elif event.is_pressed() and Input.is_action_pressed("zoom"):
				$"VIEW".zoom += Vector2(1, 1)
				
		if event.button_index == BUTTON_WHEEL_DOWN:
			if event.is_pressed() and block_indx > 0 and not Input.is_action_pressed("zoom"):
				block_indx -= 1
			elif event.is_pressed() and Input.is_action_pressed("zoom"):
				$"VIEW".zoom -= Vector2(1, 1)

#chamado todo frame
func _process(delta):
	edit()
	cam()

#câmera
func cam():
	#posição da câmera
	#inputs
	var up = Input.is_action_pressed("up")
	var down = Input.is_action_pressed("down")
	var left = Input.is_action_pressed("left")
	var right = Input.is_action_pressed("right")
	
	#movimentação
	if up:
		cam.position.y -= 10
	if down:
		cam.position.y += 10
	if left:
		cam.position.x -= 10
	if right:
		cam.position.x += 10

#função para editar
func edit():
	#posição do bloco
	pos = Vector2(stepify(get_global_mouse_position().x, 64) - 32, stepify(get_global_mouse_position().y, 64) - 32)
	$"BLOCK_INDX".position = pos
	
	#aparência do sprite
	match block_indx:
		0:
			$"BLOCK_INDX".texture = preload("res://DATA/SPRITES/EDITOR/wall.png")
		1:
			$"BLOCK_INDX".texture = preload("res://DATA/SPRITES/EDITOR/thorn.png")	
		2:
			$"BLOCK_INDX".texture = preload("res://DATA/SPRITES/EDITOR/DASH_NODE.png")
	
	#coordenada no tileset
	var coord = normal_tile.world_to_map(pos)
	
	#adiciona o tile
	if Input.is_action_pressed("mouse_click"):
		
		#index do bloco
		match block_indx:
			0:
				normal_tile.set_cellv(coord, normal_tile.tile_set.find_tile_by_name("WALL"))
				thorn_tile.set_cellv(coord, -1)
			1:
				normal_tile.set_cellv(coord, -1)
				thorn_tile.set_cellv(coord, thorn_tile.tile_set.find_tile_by_name("THORN"))
			2:
				normal_tile.set_cellv(coord, -1)
				thorn_tile.set_cellv(coord, -1)
				
				var sc = preload("res://DATA/SCENES/OBJECTS/DASH_NODE.tscn").instance()
				sc.position = pos
				
				$"DASH_NODES".add_child(sc)
				
				
				
				
				
				
				
	if Input.is_action_pressed("delete_tile"):
			for i in $"DASH_NODES".get_children():
				if i.position == pos:
					$"DASH_NODES".remove_child(i)
				
			normal_tile.set_cellv(coord, -1)
			thorn_tile.set_cellv(coord, -1)
	pass