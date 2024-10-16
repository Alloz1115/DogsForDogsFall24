extends Control

@onready var inventory: Inventory = preload("res://testing/Inventory.tres")
@onready var ItemStackGUIClass = preload("res://item_stack_gui.tscn")

@onready var slots: Array = $".".get_children()
var inventorySlot: InventorySlot

var itemInHand: Item_stack_gui

#FIXME update function does not seem to work
func update():
	# goes through all buttons/slot on screen
	#inventory.slots.size()
	for i in slots.size():
		# goes to a button 
		inventorySlot = inventory.slots[i]
		# if slot is empty, continue
		if inventorySlot.isEmpty(): continue
		
		var itemStackGUI: Item_stack_gui = slots[i].ItemStackGUI
		if !itemStackGUI:
			itemStackGUI = ItemStackGUIClass.instantiate()
			# called by test_inventory
			slots[i].insert(itemStackGUI)
		
		# ERROR IS MOST LIKELY HERE
		itemStackGUI.inventorySlot = inventorySlot
		itemStackGUI.update()

func connectSlots():
	var slotIndex
	for i in range(slots.size()):
		var slot = slots[i]
		# TODO change this so that it is a for loop 
		# that goes through slots.size, then for slotItems in inventorySlotItems.(index).size
		slot.index = i
		
		var callable = Callable(onSlotClicked)
		callable = callable.bind(slot)
		slot.pressed.connect(callable)

func onSlotClicked(slot):
	print("SLOT IS CLICKED")

	if slot.itemStackIsEmpty():
	# if slot.inventorySlotItems.is_empty
		print("ITEM STACK IS EMPTY")
		if !itemInHand: return
		insertItemInSlot(slot)
		return
		
	if !itemInHand:
		# assumes slot is NOT empty
		print("SLOT IS NOT EMPTY")
		takeItemFromSlot(slot)
		return
		
	# TODO need to update if statement to allow better cases
	# code is assuming slot is not empty when it is
	# TODO change to ...inventorySlot.(index of slot).item.name
	# if slot.ItemStackGUI.inventorySlot.item.name == itemInHand.inventorySlot.item.name:
	if slot.ItemStackGUI.inventorySlot.slotType == itemInHand.inventorySlot.slotType:
		stackItems(slot)
		return 

	swapItems(slot)

func takeItemFromSlot(slot):
	itemInHand = slot.takeItem() # itemStackGUI
	add_child(itemInHand)
	updateItemInHand()

func insertItemInSlot(slot):
	var item = itemInHand # itemSlotGUI
	remove_child(itemInHand)
	itemInHand = null 
	slot.insert(item)
	# gui inventory is not updated? 

func swapItems(slot):
	print("ITEM SWAP")
	var tempItem = slot.takeItem()
	insertItemInSlot(slot)
	itemInHand = tempItem
	add_child(itemInHand)
	updateItemInHand()

func stackItems(slot):
	var slotItem: Item_stack_gui = slot.ItemStackGUI
	# FIXME itemInHand should be brought over, not deleted
	
	#slotItem.updateStack(itemInHand)
	remove_child(itemInHand)
	itemInHand = null
	
	slotItem.update()
	if itemInHand: itemInHand.update()


func updateItemInHand():
	if !itemInHand: return
	itemInHand.global_position = get_global_mouse_position()

# this might make things dissapear
func _input(event):
	updateItemInHand()

# Called when the node enters the scene tree for the first time.
func _ready():
	connectSlots()
	inventory.updated.connect(update)
	update()
