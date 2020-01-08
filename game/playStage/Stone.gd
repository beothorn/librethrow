extends StaticBody

onready var collisionShape = get_node("CollisionShape")
onready var cg = get_node("CSGMesh")
onready var stone = get_node("StoneMesh")

func _ready():
	project_collision_shadow()
	
func flat():
	translation.z = 0
	
func hide():
	translation.z = -1000
	
func is_hidden():
	return translation.z == -1000

func project_collision_shadow():
	var stone_transform =  get_global_transform()
	stone_transform.origin.z = 0
	collisionShape.set_global_transform(stone_transform)
