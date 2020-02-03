extends Spatial

onready var stoneMeshes = get_node("StoneMeshes")

var hit_count = 0

func _ready():
	set_stones_rotation(0)

func _get_stones():
	var result = []
	var children = get_children()
	for maybe_stone in children:
		if maybe_stone.is_in_group("Stone"):
			result.append(maybe_stone)
	return result

func set_stones_rotation(angle:float):
	rotation.y = angle
	var stones = _get_stones()
	var stone_count = len(stones)
	stoneMeshes.multimesh.visible_instance_count = stone_count
	var counter = 0
	for stone in stones:
		stone.project_collision_shadow()
		stoneMeshes.multimesh.set_instance_transform(counter, stone.get_transform())
		counter += 1

func rebuild_meshes():
	hit_count += 1
	var stones = _get_stones()
	
	var visible_stones = []
	for stone in stones:
		if !stone.is_hidden():
			visible_stones.append(stone)
	
	var stone_count = len(visible_stones)
	stoneMeshes.multimesh.visible_instance_count = stone_count
	var counter = 0
	for stone in visible_stones:
		stoneMeshes.multimesh.set_instance_transform(counter, stone.get_transform())
		counter += 1
