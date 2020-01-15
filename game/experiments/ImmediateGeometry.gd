extends ImmediateGeometry

func _ready():
	pass

func _process(delta):
	self.clear()
	self.begin(PrimitiveMesh.PRIMITIVE_LINES)
	self.set_color(Color(1,1,1))
	self.add_vertex(Vector3(0,0,0)) 
	self.add_vertex(Vector3(0,1,0))
	self.add_vertex(Vector3(1,5,0))
	self.end()