extends RigidBody

var should_reset = false
var should_move_to_position = false
var falling = false
var position = Vector3(0,-2.2,0)

func reset():
	should_reset = true
	
func freeze_on_position(pos):
	position = pos
	should_move_to_position = true

func throw_towards(direction):
	gravity_scale = 1
	apply_impulse(Vector3(0,0,0), direction)
	falling = true

func _integrate_forces(state):
	if falling:
		return
		
	if should_reset:
		print("Reset")
		gravity_scale = 0
		set_linear_velocity(Vector3(0,0,0))
		set_angular_velocity(Vector3(0,0,0))
		translation = Vector3(0,-2.2,0)
		should_reset = false
	if should_move_to_position:
		set_linear_velocity(Vector3(0,0,0))
		set_angular_velocity(Vector3(0,0,0))
		gravity_scale = 0
		translation = position
		should_move_to_position = false