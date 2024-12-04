extends Button

@onready var backgroundSprite: Sprite2D = $background
@onready var container: CenterContainer = $CenterContainer
@onready var inventory = preload("res://inventory.tres")
@export var isInfinite: bool

var itemStackGui: item_stack_gui
var index: int

#updates inventory when gui functions are called
func insert(isg: item_stack_gui):
	itemStackGui = isg
	container.add_child(itemStackGui)
	
	if !itemStackGui.inventorySlot || inventory.slots[index] == itemStackGui.inventorySlot:
		return
	
	inventory.insertSlot(index, itemStackGui.inventorySlot)

func takeItem():
	var item = itemStackGui
	container.remove_child(itemStackGui)
	
	inventory.removeSlot(itemStackGui.inventorySlot)
	# set itemStackGui as null so that it is seen as empty
	itemStackGui = null
	
	return item

func isEmpty():
	return !itemStackGui

# TODO might need to change this to _on_water_held depending on whether
# we want the function to run when button is pressed or held
func _on_water_pressed():
	if !isEmpty():
		itemStackGui.animationPlayer.play("test")
		# get the node, not the class instance? 
	else:
		print("There is no drink in here!")
	# play water animation on drinkSlot node (the parent of this node)
	# if there is a cup present in the water slot

func _on_cola_pressed():
	pass # Replace with function body.
	# play cola animation on drinkSlot node (the parent of this node)
	# if there is a cup present in the cola slot

func _on_root_beer_pressed():
	pass # Replace with function body.
	# play root beer animation on drinkSlot node (the parent of this node)
	# if there is a cup present in the root beer slot
