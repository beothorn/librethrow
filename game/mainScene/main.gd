extends Spatial

onready var game_room = preload("res://playStage/PlayStage.tscn") 
onready var level_chooser = preload("res://levelChoose/LevelChooser.tscn") 


func load_scene(scene):
	var loaded_scene = scene.instance()
	for c in self.get_children():
		c.queue_free()
	self.get_node(".").add_child(loaded_scene)
	return loaded_scene

func load_level_chooser():
	var level_instance = load_scene(level_chooser)
	level_instance.get_node("Levels/Level1").connect("input_event", self, "load_level_1")

func _ready():
	load_level_chooser()

func load_level_1(camera, event, click_position, click_normal, shape_idx):
	var mouse_click = event as InputEventMouseButton
	if mouse_click:
		var left_pressed = mouse_click.button_index == BUTTON_LEFT and mouse_click.pressed
		if left_pressed:
			print("left_pressed")
			var game_room_instance = load_scene(game_room)
			game_room_instance.connect("change_to_level_chooser", self, "load_level_chooser")
