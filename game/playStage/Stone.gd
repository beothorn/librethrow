extends StaticBody

var collisionShape
onready var stone = get_node("StoneMesh")
onready var stone_hit = get_node("StoneHit")
onready var camera = get_node("../../../Camera")
onready var center_pos = get_node("Center")
onready var radius_pos = get_node("Radius")
onready var timer = get_node("Timer")
onready var tween = get_node("Tween")

var original_position
var original_scale

var _is_hiding = false
var _is_hidden = false

const plane = Plane(Vector3(0,0,0), Vector3(1,0,0), Vector3(0,1,0))

func _ready():
	stone.queue_free()
	original_position = translation
	original_scale = scale
	collisionShape = CollisionShape.new()
	collisionShape.set_name("CollisionShape")
	collisionShape.shape = SphereShape.new()
	add_child(collisionShape)
	project_collision_shadow()
	
func reset():
	translation = original_position
	_is_hiding = false
	_is_hidden = false
	stone_hit.set_visible(false)
	project_collision_shadow()
	
func hide():
	if _is_hiding:
		return
	_is_hiding = true
	stone_hit.set_visible(true)
	timer.start()
	
func force_hide():
	if _is_hiding:
		tween.interpolate_property(self, "scale", scale, Vector3(0,0,0), 0.3, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
		tween.start()
	
func is_hidden():
	return _is_hidden or _is_hiding

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

func _on_Timer_timeout():
	force_hide()

func _on_Tween_tween_completed(object, key):
	translation.z = -1000
	scale = original_scale
	_is_hiding = false
	_is_hidden = true
