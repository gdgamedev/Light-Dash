extends "res://DATA/SCRIPTS/classes/DASH_NODE_CLASS.gd"

export (bool) var disable_on_dash = false
var disabled = false

func _process(delta):
	if disabled and $"SPR".modulate.a == 1:
		$"DISABLE".play("DIS")
		