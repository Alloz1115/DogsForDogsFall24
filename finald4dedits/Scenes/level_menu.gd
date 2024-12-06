extends Control
var currentScene: String

func _ready():
	currentScene = get_tree().get_current_scene().get_name()

func _on_next_level_pressed():
	print("pause menu button pressed")
	match currentScene:
		"gameplay":
			print("This is the first level")
			get_tree().change_scene_to_file("res://Scenes/gameplay2.tscn")
		"gameplay2":
			get_tree().change_scene_to_file("res://Scenes/gameplay3.tscn")
		"gameplay3":
			get_tree().change_scene_to_file("res://Scenes/gameplay4.tscn")
		"gameplay4":
			get_tree().change_scene_to_file("res://Scenes/gameplay5.tscn")
