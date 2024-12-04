extends Control

@onready var inventory: Inventory = preload("res://inventory.tres")
@onready var ItemStackGUIClass = preload("res://Scenes/item_stack_gui.tscn")
@onready var slots: Array = $Container.get_children()

var itemInHand: item_stack_gui
var ticketType: int = 4
signal orderSubmitted(accuracy, customerName)
var TRASH: int = 5
var GRILL: int = 0
var BOX: int = 2

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
	var itemStackGui: item_stack_gui = slots[index].itemStackGui
	var inventorySlot: InventorySlot = inventory.slots[index]
	var inventorySlotSize = inventory.slots[index].item.size()
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
		
		# first, throw away to trash if applicable
		# TODO add && itemInHand is not a ticket
		if inventory.slots[slot.index].slotName == TRASH:
			# how do I delete the instance? 
				itemInHand.queue_free()
				itemInHand = null
				print("Throwing away item...")
				return
		
		if itemInHand.inventorySlot.isNotStacked():
			# if food types are the same
			
				if inventory.slots[slot.index].slotName == GRILL:
					insertItemInSlot(slot)
					slot.itemStackGui.animationPlayer.play("testGrill")
					# play sizzling sound effect
				return
		else: 
			if inventory.slots[slot.index].foodType == itemInHand.inventorySlot.foodType:
				insertItemInSlot(slot)
				return
	
	if !itemInHand:
		# stop hot dog grilling animation if slotName == "GRILL"
		if inventory.slots[slot.index].slotName == GRILL:
			slot.itemStackGui.animationPlayer.pause()
		takeItemFromSlot(slot)
		# note: this prevents the user from "taking" the item in infinite slots
		if inventory.slots[slot.index].foodType == BOX:
			inventory.slots[slot.index].replaceBoxItem(itemInHand.inventorySlot.slotName)
			updateForSpecificSlot(slot.index)
		return
	
	if inventory.slots[slot.index].foodType == itemInHand.inventorySlot.foodType:
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
	return 0
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
	var drinkSlot = get_tree().get_nodes_in_group("Drink Submit Slot")[0]
	var drinkSlotIndex = slots.find(drinkSlot)
	var ticketSlot = get_tree().get_nodes_in_group("Ticket Submit Slot")[0]
	var ticketSlotIndex = slots.find(ticketSlot)
	var foodSlot = get_tree().get_nodes_in_group("Hot Dog Submit Slot")[0]
	var foodSlotIndex = slots.find(foodSlot)
	var accuracy: int = 0
	
	if inventory.slots[ticketSlotIndex].item.is_empty(): return
	var customerName: String = inventory.slots[ticketSlotIndex].customerName
	var food = inventory.slots[foodSlotIndex].item
	var drink = inventory.slots[drinkSlotIndex].item
	var ticket = inventory.slots[ticketSlotIndex].item
	
	for x in inventory.slots[ticketSlotIndex].item.size() - 1:
		# if there are no more food items, end loop early
		if x >= food.size(): continue
		if ticket[x].slotName == food[x].slotName:
			accuracy += 1
	# compare drink and ticket
	if !(drink.is_empty()):
		if ticket[ticket.size()-1] == drink[0]: accuracy += 1
	
	# empty slots so that they can't be reused
	inventory.removeSlot(inventory.slots[ticketSlotIndex])
	inventory.removeSlot(inventory.slots[drinkSlotIndex])
	inventory.removeSlot(inventory.slots[foodSlotIndex])
	# check if the gui is updated after this
	updateForSpecificSlot(ticketSlotIndex)
	updateForSpecificSlot(foodSlotIndex)
	updateForSpecificSlot(drinkSlotIndex)
	ticketSlot.itemStackGui = null
	drinkSlot.itemStackGui = null
	foodSlot.itemStackGui = null
	
	emit_signal("orderSubmitted", accuracy, customerName)
