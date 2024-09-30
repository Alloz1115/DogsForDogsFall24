extends PanelContainer
@export var canDuplicate: bool = false
@export_enum("BUN:0", "HOTDOG:1", "TOPPINGS:2", "DRINK:3") var slotType: int
@onready var texture_rect = $TextureRect
var DRINK = 4
var spacingBetweenItems = 20
var items = ["bunChoice", "hotDogChoice", "toppingsChoice", "drinkChoice"]
# NEED TO CHANGE THIS LATER
var slotData = {
		"bunChoice" = 0,
		"hotDogChoice" = 0,
		"toppingsChoice" = 0, # this may get turned into an array later
		"drinkChoice" = 0
	}
# TODO change metadata on textures when swapping occurs

func _ready():
	# set up cardData dictionary
	if($TextureRect.texture != null):
		slotData[slotType] = 1
		print("slot added")
		# get slotType and add it 


func _get_drag_data(at_position):
	set_drag_preview(get_preview())
	return texture_rect
 
func _can_drop_data(_pos, data):
	if "slotType" in data.get_parent():
		var isSameType = data.get_parent().slotType == slotType
		if isSameType && slotType == DRINK:
			return true
		elif slotType != DRINK && data.get_parent().slotType != DRINK:
			return true
	return false

# drops data depending on onlyDataCanDuplicate or neitherSpaceDuplicates is true
# then checks if destination space is occupied
# if true, then textures are stacked instead of exchanged
func _drop_data(_pos, data):
	var destinationTextureNode = %TextureRect
	var spaceIsOccupied = destinationTextureNode.texture != null
	var onlyDataCanDuplicate = data.get_parent().canDuplicate && !destinationTextureNode.get_parent().canDuplicate
	var neitherSpaceDuplicates = !(data.get_parent().canDuplicate || destinationTextureNode.get_parent().canDuplicate)
	# if neither of the areas involved have the canDuplicate set to true, proceed
	if onlyDataCanDuplicate || neitherSpaceDuplicates:
		if spaceIsOccupied: 
			# STACK 
			# gets num of current children in destination area
			# if only data can duplicate, get type of dataSlot it is and then add one of that type to data
			# if neither space duplicates, stack by getting data from dataSlot
			print("SPACE IS OCCUPIED")
			# get child count and create another child
			var numOfCurrentChildren = destinationTextureNode.get_child_count(false)
			# var newTextureChild = TextureRect.new()
			var newTextureChild = $TextureRect.duplicate()
			newTextureChild.texture = texture_rect.texture
			newTextureChild.mouse_filter = 1
			destinationTextureNode.add_child(newTextureChild)
			# add rest of children nodes, if any 
			var arrayOfData = data.get_children(false)
			# moves all nodes in data to destinationTextureNode
			for index2 in arrayOfData:
				index2.reparent(destinationTextureNode, false)
			# readjust positions of child nodes here
			var childrenToReadjust = destinationTextureNode.get_children(false)
			var intIterator = 1
			# get position of self
			var startingPoint = self.global_position.y
			for children in childrenToReadjust:
				#reset position, then readjust'
				print("READJUSTING")
				children.global_position.y = startingPoint
				print(children.global_position.y)
				children.global_position.y -= spacingBetweenItems * intIterator
				intIterator += 1
			# makes original area null if it is not canDuplicate
			if !onlyDataCanDuplicate: data.texture = null
			print(destinationTextureNode.get_child_count(false))
		# if the destination space is not occupied, swap textures
		elif !onlyDataCanDuplicate && !spaceIsOccupied:
			# begins swap
			var temp = texture_rect.texture 
			texture_rect.texture = data.texture
			data.texture = temp
			var arrayOfData = destinationTextureNode.get_children(false)
			var arrayOfTextureRect = data.get_children(false)
			for index in arrayOfTextureRect:
				index.reparent(destinationTextureNode, false)
			for index2 in arrayOfData:
				index2.reparent(data, false)
		# transers, but does not swap
		elif onlyDataCanDuplicate && !spaceIsOccupied:
			var temp = texture_rect.texture 
			texture_rect.texture = data.texture
		# recount amount of textures here and update dictionary
		var firstArray = destinationTextureNode.get_children(false)
		var secondArray = data.get_children(false)
		# clear dictionary first
		for ind in slotData:
			slotData[ind] = 0
		for index in firstArray:
			var slot = index.get_meta("slotType") # get the entry in an array
			var dictionarySlot = items[slot]
			slotData[dictionarySlot] = slotData[dictionarySlot] + 1
		print(slotData)

func get_preview():
	# could update this to show the current hot dog
	var preview_texture = TextureRect.new()
	preview_texture.texture = texture_rect.texture
	preview_texture.expand_mode = 1
	preview_texture.size = Vector2(30,30)
	var preview = Control.new()
	preview.add_child(preview_texture)
	return preview
