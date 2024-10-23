extends Control

# add textures here
var defaultButtonTexture = preload("res://labelRectangle.png")
var otherTexture = preload("res://RectangleIconSlot.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func setOrder(texture):
	$ItemList.add_icon_item(texture, false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
