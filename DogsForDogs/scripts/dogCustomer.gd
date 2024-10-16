extends CharacterBody2D
# movement logic for dog customer, also makes instance of order card if dog customer's 
# order button is pressed

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

func _ready():
	# might loop animation here? 
	cardOrder = {
	"bun": bunAmount,
	"hot dog": hotDogAmount,
	"ketchup": ketchupAmount,
	"mustard" : mustardAmount,
	"drink": drinkType
	}
	var goToX = randi_range(goToXMinimum, goToXMaximum)
	# create tween from current position to random int x value
	# wait for x seconds, then tween to player's view
	await get_tree().create_timer(entryDelaySeconds).timeout
	var tween = get_tree().create_tween()
	# move to player's view
	tween.tween_property(self, "position", Vector2(goToX, self.global_position.y), 3).set_ease(Tween.EASE_OUT)

# creates order card for associated dog. note that order card is child of dog customer
func _on_button_pressed():
	# creates order card and deletes order button
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
