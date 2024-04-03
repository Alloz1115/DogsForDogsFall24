extends CharacterBody2D

@onready var state_machine = $AnimationTree["parameters/playback"]
var order_card = load("res://order_card.tscn")
var defaultButtonTexture = preload("res://sprites/labelRectangle.png")
var otherTexture = preload("res://sprites/RectangleIconSlot.png")

# code for order 
var cardData = {"image1" : otherTexture
,"image2" : otherTexture
,"image3" : otherTexture 
,"image4" : otherTexture
,"image5" : otherTexture
}

func ready():
	state_machine.start()

func _physics_process(_delta):
	pass

# fix animation
func _on_button_pressed():
	# creates order card and deletes button
	var newCard = order_card.instantiate()
	newCard.set_position(Vector2(100, 100))
	get_parent().add_child(newCard)
	newCard.setOrder(cardData["image1"])
	$Button.queue_free()
