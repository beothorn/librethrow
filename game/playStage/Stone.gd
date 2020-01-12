extends StaticBody

var collisionShape
onready var stone = get_node("StoneMesh")
onready var camera = get_node("/root/GameRoom/Camera")
onready var center_pos = get_node("Center")
onready var radius_pos = get_node("Radius")

var original_position

const plane = Plane(Vector3(0,0,0), Vector3(1,0,0), Vector3(0,1,0))

func _ready():
	original_position = translation
	collisionShape = CollisionShape.new()
	collisionShape.set_name("CollisionShape")
	collisionShape.shape = SphereShape.new()
	add_child(collisionShape)
	project_collision_shadow()
	
func reset():
	translation = original_position
	project_collision_shadow()
	
func flat():
	translation.z = 0
	
func hide():
	translation.z = -1000
	
func is_hidden():
	return translation.z == -1000

func project_collision_shadow():
	var camera_position =  camera.get_global_transform().origin
	var sphere_position =  center_pos.get_global_transform().origin
	var radius_sphere_position =  radius_pos.get_global_transform().origin
	
	var ray = sphere_position - camera_position
	ray = ray.normalized()
	
	var ray_radius = radius_sphere_position - camera_position
	ray_radius = ray_radius.normalized()
	
	var itersection = plane.intersects_ray(camera_position, ray)
	var itersection_radius = plane.intersects_ray(camera_position, ray_radius)
	
	var sphereProjectionOld =  get_global_transform()
	if itersection:
		sphereProjectionOld.origin = itersection
		collisionShape.set_global_transform(sphereProjectionOld)
		if itersection_radius:
			collisionShape.shape.radius = itersection_radius.y - itersection.y
