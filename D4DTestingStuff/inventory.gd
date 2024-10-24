extends Resource

class_name Inventory

signal updated

@export var slots: Array[InventorySlot]

func insert(item: InventoryItem):
	for i in range(slots.size()):
		if slots[i].item.is_empty():
			# slots
			slots[i].push_back(item)
			updated.emit()
			return

func removeSlot(inventorySlot: InventorySlot):
	var index = slots.find(inventorySlot)
	if index < 0: return
	var oldSlotType = slots[index].foodType
	slots[index] = InventorySlot.new()
	slots[index].foodType = oldSlotType

	# might need to update GUI later idk what I'm doing dude

func insertSlot(index: int, inventorySlot: InventorySlot):
	slots[index] = inventorySlot

func checkOrderAccuracy():
	# get node 
	# have three 
	pass
	# TODO get the three slots, the order card slot, the drink slot, and food slot
	# use get nodes in group for this 
	# differentiate each node by searching up their slot name WITH var foodSlot = foodSubmissionGroup,
	# drinkSubmission group, and ticketSubmission group
	# for order card slot, have something similar to slot_gui and compare with item[index].name
	# var accuracy: int
	# for items in orderCardSlot.item.size()-1 (to account for drink):
		# if items.name == foodSlot[items].name
		# accuracy ++
	# these should match to the same drink
	# if orderCardSlot.item[orderCardSlot.item.size()-1].inventoryItem.name == drinkSlot.inventoryItem.name 
		# accuracy ++
	#print(accuracy)
	# idk what what is supposed to be here bruh
