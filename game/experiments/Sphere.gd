extends CSGSphere

onready var camera = get_node("/root/Spatial/Camera2")
onready var tween = get_node("Tween")
onready var sphereProjection = get_node("SphereProjection")
onready var center_pos = get_node("Center")
onready var radius_pos = get_node("Radius")
var plane = Plane(Vector3(0,0,0), Vector3(1,0,0), Vector3(0,1,0))

var plus = false

func _ready():
	_on_Tween_tween_completed(null, null)

func _on_Tween_tween_completed(object, key):
	var destination = translation
	
	var dest_offset = 20
	
	if plus:
		plus = false
		dest_offset = -20
	else:
		plus = true
		dest_offset = 20
	
	destination.x = destination.x + dest_offset
	destination.z = destination.z + dest_offset
	tween.interpolate_property(self, "translation", translation, destination, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


func _on_Tween_tween_step(object, key, elapsed, value):
	var camera_position =  camera.get_global_transform().origin
	var sphere_position =  center_pos.get_global_transform().origin
	var radius_sphere_position =  radius_pos.get_global_transform().origin
	
	var ray = sphere_position - camera_position
	ray = ray.normalized()
	
	var ray_radius = radius_sphere_position - camera_position
	ray_radius = ray_radius.normalized()
	
	
	var itersection = plane.intersects_ray(camera_position, ray)
	var itersection_radius = plane.intersects_ray(camera_position, ray_radius)
	
	#print("""{"camera_position":\""""+str(camera_position)+"""\", "sphere_position":\""""+str(sphere_position)+"""\", "itersection":\""""+str(itersection)+"""\", "ray":\""""+str(ray)+"""\"}""")
	
	var sphereProjectionOld =  get_global_transform()
	if itersection:
		sphereProjectionOld.origin = itersection
		sphereProjection.set_global_transform(sphereProjectionOld)
		if itersection_radius:
			sphereProjection.radius = itersection_radius.y - itersection.y
