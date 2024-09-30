extends CharacterBody2D

# is connected to dictionary below
@export var bunAmount : int = 0
@export var hotDogAmount : int = 0
@export var ketchupAmount : int = 0
@export var mustardAmount : int = 0
@export var drinkType : int = 0
@export var entryDelaySeconds : int = 5
var goToXMinimum = 100
var goToXMaximum = 800
var cardOrder

var order_card = load("res://order_card.tscn")
var customerName = NodePath(self.get_path())

# code for order (bun, hot dog, topping, drink)
# MIGHT WANT TO REVERSE THIS


func _ready():
	# loop animation here? 
	cardOrder = {
	"bun": bunAmount,
	"hot dog": hotDogAmount,
	"ketchup": ketchupAmount,
	"mustard" : mustardAmount,
	"drink": drinkType
	}
	var goToX = randi_range(goToXMinimum, goToXMaximum)
	# create tween from current position to random int x value
	await get_tree().create_timer(entryDelaySeconds).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(goToX, self.global_position.y), 3).set_ease(Tween.EASE_OUT)

# need to fix animation
func _on_button_pressed():
	# creates order card and deletes button
	var newCard = order_card.instantiate()
	newCard.set_position(get_global_mouse_position())
	# makes card child of its customer
	get_parent().add_child(newCard)
	# sends over card metadata 
	newCard.cardData = cardOrder
	# makes the physical order
	print(customerName)
	print(self.get_path())
	
	# finishes creating order card and deletes order button
	newCard.setOrder()
	$Button.queue_free()

