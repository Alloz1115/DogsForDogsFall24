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
	var oldSlotName = slots[index].slotName
	slots[index] = InventorySlot.new()
	slots[index].foodType = oldSlotType
	slots[index].slotName = oldSlotName

func insertSlot(index: int, inventorySlot: InventorySlot):
	var oldSlotType = slots[index].foodType
	var oldSlotName = slots[index].slotName
	slots[index] = inventorySlot
	slots[index].foodType = oldSlotType
	slots[index].slotName = oldSlotName
