extends ItemList
var otherTexture = preload("res://RectangleIconSlot.png")
@export var loopVar = 5


# Called when the node enters the scene tree for the first time.
func _ready():
	var cardData = {"image1" : otherTexture, "image2" : otherTexture, "image3" : otherTexture, "image4" : otherTexture, "image5" : otherTexture}
	add_icon_item(cardData["image1"], false)
	# _fill_order_card(cardData)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	# DRAG AND DROP HERE

func _fill_order_card(_data):
	for i in range (loopVar):
		await get_tree().create_timer(2.0).timeout
