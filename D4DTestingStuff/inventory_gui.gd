extends Control

@onready var inventory: Inventory = preload("res://inventory.tres")
@onready var ItemStackGUIClass = preload("res://item_stack_gui.tscn")
@onready var slots: Array = $Container.get_children()

var itemInHand: item_stack_gui
var ticketType: int = 4

func _ready():
	connectSlots()
	inventory.updated.connect(update)
	update()

# initial update for all slots
func update():
	for i in range(min(inventory.slots.size(), slots.size())):
		var inventorySlot: InventorySlot = inventory.slots[i]
		
		if inventorySlot.item.is_empty(): continue
		
		var itemStackGui: item_stack_gui = slots[i].itemStackGui
		if !itemStackGui:
			itemStackGui = ItemStackGUIClass.instantiate()
			slots[i].insert(itemStackGui)
		itemStackGui.inventorySlot = inventorySlot
		itemStackGui.update()

# updates a specific slot at index
func updateForSpecificSlot(index: int):
	#if slots[index].item.is_empty(): return
	var inventorySlot: InventorySlot = inventory.slots[index]
	if inventorySlot.item.is_empty(): return
	
	var itemStackGui: item_stack_gui = slots[index].itemStackGui
	if !itemStackGui:
		itemStackGui = ItemStackGUIClass.instantiate()
		slots[index].insert(itemStackGui)
	itemStackGui.inventorySlot = inventorySlot
	itemStackGui.update()

func connectSlots():
	for i in range(slots.size()):
		var slot = slots[i]
		slot.index = i
		var callable = Callable(onSlotClicked)
		callable = callable.bind(slot)
		slot.pressed.connect(callable)

func onSlotClicked(slot):
	if slot.isEmpty():
		if !itemInHand: return
		
		# TODO need to change so that the item[0] is checked and is only 1 entry 
		# && and slot is the grill
		# TODO need to change so if item[0].name == drinkName && item.size() == 1
		# && slot is the drink dispenser
		# this gets changed somehow when 
		if inventory.slots[slot.index].foodType == itemInHand.inventorySlot.foodType:
			print("FOOD TYPES MATCH")
			insertItemInSlot(slot)
		return
	
	# TODO change this to 
	if !itemInHand:
		takeItemFromSlot(slot)
		# TODO if slot.isInfinite == true, 
		# skip above takeItemFromSlot and do itemInHand = slot.takeItem()
		return
	
	if slot.itemStackGui.inventorySlot.foodType == itemInHand.inventorySlot.foodType:
		# skip stacking if foodType is ticket (tickets shouldn't stack)
		if itemInHand.inventorySlot.foodType == ticketType: return
		stackItems(slot)
		return

func takeItemFromSlot(slot):
	itemInHand = slot.takeItem()
	print("debugger")
	print(str(itemInHand.inventorySlot.item.size()))
	add_child(itemInHand)
	updateItemInHand()
	# itemInHand is still 0
	

func insertItemInSlot(slot):
	var item = itemInHand
	remove_child(itemInHand)
	itemInHand = null
	slot.insert(item)

func swapItems(slot):
	var tempItem = slot.takeItem()
	insertItemInSlot(slot)
	
	itemInHand = tempItem
	add_child(itemInHand)
	updateItemInHand()

func stackItems(slot):
	var slotItem: item_stack_gui = slot.itemStackGui
	var amount: int = itemInHand.inventorySlot.item.size()
	print("size of arr " + str(itemInHand.inventorySlot.item.size()))
	print("size of arr " + str(slotItem.inventorySlot.item.size()))
	slotItem.inventorySlot.item.append_array(itemInHand.inventorySlot.item)
	#change this to add item?
	# makes itemInHand's slot items empty just in case
	print("append completed, now " + str(slotItem.inventorySlot.item.size()))
	#itemInHand.inventorySlot.item.clear()
	
	# TODO change this from idk man 
	remove_child(itemInHand)
	itemInHand = null
	
	# TODO change this so that correctly renders the inventorySlot's item(s)
	slotItem.update()
	if itemInHand: itemInHand.update()

func updateItemInHand():
	if !itemInHand: return
	itemInHand.global_position = get_global_mouse_position()

func _input(event):
	updateItemInHand()
