extends Control

@onready var animationPlayer = $DispenseButton/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
# Runs animationplayer
func _on_dispense_button_button_down() -> void:
	animationPlayer.play("test_animation")
	print("button is being held down")
# Stops animationplayer
func _on_dispense_button_button_up() -> void:
	animationPlayer.pause()
	#animationPlayer.play("test_animation")
	#print("button is being held up")
	 # Replace with function body.
