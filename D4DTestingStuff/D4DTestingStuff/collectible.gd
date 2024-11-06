extends Area2D
# should be attached to items
@export var itemRes: InventoryItem

func collect(inventory: Inventory):
	inventory.insert(itemRes)
	# may have to change this later
	queue_free()
