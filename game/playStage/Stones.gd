extends Spatial

func rotate_clockwise(amount):
	self.rotation.y = self.rotation.y + amount
	for stone in get_children():
		stone.get_node("CollisionShape").rotation.y = stone.get_node("CollisionShape").rotation.y - amount