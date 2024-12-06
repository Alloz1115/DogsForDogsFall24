extends Resource

class_name InventorySlot

@export_enum("GRILL", "DISPENSER", "EMPTY", "PLATE", "TICKET", "TRASH", "WATER", "COLA", "ROOTBEER",
"HOTDOGBOX", "BUNBOX", "KETCHUPBOX", "MAYOBOX", "RELISHBOX", "CUPBOX") var slotName: int
@export var item: Array[InventoryItem]
@export_enum("FOOD", "DRINK", "GRILL", "BOX", "DISPENSER", "TICKET", "TRASH") var foodType: int
var customerName: String
# preloaded images
var hotDogRawTexture = load("res://sprites/hotDogs/hotDogRaw.png")
var hotDogCookedTexture = load("res://sprites/hotDogs/hotDogCooked.png")
var bunTexture = load("res://sprites/bun.png")
var ketchupTexture = load("res://sprites/toppings/ketchup.png")
var mayoTexture = load("res://sprites/toppings/mayo.png")
var relishTexture = load("res://sprites/toppings/relish.png")
var colaTexture = load("res://sprites/cups/cupCola.png")
var rootBeerTexture = load("res://sprites/cups/cupRootBeer.png")
var waterTexture = load("res://sprites/cups/cupWater.png")
var emptyCupTexture = load("res://sprites/cups/cupEmpty.png")
var drinkArray = [colaTexture, rootBeerTexture, waterTexture]

func createNewSlot(numHotDogs: int, numKetchup: int, numMayo: int, numRelish: int, drinkType: int):
	# for this function, need to load the sprites for cooked hot dog, toppings, 
	# bun, and drink
	slotName = 3
	
	if drinkType != 0:
		var newDrink = InventoryItem.new()
		var newDrinkResourcePath = drinkArray[drinkType].resource_path
		newDrink.name = newDrinkResourcePath.get_file().get_basename()
		newDrink.texture = drinkArray[drinkType]
		item.append(newDrink)
	# assumes there is only 1 hot dog bun perorder
	var newBun = InventoryItem.new()
	newBun.name = "bun"
	newBun.texture = bunTexture
	item.append(newBun)
	for hotDogs in numHotDogs: 
		var newHotDog = InventoryItem.new()
		newHotDog.name = "hotDog"
		newHotDog.texture = hotDogCookedTexture
		item.append(newHotDog)
	for ketchup in numKetchup:
		var newKetchup = InventoryItem.new()
		newKetchup.name = "ketchup"
		newKetchup.texture = ketchupTexture
		item.append(newKetchup)
	for mayo in numMayo:
		var newMayo = InventoryItem.new()
		newMayo.name = "mayo"
		newMayo.texture = mayoTexture
		item.append(newMayo)
	for relish in numRelish:
		var newRelish = InventoryItem.new()
		newRelish.name = "relish"
		newRelish.texture = relishTexture
		item.append(newRelish)
	

func replaceBoxItem(itemType: int):
	var newItem = InventoryItem.new()
	match itemType:
		9: # index for HOTDOGBOX
			newItem.name = "hotDog"
			newItem.texture = hotDogRawTexture
		10: #BUNBOX
			newItem.name = "bun"
			newItem.texture = bunTexture
		11: #KETCHUPBOX
			newItem.name = "ketchup"
			newItem.texture = ketchupTexture
		12: # MAYOBOX
			newItem.name = "mayo"
			newItem.texture = mayoTexture
		13: # RELISHBOX
			newItem.name = "relish"
			newItem.texture = relishTexture
		14: # CUPBOX
			newItem.name = "emptyCup"
			newItem.texture = emptyCupTexture
	
	item.append(newItem)

func isNotStacked():
	return item.size() < 2 && item.size() > 0
