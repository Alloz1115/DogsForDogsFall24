extends Control
@export var levelName : String = "res://Scenes/gameplay.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_quit_button_pressed():
	hide()
	get_tree().quit()

func _on_next_level_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file(levelName)
