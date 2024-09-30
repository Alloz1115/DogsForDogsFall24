extends Node2D
# TODO get rid of metadata on textureRect, replace with saving variable as 
# load path for each texture image
# TODO change slotType enum to DRINK, NON-DRINK
var orderCardInArea = false
var currentOrderCard = null
var numOfCustomers = 0
signal checkIfAllOrdersDone(customers_served)
signal levelComplete
var customersServed : int = 0
var items = ["bunChoice", "hotDogChoice", "toppingsChoice", "drinkChoice"]
var orderSubmissionData = {
		"bunChoice" = 0,
		"hotDogChoice" = 0,
		"toppingsChoice" = 0, # this may get turned into an array later
		"drinkChoice" = 0
	}

# Called when the node enters the scene tree for the first time.
func _ready():
	# hide level menu
	$levelMenu.hide()
	# prints the amount of customers in current scene
	levelComplete.connect(_on_level_complete)
	var array = get_tree().get_nodes_in_group("customer")
	if array.is_empty():
		print("There are no customers")
	else:
		print(array.size())
		numOfCustomers = array.size()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if orderCardInArea and !Input.is_action_pressed("click"):
		# send order card data here to use in process_order
		var cardData = currentOrderCard.get_parent().sendCardData()
		var customerName = currentOrderCard.get_parent().orderName
		# get card's customerName 
		process_order(customerName, cardData)
		# get dogCustomer associated with cardData
		# after processing order, remove orderCard
		currentOrderCard.get_parent().queue_free()

# assumes that any and all area2D are either orderSubmit area or orderCard area
func _on_order_submit_area_entered(area):
	orderCardInArea = true
	currentOrderCard = area

func _on_order_submit_area_exited(area):
	orderCardInArea = false
	currentOrderCard = null

func _on_level_complete():
	get_tree().paused = true
	$levelMenu.show()

# run ending animation of whichever customer has the order name
# run signal to check if all customers are done
# get customer's order and compare it to current food sent
func process_order(customerName, cardData):
	var totalPoints = 0
	var dataInSubmitSlots = get_tree().get_nodes_in_group("submitSlot")
	# here, the 0th dataInSubmitSlots is HotDog slot
	# 1st dataInSubmitSlots is drink slot
	# gets texture nodes
	var foodSlotNode = dataInSubmitSlots[0]
	var drinkSlotNode = dataInSubmitSlots[1]
	
	# add foodSlotData and drinkSlotData to the orderSubmissionData
	# var iterator = 0
	# for index in foodSlotNode.slotData
		# var nextInOrderSubmissionData = items[iterator]
		# orderSubmissionData[nextInOrderSubmissionData] = foodSlotNode.slotData[index]
		# iterator ++ 
	
	var foodDictionaryData = foodSlotNode.get_meta("slotType")
	var drinkDictionaryData = drinkSlotNode.get_meta("slotType") # ERROR ADDS SLOT TYPE INSTEAD OF AMOUNT
	# orderSubmissionData["drinkChoice"] += drinkDictionaryData # ERROR ADDS SLOT TYPE INSTEAD OF AMOUNT
	print("printing before drink addition")
	print(orderSubmissionData)
	# check if there is a drink in the drink slot
	if drinkDictionaryData == 3:
		orderSubmissionData["drinkChoice"] += 1
	
	# check if there is food in the food slot
	if foodDictionaryData > 0 && foodDictionaryData < 3:
		var foodType = items[foodDictionaryData]
		orderSubmissionData[foodType] += 1
	
	print("printing served.....")
	print(orderSubmissionData)
	customersServed += 1
	print(customersServed)
	emit_signal("checkIfAllOrdersDone", customersServed)
	if(customersServed == numOfCustomers):
		levelComplete.emit()
	# get data from the food in the sorted area
	# at end, send signal to check if all orders are finished with checkIfAllOrdersDone.emit()

