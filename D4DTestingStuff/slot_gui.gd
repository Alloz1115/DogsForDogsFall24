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
	
	print("debugging")
	print(str(item.inventorySlot.item.size()))
	inventory.removeSlot(itemStackGui.inventorySlot)
	# set itemStackGui as null so that it is seen as empty
	itemStackGui = null
	print("debugging again ")
	print(str(item.inventorySlot.item.size()))
	return item

func isEmpty():
	return !itemStackGui
