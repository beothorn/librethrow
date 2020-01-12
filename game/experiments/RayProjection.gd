extends Spatial

onready var camera = get_node("Camera")
onready var cursor = get_node("Cursor")

const plane = Plane(Vector3(0,0,0), Vector3(1,0,0), Vector3(0,1,0))
const ray_length = 1000

func _input(event):
		
	var mouse_motion = event as InputEventMouseMotion
	if mouse_motion:
		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * ray_length
		var pos = plane.intersects_ray(camera.get_global_transform().origin, to)
		print(pos)
		var cursor_transform = cursor.get_global_transform()
		cursor_transform.origin = pos
		cursor.set_global_transform(cursor_transform)
