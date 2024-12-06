extends Control

@onready var inventory: Inventory = preload("res://inventory.tres")
@onready var ItemStackGUIClass = preload("res://Scenes/item_stack_gui.tscn")
@onready var slots: Array = $Container.get_children()

var itemInHand: item_stack_gui
var ticketType: int = 4
signal orderSubmitted(accuracy, customerName)
var TRASH: int = 5
var GRILL: int = 0
var BOX: int = 3
var TICKET: int = 4
var PLATE: int = 3

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
		if inventory.slots[slot.index].slotName == TRASH && itemInHand.inventorySlot.foodType != 5:
				itemInHand.queue_free()
				itemInHand = null
				print("Throwing away item...")
				return
		
		# if the current ItemInHand is not stacked
		if itemInHand.inventorySlot.isNotStacked():
			# if food types are the same
				print("item in hand is not stacked")
				if inventory.slots[slot.index].slotName == GRILL &&  itemInHand.inventorySlot.slotName == 9:
					insertItemInSlot(slot)
					slot.itemStackGui.animationPlayer.play("testGrill")
					# play sizzling sfx
					$AudioStreamPlayer2D.play()
					
					return
				if inventory.slots[slot.index].foodType == itemInHand.inventorySlot.foodType || (inventory.slots[slot.index].slotName == PLATE && itemInHand.inventorySlot.foodType ==0):
					print("testing line, don't mind me")
					insertItemInSlot(slot)
					return
				# toppings case
				if inventory.slots[slot.index].foodType == 0 && inventory.slots[slot.index].slotName == 3 && itemInHand.inventorySlot.foodType == 3:
					print("adding to plate...")
					insertItemInSlot(slot)
					return
				# cup case
				# if slot foodType is 1 and itemInHand slotName is 14
				if inventory.slots[slot.index].foodType == 1 && itemInHand.inventorySlot.slotName == 14:
					print("inserting cup...")
					insertItemInSlot(slot)
					return
		else: 
			# only insert if slotName is PLATE
			#if inventory.slots[slot.index].foodType == itemInHand.inventorySlot.foodType:
			if inventory.slots[slot.index].foodType == PLATE:
				insertItemInSlot(slot)
				return
			# ticket case 
			if inventory.slots[slot.index].foodType == 5 && itemInHand.inventorySlot.foodType == 5:
				insertItemInSlot(slot)
				return
			if inventory.slots[slot.index].foodType == 0 && inventory.slots[slot.index].slotName == 5 && itemInHand.inventorySlot.foodType == 0:
				print("adding to plate...")
				insertItemInSlot(slot)
				return

	else:
		if itemInHand:
			if inventory.slots[slot.index].foodType == 0 && inventory.slots[slot.index].slotName == 3 && itemInHand.inventorySlot.foodType == 3:
				print("adding to plate...")
				stackItems(slot)
				return
			if inventory.slots[slot.index].foodType == 0 && itemInHand.inventorySlot.foodType == 0:
				stackItems(slot)
				return
		# stacking hot dogs
		
		# we know that all boxes are not empty
			print("foodType" + str(inventory.slots[slot.index].foodType))
			if inventory.slots[slot.index].foodType == BOX:
				print("Item is a box, returning...")
				return
		
	
	if !itemInHand:
		# stop hot dog grilling animation if slotName == "GRILL"
		if inventory.slots[slot.index].slotName == GRILL:
			slot.itemStackGui.animationPlayer.pause()
		takeItemFromSlot(slot)
		# note: this prevents the user from "taking" the item in infinite slots
		if inventory.slots[slot.index].foodType == BOX:
			print("slot name is "+ str(itemInHand.inventorySlot.slotName))
			inventory.slots[slot.index].replaceBoxItem(itemInHand.inventorySlot.slotName)
			updateForSpecificSlot(slot.index)
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
	var accuracy: int = 0
	var Ticket_node = get_tree().get_nodes_in_group("Ticket Submit Slot")[0]
	var HotDog_node = get_tree().get_nodes_in_group("Hot Dog Submit Slot")[0]
	var Drink_node = get_tree().get_nodes_in_group("Drink Submit Slot")[0]
	var index_ticket = slots.find(Ticket_node)
	var index_dog = slots.find(HotDog_node)
	var index_drink = slots.find(Drink_node)
	
	# might not have food or drink
	# if food array is empty, skip
	# else for x in min(ticket array - 1, hot dog array - 1
	if !(inventory.slots[index_dog].item.is_empty()):
		for x in min(inventory.slots[index_ticket].item.size() - 1, inventory.slots[index_dog].item.size() -1):
			if inventory.slots[index_ticket].item[x].name == inventory.slots[index_dog].item[x].name:
				accuracy += 1
	
	if !(inventory.slots[index_drink].item.is_empty()):
		if inventory.slots[index_drink].item[-1].name == inventory.slots[index_drink].item[-1].name:
				accuracy += 1
	print ("Accuracy is " + str(accuracy))
	return accuracy / inventory.slots[index_ticket].item.size()


func _input(event):
	updateItemInHand()


func _on_submit_order_pressed():
	var drinkSlot = get_tree().get_nodes_in_group("Drink Submit Slot")[0]
	var drinkSlotIndex = slots.find(drinkSlot)
	var ticketSlot = get_tree().get_nodes_in_group("Ticket Submit Slot")[0]
	var ticketSlotIndex = slots.find(ticketSlot)
	var foodSlot = get_tree().get_nodes_in_group("Hot Dog Submit Slot")[0]
	var foodSlotIndex = slots.find(foodSlot)
	var accuracy =  determineAccuracy()
	if inventory.slots[ticketSlotIndex].item.is_empty(): return
	var customerName: String = inventory.slots[ticketSlotIndex].customerName
	var food = inventory.slots[foodSlotIndex].item
	var drink = inventory.slots[drinkSlotIndex].item
	var ticket = inventory.slots[ticketSlotIndex].item
	
	for x in inventory.slots[ticketSlotIndex].item.size() - 1:
		# if there are no more food items, end loop early
		if x >= food.size(): continue
		if ticket[x].name == food[x].name:
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
