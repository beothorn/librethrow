extends RigidBody

signal collision

func _on_Ball_body_entered(body):
	emit_signal("collision", body, self)
