extends Control
var customerNumber = 0
var draggable = false
var is_dragging = false
var offset: Vector2
var initialPos: Vector2
var slotType = 5 # slot type is 5 aka CARD
# add textures here
var orderName = null
var cardData: Dictionary

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

# name - string
# texture - array of textures to add to order details
func setOrder():
	print("try delete")
	# first loop iterates through keys, second iterates number value in key value
	# for key in cardData.keys():
		# iterate int that tracks placement in texturesArray (MUST BE SAME ORDER AS CARDDATA)
		# for i in cardData[key]:
			# set texture i times
	$ItemList.add_icon_item(otherTexture)
	# FIX LATER
	# for index in texture.size():
		# $ItemList.add_icon_item(texture[index], false)

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if draggable:
		if Input.is_action_just_pressed("click"):
			initialPos = global_position
			offset = get_global_mouse_position() - global_position
			is_dragging = true
		if Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() - offset
			is_dragging = true
		elif Input.is_action_just_released("click"):
			is_dragging = false
			var tween = get_tree().create_tween()
			tween.tween_property(self, "position", Vector2(self.global_position.x, 10), 0.2).set_ease(Tween.EASE_OUT)

func _on_item_list_mouse_entered():
	if not is_dragging:
		draggable = true

func _on_item_list_mouse_exited():
	if not is_dragging:
		draggable = false

func sendCardData():
	return cardData
