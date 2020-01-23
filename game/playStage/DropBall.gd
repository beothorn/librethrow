extends KinematicBody
class_name Ball

signal collision

var gravity:float = 0
var bounciness:float = 0
var velocity:Vector3 = Vector3()

func _physics_process(delta):
	velocity.y -= gravity * delta
	var collision = move_and_collide(velocity * delta)
	velocity.z = 0
	if collision:
		velocity = velocity.bounce(collision.normal)
		velocity.z = 0
		velocity *= bounciness
		emit_signal("collision", collision.collider, self)

func throw(gravity:float, throw_direction:Vector3, bounciness:float):
	self.gravity = gravity
	self.bounciness = bounciness
	velocity += throw_direction