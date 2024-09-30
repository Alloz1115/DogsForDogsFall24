extends Control
# logic for the order card, which is spawned when a dog customer's order button is pressed

var customerNumber = 0
var draggable = false
var is_dragging = false
var offset: Vector2
var initialPos: Vector2
var slotType = 5 # slot type is 5 aka CARD
var orderName = null
var cardData: Dictionary

# add textures here
var bunChoice = preload("res://sprites/RectangleIconSlot.png")
var hotDogChoice = preload("res://sprites/RectangleIconSlot.png")
var toppingsChoice = preload("res://sprites/RectangleIconSlot.png")
var drinkChoice = preload("res://sprites/RectangleIconSlot.png")
var defaultButtonTexture = preload("res://sprites/labelRectangle.png")
var otherTexture = preload("res://sprites/RectangleIconSlot.png")
var texturesArray # is array of all preloaded textures for ordercard

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# texture - array of textures to add to order details
func setOrder():
	# idk what I'm doing here rn, I'm just gonna fix it later lmfao
	# this will set the textures for the order card by reading the data 
	# from the order
	$ItemList.add_icon_item(otherTexture)

## Called every frame. 'delta' is the elapsed time since the previous frame.
# implements drag and drop features
func _process(delta):
	if draggable:
		# moves card around while dragging
		if Input.is_action_just_pressed("click"):
			initialPos = global_position
			offset = get_global_mouse_position() - global_position
			is_dragging = true
		if Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() - offset
			is_dragging = true
		# creates tween to make card go to top of screen when player lets go of card
		elif Input.is_action_just_released("click"):
			is_dragging = false
			var tween = get_tree().create_tween()
			tween.tween_property(self, "position", Vector2(self.global_position.x, 10), 0.2).set_ease(Tween.EASE_OUT)

# sets draggable to true if the mouse is on the order card
func _on_item_list_mouse_entered():
	if not is_dragging:
		draggable = true

# sets draggable to false if mouse is NOT on order card
func _on_item_list_mouse_exited():
	if not is_dragging:
		draggable = false

# used by outside functions to get order data from order card 
# (for example when comparing cardData to data in hot dog submission slot to 
# verify order accuracy
func sendCardData():
	return cardData
