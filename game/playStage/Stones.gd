extends Spatial

func set_stones_rotation( angle:float ):
	rotation.y = angle
	for stone in get_children():
		stone.project_collision_shadow()