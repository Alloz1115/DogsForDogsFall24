extends Panel

class_name item_stack_gui
var inventorySlot: InventorySlot
@onready var itemSprite: Sprite2D = $item

func update():
	if !inventorySlot || inventorySlot.item.is_empty(): return
	# go through inventorySlot.item array and update 
	var currentNumItemNodes = $".".get_children().size()
	var numSubItems = inventorySlot.item.size()
	
	#duplicates nodes 
	if currentNumItemNodes < numSubItems:
		for i in range(numSubItems - currentNumItemNodes):
			var newNode = Sprite2D.new()
			$".".add_child(newNode)
	
	resetChildrenPositions()
	
	var newNodesList = $".".get_children()
	print("NEW AMOUNT OF NODES IS " + str($".".get_child_count()))
	var baseYValue = $item.global_position.y
	for node in newNodesList.size():
		if !(newNodesList[node] is AnimationPlayer):
			newNodesList[node].visible = true
			newNodesList[node].texture = inventorySlot.item[node].texture
			newNodesList[node].position = Vector2(0, 15*node)

func resetChildrenPositions():
	for child in $".".get_children():
		if !(child is AnimationPlayer):
			child.position = $".".position 

# TODO might have to update these strings 
func updateItemName():
	var currentName = inventorySlot.item[0].name
	match currentName:
		"rawHotDog":
			currentName = "cookedHotDog"
		"cookedHotDog":
			currentName = "burntHotDog"
