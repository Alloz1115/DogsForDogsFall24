extends Resource

class_name InventorySlot

@export_enum("GRILL", "DISPENSER", "PLATE", "TICKET") var slotName: int
@export var item: Array[InventoryItem]
@export_enum("FOOD", "DRINK", "GRILL+FOOD", "DISPENSER+DRINK", "TICKET") var foodType: int

# TODO update this to be 
# desiredTopping is array for ketchup, mayo, and relish
# example [numKetchup: int, numMayo: int, numRelish: int]
#func createNewSlot(numHotDogs: int, desiredToppings: Array, typeDrink: int):
func createNewSlot():
	# for this function, need to load the sprites for cooked hot dog, toppings, 
	# bun, and drink
	slotName = 3
	# assumes there is only 1 hot dog bun perorder
	var numBuns = 1

	var testing = InventoryItem.new()
	testing.name = "testing"
	testing.texture = load("res://RectangleIconSlot.png")
	item.append(testing)
	
	# for hotDogs in numHotDogs: 
		# var newHotDog = InventoryItem.new()
		# newHotDog.name = "Hot Dog"
		# newHotDog.texture = load(pathToHotDogTexture)
		# item.append(newHotDog)
	# for ketchup in numKetchup:
		# var newKetchup = InventoryItem.new()
		# newKetchup.name = "Ketchup"
		# newKetchup.texture = load(pathToKetchupTexture)
		# item.append(newKetchup)
	# do same for mayo, relish
	
	# var newDrink = InventoryItem.new()
	# newDrink.name = pathToTexture.get_file()
	# newDrink.texture = load(pathToTexture)
	# item.append(newDrink)

	# TODO update this so that it creates a cohesive order
