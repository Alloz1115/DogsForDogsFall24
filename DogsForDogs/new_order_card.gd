extends Resource

class_name order_card
var numHotDogs: int
var typeDrink: int
var order_cardUI = order_card_ui

# put items in above variables into this array
var orderItems = [numHotDogs, typeDrink]
# more variables for other items (toppings, etc) will be added later

# this should update the nodes 
func updateCardGUI():
	pass

func get_accuracy(order: order_card):
	var accuracy: int
	# do for loop for orderItems.size and increment accuracy for every match
	
	# return accuracy
	pass
