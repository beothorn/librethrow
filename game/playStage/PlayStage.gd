extends Spatial

onready var root = get_node("/root/GameRoom")
onready var stones = get_node("/root/GameRoom/Stones")
onready var aim_ball = get_node("/root/GameRoom/Aim_ball")
onready var ball_gen = preload("res://playStage/ThrownBall.tscn") 

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
	if mouse_click:
		if mouse_click.button_index == BUTTON_LEFT and !mouse_click.pressed and !throwing:
			throw_ball(event.position)
			throwing = true
	var mouse_motion = event as InputEventMouseMotion
	if mouse_motion:
		var pos = get_node("Camera").project_ray_origin(event.position)
		var pos2d = Vector3(pos.x, pos.y, 0)
		var pos_cursor = pos2d.normalized() * aim_circle_radius
		aim_ball.translation.x = pos_cursor.x
		aim_ball.translation.y = pos_cursor.y
			
func _on_ball_hit(obj, ball):
	if obj.is_in_group("Stone"):
		#removing child is slow so we just hide it
		obj.translation.z=-1000
	if obj.is_in_group("BallKiller"):
		root.remove_child(ball)
		throwing = false
		aim_ball.translation.z = 0
	