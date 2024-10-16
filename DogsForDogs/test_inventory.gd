extends Resource

class_name Inventory

signal updated

@export var slots: Array[InventorySlot]

# what if there are multiple inventory items to insert?
# item is itemInHand (itemStackGUI) in testInventoryGUI
# itemInHand has inventorySlot
# func insert(item: InventoryItem)
func insert(item: InventorySlot):
	print("INSERT FUNCTION CALLED")
	# get the itemSlot
	var targetItemSlot = slots.filter(func(slot): return slot.item == item)
	# if targetItemSlot is found
	if(!targetItemSlot.is_empty()):
		var emptySlots = slots.filter(func(slot): return slot.item == null)
		if emptySlots.is_empty():
			targetItemSlot.inventorySlotItems.append_array(item)
	
	# update the GUI 
	print("this function has been called")
	
	updated.emit()

# TODO might have to change this and next
func removeSlot(inventorySlot: InventorySlot):
	var index = slots.find(inventorySlot)
	if index < 0: return
	slots[index] = InventorySlot.new()

func insertSlot(index: int, inventorySlot: InventorySlot):
	slots[index] = inventorySlot
