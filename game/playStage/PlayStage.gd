extends Spatial

onready var root = get_node("/root/GameRoom")
onready var stones = get_node("/root/GameRoom/Stones")
onready var aim_ball = get_node("/root/GameRoom/Aim_ball")
onready var stones_rotation = get_node("/root/GameRoom/StonesRotation")
onready var ball_gen = preload("res://playStage/ThrownBall.tscn") 

var throw_force = 8
var aim_circle_radius = 2.2
var maximun_aim_angle = -0.26
var should_restart = false
var hidden_z_coordinate = -1000
var max_y = 1614

var initial_x = 0
var rotating_stones = false

var throwing = false

var y_axis = Vector3(0,1,0)

func throw_ball(towards_point):
	var ball = ball_gen.instance()
	root.add_child(ball)
	ball.connect("collision", self, "_on_ball_hit")
	ball.translation = aim_ball.translation
	aim_ball.translation.z = hidden_z_coordinate
	var pos = get_node("Camera").project_ray_origin(towards_point)
	ball.gravity_scale = 1
	var throw_direction = Vector3(pos.x, pos.y, 0)
	throw_direction = throw_direction.normalized()
	throw_direction = throw_direction * throw_force
	ball.apply_impulse(Vector3(0,0,0), throw_direction)

func _input(event):
	var mouse_click = event as InputEventMouseButton
	if mouse_click:
		if mouse_click.button_index == BUTTON_LEFT and !mouse_click.pressed and !throwing:
			rotating_stones = false
			
		if mouse_click.button_index == BUTTON_LEFT and !mouse_click.pressed and !throwing and event.position.y < max_y:
			throw_ball(event.position)
			throwing = true
		if mouse_click.button_index == BUTTON_LEFT and mouse_click.pressed and !throwing and event.position.y > max_y:
			initial_x = event.position.x
		
	var mouse_motion = event as InputEventMouseMotion
	if mouse_motion:
		var pos = get_node("Camera").project_ray_origin(event.position)
		if event.position.y < max_y:
			var pos2d = Vector3(pos.x, pos.y, 0)
			var pos_cursor = pos2d.normalized() * aim_circle_radius
			if pos_cursor.y < maximun_aim_angle:
				aim_ball.translation.x = pos_cursor.x
				aim_ball.translation.y = pos_cursor.y
			
func _on_ball_hit(obj, ball):
	if obj.is_in_group("Stone"):
		#removing child is slow so we just hide it
		obj.hide()
		should_restart = true
		for stone in stones.get_children():
			if !stone.is_hidden():
				should_restart = false
		
	if obj.is_in_group("BallKiller"):
		root.remove_child(ball)
		throwing = false
		aim_ball.translation.z = 0
		if should_restart:
			stones_rotation.translation.x = 0
			for stone in stones.get_children():
				stone.reset()
			should_restart = false
	

func _on_StonesRotation_input_event(camera, event, click_position, click_normal, shape_idx):
	var mouse_click = event as InputEventMouseButton
	if mouse_click:
		if mouse_click.button_index == BUTTON_LEFT and !mouse_click.pressed and !throwing:
			rotating_stones = false
		if mouse_click.button_index == BUTTON_LEFT and mouse_click.pressed and !throwing and event.position.y > max_y:
			rotating_stones = true
		
	var mouse_motion = event as InputEventMouseMotion
	if mouse_motion and rotating_stones:
		var pos = get_node("Camera").project_ray_origin(event.position)
		if event.position.y > max_y:
			stones_rotation.translation.x = pos.x
			stones.set_stones_rotation(stones_rotation.translation.x)
