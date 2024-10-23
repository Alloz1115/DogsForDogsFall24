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
			#var newNode = itemSprite.duplicate()
			var newNode = Sprite2D.new()
			$".".add_child(newNode)
	
	resetChildrenPositions()
	
	var newNodesList = $".".get_children()
	print("NEW AMOUNT OF NODES IS " + str($".".get_child_count()))
	var baseYValue = $item.global_position.y
	for node in newNodesList.size():
		newNodesList[node].visible = true
		newNodesList[node].texture = inventorySlot.item[node].texture
		newNodesList[node].position += Vector2(0, 15*node)

func resetChildrenPositions():
	for child in $".".get_children():
		child.position = $".".position 
		#TODO minus position from 1/2 texture width and height?
