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
		
		if itemInHand.inventorySlot.isNotStacked():
			# insertItemInSlot(slot)
			# TODO add to another conditional 
			# if slot.inventorySlot.slotName == "GRILL" (which equals 0) 
				# then start grilling animation with slot.AnimationPlayer.play(animationName)
			
			# debugging statement
			print("Slot is not stacked")
		
		if inventory.slots[slot.index].foodType == itemInHand.inventorySlot.foodType:
			# TODO if inventory.slots[slot.index].slotType == "TRASH"
				# set itemInHand to null (trash should delete whatever is put in it)
			print("FOOD TYPES MATCH")
			insertItemInSlot(slot)
		return
	
	if !itemInHand:
		# TODO if slot.isInfinite == true, 
			#then itemInHand = slot.Container.itemStackGui
			# return
			# note: this prevents the user from "taking" the item in infinite slots
		takeItemFromSlot(slot)
		return
	
	if slot.itemStackGui.inventorySlot.foodType == itemInHand.inventorySlot.foodType:
		# TODO update function to skip stacking if foodType is ticket 
		# OR slotType is "DRINK" OR slotType is "GRILL" OR slotType is "BOX"
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

func determineAccuracy():
	pass
	# get food/drink/submit slot the same way as in _on_submit_order_pressed()
	# use inventory.find(node) to get int index of node in inventory for food/drink/ticket
	# use indexes to get slot data on food/drink/ticket with inventory[index]
	# loop through ticket slot's data with for x in inventory[ticketIndex].item.size() - 1
		# compare the name of ticket.item[x].slotName == food.item[x].slotName
		# if they are the same, increase int accuracy by 1
	# compare ticket.item[lastIndex].slotName == drink.item[lastIndex].slotName
	# if they are the same, increase int accuracy by 1
	# return accuracy / ticket.item.size()

func _input(event):
	updateItemInHand()


func _on_submit_order_pressed():
	pass
	# when this button is pressed, get the food, drink and ticket submit slot
	# with get_nodes_in_group(food/drink/ticket submit slot). 
	# note: see HotDogSubmit/DrinkSubmit/TicketSubmit nodes in inventory_gui scene
	# if there is nothing in the ticket submission slot, then return to end function early
	# else get variable accuracy by running function determineAccuracy
	# then emit signal orderSubmitted to run function orderSubmitted in gameplay.gd
