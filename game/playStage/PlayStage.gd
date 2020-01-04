extends Spatial

onready var ball = get_node("/root/GameRoom/Ball")

var throwing = false

func _ready():
	PhysicsServer.area_set_param(get_world().get_space(), PhysicsServer.AREA_PARAM_GRAVITY_VECTOR, Vector3(0, -1, 0))

func _on_StaticBody_input_event(camera, event, click_position, click_normal, shape_idx):
	pass

func throw_ball(towards_point):
	ball.set_linear_velocity(Vector3(0,0,0))
	var pos = get_node("Camera").project_ray_origin(towards_point)
	ball.gravity_scale = 1
	var throw_direction = Vector3(pos.x, pos.y, 0)
	throw_direction = throw_direction.normalized()
	throw_direction = throw_direction * 15
	ball.apply_impulse(Vector3(0,0,0), throw_direction)

func _input(event):
	var mouse_click = event as InputEventMouseButton
	if mouse_click and mouse_click.button_index == 1 and mouse_click.pressed:
		throw_ball(event.position)
		throwing = true
	else:
		if !throwing:
			var pos = get_node("Camera").project_ray_origin(event.position)
			var pos2d = Vector3(pos.x, pos.y, 0)
			var pos_cursor = pos2d.normalized() * 2.2
			ball.translation = pos_cursor