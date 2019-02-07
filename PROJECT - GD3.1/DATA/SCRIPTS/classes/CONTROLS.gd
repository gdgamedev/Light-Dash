extends Node2D

enum method {
	button,
	joystick
	}

var _method = method.button

#variáveis do joystick
const BASE_RADIUS = 64
const STICK_RADIUS = 20

var stick_spd = 0
var stick_angle = 0
var stick_vec = Vector2()
var stick_pos = Vector2()

var touch_evt_idx = -1

func _input(event):
	if _method == method.joystick:
		
		if event is InputEventScreenTouch:
			
			if event.is_pressed():
				
				if stick_pos.distance_to(event.position) < BASE_RADIUS:
					
					touch_evt_idx = event.index
					
			elif touch_evt_idx != -1:
				
				if touch_evt_idx == event.index:
					$"JOYSTICK/STICK".position = Vector2()
					touch_evt_idx = -1
					stick_spd = 0
					stick_angle = 0
					stick_vec = Vector2()
	
		if touch_evt_idx != -1 and event is InputEventScreenDrag:
			var dist = stick_pos.distance_to(event.position)
			
			if dist + BASE_RADIUS > STICK_RADIUS:
				dist = BASE_RADIUS - STICK_RADIUS
				
			var vect = (event.position - stick_pos).normalized()
			
			var ang = event.position.angle_to_point(stick_pos)
			
			stick_vec = vect
			stick_angle = ang
			stick_spd = dist
			
			$"JOYSTICK/STICK".position = vect * dist
	
	else:
		$"JOYSTICK/STICK".position = Vector2()
		touch_evt_idx = -1
		stick_spd = 0
		stick_angle = 0
		stick_vec = Vector2()
	
func _process(delta):
	if _method == method.button:
		$"JOYSTICK".hide()
		$"MOVE_RIGHT".show()
		$"MOVE_LEFT".show()
		

	elif _method == method.joystick:
		$"JOYSTICK".show()
		$"MOVE_RIGHT".hide()
		$"MOVE_LEFT".hide()
		
	
	
	