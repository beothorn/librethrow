extends Spatial

func set_stones_rotation( angle:float ):
	rotation.y = angle
	for stone in get_children():
		if stone.is_in_group("Stone"):
			stone.project_collision_shadow()