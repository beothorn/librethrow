extends Spatial

onready var root = get_node("/root/GameRoom")
onready var stones = get_node("/root/GameRoom/Stones")
onready var aim_ball = get_node("/root/GameRoom/Aim_ball")
onready var ball_gen = preload("res://playStage/ThrownBall.tscn") 
onready var ball_collision_shape = get_node("/root/GameRoom/Ball/Ball_collision")
onready var floor_collision_shape = get_node("/root/GameRoom/Walls/Walls_collisions/Floor_collision")

var throw_force = 15
var aim_circle_radius = 2.2

var throwing = false

func throw_ball(towards_point):
	var ball = ball_gen.instance()
	root.add_child(ball)
	ball.connect("collision", self, "_on_ball_hit")
	ball.translation = aim_ball.translation
	aim_ball.translation.z = 10
	var pos = get_node("Camera").project_ray_origin(towards_point)
	ball.gravity_scale = 1
	var throw_direction = Vector3(pos.x, pos.y, 0)
	throw_direction = throw_direction.normalized()
	throw_direction = throw_direction * throw_force
	ball.apply_impulse(Vector3(0,0,0), throw_direction)

func _input(event):
	var mouse_click = event as InputEventMouseButton
	if mouse_click and mouse_click.button_index == 1 and mouse_click.pressed and !throwing:
		throw_ball(event.position)
		throwing = true
	else:
		if !throwing:
			var pos = get_node("Camera").project_ray_origin(event.position)
			var pos2d = Vector3(pos.x, pos.y, 0)
			var pos_cursor = pos2d.normalized() * aim_circle_radius
			aim_ball.translation = pos_cursor
			
func _on_ball_hit(obj, ball):
	if obj.is_in_group("Stone"):
		stones.remove_child(obj)
	if obj.is_in_group("BallKiller"):
		root.remove_child(ball)
		throwing = false
		aim_ball.translation.z = 0
	