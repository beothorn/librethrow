extends Spatial

onready var root = get_node("/root/GameRoom")
onready var stones = get_node("/root/GameRoom/Stones")
onready var aim_ball = get_node("/root/GameRoom/Aim_ball")
onready var stones_bottom = get_node("/root/GameRoom/StonesBottom")
onready var camera = get_node("/root/GameRoom/Camera")
onready var simulation_point_meshes = get_node("/root/GameRoom/SimulationPointsMeshes")
onready var simulated_endpoint = get_node("/root/GameRoom/SimulatedEndpoint")

onready var ball_gen = preload("res://playStage/DropBall.tscn") 
onready var sim_ball_gen = preload("res://playStage/SimulatedBall.tscn")

export (float) var throw_force = 10
export (float) var gravity = 7
export (float) var bounciness = 0.8
export (int) var bounce_count = 2

var aim_circle_radius = 2.2
var maximun_aim_angle = -0.26
var should_restart = false
var hidden_z_coordinate = -1000

var stones_room_bottom

var initial_x = 0
var initial_rotation = 0
var rotating_stones = false

var throwing = false

var click_start = 0
var mouse_pressed = false
var simulation

func _ready():
	stones_room_bottom = stones_bottom.get_global_transform().origin.y
	simulation = sim_ball_gen.instance()
	add_child(simulation)
	throw_simulation_ball(Vector3(0,-1,0))

const plane = Plane(Vector3(0,0,0), Vector3(1,0,0), Vector3(0,1,0))
const ray_length = 1000
func _screen_position_on_y_axis(position):
	var from = camera.project_ray_origin(position)
	var to = from + camera.project_ray_normal(position) * ray_length
	return plane.intersects_ray(camera.get_global_transform().origin, to)

func throw_ball(towards_point):
	clear_simulations()
	var ball = ball_gen.instance()
	root.add_child(ball)
	ball.connect("collision", self, "_on_ball_hit")
	ball.translation = aim_ball.translation
	aim_ball.translation.z = hidden_z_coordinate
	var throw_direction = towards_point
	throw_direction = throw_direction.normalized()
	throw_direction = throw_direction * throw_force
	
	ball.throw(gravity, throw_direction, bounciness)
	return ball
	
func throw_simulation_ball(towards_point):	
	var throw_direction = towards_point
	throw_direction = throw_direction.normalized()
	throw_direction = throw_direction * throw_force
	
	var create_on_every_interaction = 5
	var simulation_points = simulation.simulate(aim_ball.translation, gravity, throw_direction, bounciness, bounce_count, create_on_every_interaction)
	
	var point_count = len(simulation_points)
	simulation_point_meshes.multimesh.visible_instance_count = point_count

	for i in range(point_count):
		simulation_point_meshes.multimesh.set_instance_transform(i, Transform(Basis(), simulation_points[i]))
	simulated_endpoint.visible = true
	simulated_endpoint.translation = simulation_points[point_count-1]
	
	return simulation


func _input(event):
	var mouse_click = event as InputEventMouseButton
	if mouse_click:
		
		var left_pressed = mouse_click.button_index == BUTTON_LEFT and mouse_click.pressed
		var left_released = mouse_click.button_index == BUTTON_LEFT and !mouse_click.pressed
		
		if left_pressed:
			mouse_pressed = true
			click_start = OS.get_ticks_msec()
		
		if left_released:
			mouse_pressed = false
			
		var left_click = left_released and (OS.get_ticks_msec() - click_start) < 200
		
		if left_released and !throwing:
			rotating_stones = false
		
		var pos2d = _screen_position_on_y_axis(event.position)
		
		if left_click and !throwing and pos2d.y > stones_room_bottom:
			throw_ball(aim_ball.translation)
			throwing = true
		
		if left_pressed and !throwing and pos2d.y < stones_room_bottom:
			initial_x = pos2d.x
			initial_rotation = stones.rotation.y
			rotating_stones = true
		
		if left_released and rotating_stones:
			rotating_stones = false
		
	var mouse_motion = event as InputEventMouseMotion
	if mouse_motion:
		if mouse_pressed:
			var pos2d = _screen_position_on_y_axis(event.position)
			var pos_cursor = pos2d.normalized() * aim_circle_radius
			if pos_cursor.y < maximun_aim_angle:
				aim_ball.translation.x = pos_cursor.x
				aim_ball.translation.y = pos_cursor.y
				if !throwing:
					throw_simulation_ball(_screen_position_on_y_axis(event.position))
			
			if pos2d.y > stones_room_bottom:
				rotating_stones = false
				
			if !throwing and rotating_stones and pos2d.y < stones_room_bottom:
				stones.set_stones_rotation( initial_rotation + ((initial_x - pos2d.x)/2))
			
func _on_ball_hit(obj, ball):			
	if obj.is_in_group("Stone"):
		#removing child is slow so we just hide it
		obj.hide()
		should_restart = true
		for stone in stones.get_children():
			if stone.is_in_group("Stone") and !stone.is_hidden():
				should_restart = false
		
	if obj.is_in_group("BallKiller"):
		root.remove_child(ball)
		throwing = false
		aim_ball.translation.z = 0
		for stone in stones.get_children():
				if stone.is_in_group("Stone"):
					stone.force_hide()
		if should_restart:
			stones.set_stones_rotation(0)
			for stone in stones.get_children():
				if stone.is_in_group("Stone"):
					stone.reset()
			should_restart = false

func clear_simulations():
	simulation_point_meshes.multimesh.visible_instance_count = 0
	simulated_endpoint.visible = false