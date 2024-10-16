extends Panel

class_name Item_stack_gui
#@onready var itemSprite: Sprite2D = $Item
@onready var inventory: Inventory = preload("res://testing/Inventory.tres")
@onready var ItemNode: Sprite2D = $Item
var inventorySlot: InventorySlot

var itemSpritesAmount: int
var itemSpriteArray

func _ready():
	pass

# makes sprites visible
func update():
	print("UPDATE FUNCTION IS CALLED")
	# checks if inventory slot exists
	if !inventorySlot || inventorySlot.inventorySlotItems.is_empty(): return
	
	#for slotTexture in inventorySlot.inventorySlotItems:
		# make itemSprite.texture the same as the current inventorySlot
	# FIXME texture doesn't show up until it is clicked
	# ready function needs to be called for some reason
	var itemSprite = $Item
	itemSprite.visible = true
	itemSprite.texture = inventorySlot.inventorySlotItems[0].texture

func updateStack(itemStackGUI: Item_stack_gui):
	print("UPDATING>>>>>>> PLEASE WAIT")
	var itemSprite = $Item
	if !inventorySlot || inventorySlot.inventorySlotItems.is_empty(): return
	itemSprite.texture = inventorySlot.inventorySlotItems[0].texture
	
	# checks if inventory slot exists
	#if !inventorySlot || inventorySlot.inventorySlotItems.is_empty(): return
	
	#var itemStackSlot = itemStackGUI.inventorySlot.inventorySlotItems.size()
	#var difference: int
	#itemSpritesAmount = $".".get_child_count()
	#var texturesNeeded = inventorySlot.inventorySlotItems.size() + itemStackSlot# TODO NEED TO ADD THE DROPPING AMOUNT
	## makes sprite visible
	#print("TOTAL UPDATE STACK AMOUNT IS " + str(texturesNeeded))
	#
	#var itemSprite = $Item
	
	##itemSpriteArray = get_children()
	## get amount of textures needed to insert AND get amount of current itemSprites
	#if texturesNeeded != itemSpritesAmount:
		#difference = texturesNeeded - itemSpritesAmount
		##create itemSprites difference times
		#if difference > 0: 
			#for i in abs(difference):
				#ItemNode.duplicate()
		#elif difference < 0:
			#for i in abs(difference):
				#itemSpriteArray.pop_back()
		#
	## then match textures 
	#if $".".get_child_count() == inventorySlot.inventorySlotItems.size():
		#for slotItemIndex in inventorySlot.inventorySlotItems.size():
			## commented for debug
			#itemSpriteArray[slotItemIndex].visible = true
			#itemSpriteArray[slotItemIndex].texture = inventorySlot.inventorySlotItems[slotItemIndex].texture
			#print("TEXTURE MATCH SUCCESS")
			#print(str(get_child_count()))
	#else: print("ERROR: Texture matching failed")
	#
	#print("AMOUNT OF CHILDREN IN CENTERCONTAINER")
	#print($".".get_child_count())
	#var multiplier: int = 0
	## readjusts positions
	#for itemNodes in get_children():
		#itemNodes.position.y += multiplier*30
