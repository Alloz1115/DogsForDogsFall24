extends Control
@export var levelName : String = "res://Scenes/gameplay.tscn"
# starting text for $Item
var labelStartingText = "Current Score: "
# Makes game go to gameplay.tscn or a set level when next level button is pressed

# TODO get accuracy of order and display on the label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



# quits game
func _on_quit_button_pressed():
	hide()
	$"..".get_tree().quit()

# goes to the next level indicated in levelName
func _on_next_level_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file(levelName)
	hide()
