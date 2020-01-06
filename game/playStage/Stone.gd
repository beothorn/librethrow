extends StaticBody


var real_z = 0

func _ready():
	self.real_z = translation.z
	
func flat():
	translation.z = 0

func unflat():
	translation.z = real_z
	
func hide():
	translation.z = -1000
	
func is_hidden():
	return translation.z == -1000