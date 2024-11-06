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
		
		# TODO need to add to this conditional 
		# to check if slot.inventorySlot.slotName == "GRILL" (0) 
		# or "DRINK_DISPENSER" (1)
		if itemInHand.inventorySlot.isNotStacked():
			print("Slot is not stacked")
			# here, there will probably be a signal 
		
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
	add_child(itemInHand)
	updateItemInHand()

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
	slotItem.inventorySlot.item.append_array(itemInHand.inventorySlot.item)
	# makes itemInHand's slot items empty just in case
	itemInHand.inventorySlot.item.clear()
	
	remove_child(itemInHand)
	itemInHand = null
	
	slotItem.update()
	if itemInHand: itemInHand.update()

func updateItemInHand():
	if !itemInHand: return
	itemInHand.global_position = get_global_mouse_position()

# func when_submit_button_pressed
	# when this button is pressed, get the food, drink and ticket submit slot
	# with get_nodes_in_group(food/drink/ticket submit slot)
	# if there is nothing in the ticket submission slot, return
	# run function determineAccuracy
	# else emit signal and run orderSubmitted in the root node and 
	# return accuracy from determineAccuracy to (gameplay.gd)

func determineAccuracy():
	pass
	# use inventory.find(node) to get inventory data for 
	# food, drink, and ticket submission slots
	# then for loop through ticket data
		# compare inventoryItem names here 

func _input(event):
	updateItemInHand()
