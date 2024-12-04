extends Panel

class_name item_stack_gui
var inventorySlot: InventorySlot
@onready var itemSprite: Sprite2D = $item
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

func update():
	if !inventorySlot: 
		return
	# go through inventorySlot.item array and update 
	var currentItemNodes = $CenterContainer.get_children()
	var currentNumItemNodes = currentItemNodes.size()

	var numSubItems = inventorySlot.item.size()
	
	if numSubItems == 0:
		for child in $CenterContainer.get_children():
			child.queue_free()
		# delete ALL children in CenterContainer
	
	#duplicates nodes 
	if currentNumItemNodes < numSubItems:
		for i in range(numSubItems - currentNumItemNodes):
			var newNode = Sprite2D.new()
			$CenterContainer.add_child(newNode)
	
	if currentNumItemNodes > numSubItems:
		var difference = currentNumItemNodes - numSubItems
		for i in range(difference):
			var removeNode = currentItemNodes[i]
			$CenterContainer.remove_child(removeNode)
			removeNode.queue_free()

	resetChildrenPositions()
	
	var newNodesList = $CenterContainer.get_children()
	if newNodesList.is_empty(): return
	if numSubItems == 0:
		return
	var baseYValue = $CenterContainer/item.global_position.y
	for node in newNodesList.size():
		newNodesList[node].visible = true
		newNodesList[node].texture = inventorySlot.item[node].texture
		newNodesList[node].position = Vector2(0, 15*node)

func resetChildrenPositions():
	for child in $CenterContainer.get_children():
		child.position = $".".position 

# TODO might have to update these strings 
func updateItemName():
	var currentName = inventorySlot.item[0].name
	match currentName:
		"hotDogRaw":
			currentName = "hotDogCooked"
		"hotDogCooked":
			currentName = "hotDogBurnt"
