extends KinematicBody2D

#aceleração
var spd = 1500
#motion
var motion = Vector2(0, 0)
#velocidade de rotação
var rot_spd = 0
#velocidade máxima de rotação
var max_rot_spd = 8
#fricção da rotação
var rot_spd_fric = 5
#aceleração
var rot_spd_acc = 10

func _process(delta):
	move(delta)

func move(delta):
	#inputs
	var up = Input.is_action_pressed("up")
	var down = Input.is_action_pressed("down")
	
	if down:
		if rot_spd < max_rot_spd:
			rot_spd += rot_spd_acc * delta
	elif up:
		if rot_spd > -max_rot_spd:
			rot_spd -= rot_spd_acc * delta
		
	if not down and not up:
		if rot_spd > 0:
			rot_spd -= rot_spd_fric * delta
			if rot_spd < 0:
				rot_spd = 0
		if rot_spd < 0:
			rot_spd += rot_spd_fric * delta
			if rot_spd > 0:
				rot_spd = 0
		pass
	
	rotation_degrees += rot_spd
	
	$"PART".process_material.angle = -rotation_degrees
	
	#motion
	motion = Vector2(spd, 0).rotated(rotation)
	
	#move e desliza
	move_and_slide(motion)
	pass