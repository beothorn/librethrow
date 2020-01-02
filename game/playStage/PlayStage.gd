extends Spatial

onready var ball = get_node("/root/GameRoom/Ball")

func _ready():
	PhysicsServer.area_set_param(get_world().get_space(), PhysicsServer.AREA_PARAM_GRAVITY_VECTOR, Vector3(0, -1, 0))


func _on_StaticBody_input_event(camera, event, click_position, click_normal, shape_idx):
	var mouse_click = event as InputEventMouseButton
	if mouse_click and mouse_click.button_index == 1 and mouse_click.pressed:
		ball.gravity_scale = 1
		ball.apply_impulse(Vector3(0,0,0), Vector3(5.5,-5.5,0))
