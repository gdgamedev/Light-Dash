extends "res://DATA/SCRIPTS/classes/PLAYER_CLASS.gd"

var pass_delta = 0

func _ready():
	
	controls_node = $"../GUI/CONTROLS"


func _process(delta):
	if Input.is_action_just_pressed("debug_die"):
		die()
	
	aesthestic()
	move(delta)
	trail($TRAIL/LINE, $"SPR/TRAIL_POS")
	cam($CAM)
	spd_ind($"../GUI/SPD", $"../GUI/TEXT")
	dash_node()
	
	if ( SPD.x > 300 or SPD.x < -300 ) and is_on_floor():
		$"SMOKE".emitting = true
	else:
		$"SMOKE".emitting = false
	
	if dead and Input.is_action_just_pressed("restart"):
		restart()
	
	
	pass

func _on_DEATH_body_entered(body):
	if body.is_in_group("HAZARD"):
		die()
		
	pass # replace with function body


