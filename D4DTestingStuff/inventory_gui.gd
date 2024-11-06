extends Control

@onready var inventory: Inventory = preload("res://inventory.tres")
@onready var ItemStackGUIClass = preload("res://item_stack_gui.tscn")
@onready var slots: Array = $Container.get_children()

var itemInHand: item_stack_gui
var ticketType: int = 4

# import 
signal checkIfAllOrdersDone(customers_served)
signal levelComplete
var customersServed : int = 0
var numOfCustomers : int = 0


func _ready():
	connectSlots()
	inventory.updated.connect(update)
	update()
	
	$levelMenu.hide()
	# prints the amount of customers in current scene
	levelComplete.connect(_on_level_complete)
	var array = get_tree().get_nodes_in_group("customers")
	if array.is_empty():
		print("There are no customers")
	else:
		print("There are " + str(array.size()) + " customers.")
		numOfCustomers = array.size()


func submitOrder():
	customersServed += 1
	print(customersServed)
	emit_signal("checkIfAllOrdersDone", customersServed)
	if(customersServed == numOfCustomers):
		levelComplete.emit()

func _on_level_complete():
	get_tree().paused = true
	$levelMenu.show()
	
# initial update for all slots
func update():
	print("inventory slots size " + str(inventory.slots.size()))
	print("slots size " + str(slots.size()))
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
	var amount: int = itemInHand.inventorySlot.item.size()
	
	slotItem.inventorySlot.item.append_array(itemInHand.inventorySlot.item)
	
	# TODO change this from idk man 
	remove_child(itemInHand)
	itemInHand = null
	
	slotItem.update()
	if itemInHand: itemInHand.update()

func updateItemInHand():
	if !itemInHand: return
	itemInHand.global_position = get_global_mouse_position()

func _input(event):
	updateItemInHand()


func _on_submit_button_pressed():
	var foodSubmitSlot = get_tree().get_nodes_in_group("Food Submit")
	var drinkSubmitSlot = get_tree().get_nodes_in_group("Drink Submit")
	var ticketSubmitSlot = get_tree().get_nodes_in_group("Ticket Submit")
	
	if ticketSubmitSlot[0].CenterContainer.get_child_count() == 0:
		print("Ticket Submit Slot is Empty")
		return
	
	# get index to use in inventory
	var index: int = slots.find(foodSubmitSlot)
	
	# start comparing
	# if ticketSubmitSlot.CenterContainer.get_child_count() == 0 

	# for order card slot, have something similar to slot_gui and compare with item[index].name
	# var accuracy: int
	# for items in orderCardSlot.item.size()-1 (to account for drink):
	# DO THIS INSTEAD for itemIndex in min(foodSubmitSlot.item.size(), ticketSubmitSlot.item.size())
		# if foodSubmitSlot.item.size(), ticketSubmitSlot.item.size(): print("Food is not accurate")
		# if item[itemIndex].name == foodSlot[itemIndex].name
		# accuracy ++
	# these should match to the same drink
	# if orderCardSlot.item[orderCardSlot.item.size()-1].inventoryItem.name == drinkSlot.inventoryItem.name 
		# accuracy ++
	#print(accuracy)
	# TODO when order card is made, update customerOrderName to file name of customer
	# when order submit, get node using file name to trigger customer events
