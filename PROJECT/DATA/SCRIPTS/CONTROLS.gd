extends "res://DATA/SCRIPTS/classes/CONTROLS.gd"

func _ready():
	stick_pos = $"JOYSTICK".global_position

func _process(delta):
	if _method == method.joystick:
		
		$"../../PLAYER".joy_pos = stick_vec
	
	pass

