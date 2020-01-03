extends Spatial

onready var ball = get_node("/root/GameRoom/Ball")

func _ready():
	PhysicsServer.area_set_param(get_world().get_space(), PhysicsServer.AREA_PARAM_GRAVITY_VECTOR, Vector3(0, -1, 0))


func _on_StaticBody_input_event(camera, event, click_position, click_normal, shape_idx):
	pass

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		ball.translation = Vector3(0,4.908,0)
		ball.set_linear_velocity(Vector3(0,0,0))
		var pos = get_node("Camera").project_ray_origin(event.position)
		ball.gravity_scale = 1
		var x = pos - ball.translation
		x = x.normalized()
		x = x * 15
		x.z = 0
		ball.apply_impulse(Vector3(0,0,0), x)
		print(pos)