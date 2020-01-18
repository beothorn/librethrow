extends RigidBody

signal collision
signal physics_tick

func _ready():
	#Engine.time_scale = 10
	set_physics_process(true)

func _physics_process(delta):
	emit_signal("physics_tick", self)

func _on_Ball_body_entered(body):
	#Engine.time_scale = 1
	emit_signal("collision", body, self)
