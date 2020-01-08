extends Spatial

func rotate(axis:Vector3, angle:float ):
	.rotate(axis, angle)
	for stone in get_children():
		stone.project_collision_shadow()