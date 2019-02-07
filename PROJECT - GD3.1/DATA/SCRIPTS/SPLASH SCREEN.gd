extends Node2D

export (bool) var cam_shake = false
export (float) var cam_shake_amp = 10
var cam_start_pos = Vector2()

func _ready():
	cam_start_pos = $"CAMERA".position


func _on_cam_shake_timeout():
	if cam_shake:
		if $"CAMERA".position != cam_start_pos:
			$"CAMERA".position = cam_start_pos
		else:
			$"CAMERA".position += Vector2(math.rand_n(-cam_shake_amp, cam_shake_amp, true), math.rand_n(-cam_shake_amp, cam_shake_amp, true))
	
			
	pass # replace with function body
