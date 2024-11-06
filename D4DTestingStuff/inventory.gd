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
	
