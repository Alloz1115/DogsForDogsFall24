extends Resource

class_name InventorySlot


@export var inventorySlotItems: Array[InventoryItem] = []
@export_enum("FOOD", "DRINK") var slotType 

func isEmpty():
	return inventorySlotItems.is_empty()
