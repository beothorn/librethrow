extends KinematicBody
class_name SimulatedBall

onready var gameRoom = get_node("/root/GameRoom")
onready var collision = get_node("CollisionShape")

func simulate(starting_point:Vector3, gravity:float, throw_direction:Vector3, bounciness:float, bounce_simulations:int, create_on_every_interaction:int) -> Array:
	collision.disabled = false
	self.translation = starting_point
	var velocity = Vector3()
	var simulating = true
	var delta = 0.016667
	var simulation_positions = []
	
	velocity += throw_direction
	var bounce_counts = 0
	var interaction_interval = 0
	while simulating:
		interaction_interval += 1
		velocity.y -= gravity * delta
		var collision = move_and_collide(velocity * delta)
		velocity.z = 0
		if interaction_interval % create_on_every_interaction == 0:
			simulation_positions.append(self.translation)
		if collision:
			simulation_positions.append(self.translation)
			velocity = velocity.bounce(collision.normal)
			velocity *= bounciness
			bounce_counts += 1
			if collision.collider.is_in_group("BallKiller"):
				simulating = false
				break	
		if bounce_counts >= bounce_simulations:
			simulating = false
			break
		if interaction_interval > 1000:
			print("Infinite loop: Too much simulations with no collisions")
			simulating = false
			break
	collision.disabled = true
	return simulation_positions