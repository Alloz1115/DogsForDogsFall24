extends Button

@onready var backgroundSprite: Sprite2D = $background
@onready var container = $CenterContainer
@onready var inventory = preload("res://testing/Inventory.tres")

var ItemStackGUI: Item_stack_gui
var index: int

# NOTE CHECKING - FUNCTION IS CALLED UNRELIABLY
# called by 
func insert(isg: Item_stack_gui):
	ItemStackGUI = isg
	# can change background sprite here if needed
	
	if !ItemStackGUI.inventorySlot || inventory.slots[index] == ItemStackGUI.inventorySlot:
		return
	
	# a temporary but bad fix
	# container.add_child(ItemStackGUI)
	inventory.insertSlot(index, ItemStackGUI.inventorySlot)
	

func takeItem():
	var item = ItemStackGUI
	
	inventory.removeSlot(ItemStackGUI.inventorySlot)
	
	container.remove_child(ItemStackGUI) 
	ItemStackGUI = null
	return item

func itemStackIsEmpty():
	return !ItemStackGUI
