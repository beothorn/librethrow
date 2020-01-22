extends KinematicBody

onready var gameRoom = get_node("/root/GameRoom")

func simulate(gravity:float, throw_direction:Vector3, bounciness:float, bounce_simulations:int):
	var velocity = Vector3()
	var simulating = true
	var delta = 0.016667
	var simulation_positions = []
	
	velocity += throw_direction
	var bounce_counts = 0
	while simulating:
		velocity.y -= gravity * delta
		var collision = move_and_collide(velocity * delta)
		velocity.z = 0
		simulation_positions.append(self.translation)
		if collision:
			velocity = velocity.bounce(collision.normal)
			velocity *= bounciness
			bounce_counts += 1
			if collision.collider.is_in_group("BallKiller"):
				simulating = false
				break	
		if bounce_counts >= bounce_simulations:
			simulating = false
			break
	return simulation_positions