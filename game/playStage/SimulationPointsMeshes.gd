extends MultiMeshInstance
		
onready var simulated_endpoint = get_node("SimulatedEndpoint")

func set_points(points):
	var points_count = len(points)
	multimesh.visible_instance_count = points_count
	for i in range(points_count):
		multimesh.set_instance_transform(i, Transform(Basis(), points[i]))
		
	simulated_endpoint.visible = true
	simulated_endpoint.translation = points[points_count-1]
	
func hide():
	multimesh.visible_instance_count = 0
	simulated_endpoint.visible = false
