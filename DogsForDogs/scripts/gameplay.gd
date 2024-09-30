extends Node2D
# logic for main gameplay

var orderCardInSubmissionArea = false
var currentOrderCard = null
var numOfCustomers = 0
signal checkIfAllOrdersDone(customers_served)
signal levelComplete
var customersServed : int = 0
var items = ["bunChoice", "hotDogChoice", "toppingsChoice", "drinkChoice"]


# Called when the node enters the scene tree for the first time.
func _ready():
	# hide level menu
	$levelMenu.hide()
	# prints the amount of customers in current scene
	levelComplete.connect(_on_level_complete)
	var arrayNumCustomers = get_tree().get_nodes_in_group("customer")
	if arrayNumCustomers.is_empty():
		print("There are no customers")
	else:
		# debug string
		print("There are currently " + str(arrayNumCustomers.size()) + " customers.")
		# save amount of customers present 
		numOfCustomers = arrayNumCustomers.size()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if orderCardInSubmissionArea and !Input.is_action_pressed("click"):
		# send order card data here to use in process_order
		var cardData = currentOrderCard.get_parent().sendCardData()
		var customerName = currentOrderCard.get_parent().orderName
		# get card's customerName 
		process_order(customerName, cardData)
		# get dogCustomer associated with cardData
		# after processing order, remove orderCard
		currentOrderCard.get_parent().queue_free()

# sets currentOrderCard to the submitted order card when a card is submitted
# assumes that any and all area2D are either orderSubmit area or orderCard area
func _on_order_submit_area_entered(area):
	orderCardInSubmissionArea = true
	currentOrderCard = area

# set currentOrderCard to null if there is no order card in the submission area
func _on_order_submit_area_exited(area):
	orderCardInSubmissionArea = false
	currentOrderCard = null

# show level menu if level is complete
func _on_level_complete():
	get_tree().paused = true
	$levelMenu.show()

# run ending animation of whichever customer has the order name
# run signal to check if all customers are done
# get customer's order and compare it to current food sent
# also emits signal to end level if all orders have been completed
func process_order(customerName, cardData):
	# get the nodes in the "submitSlot" group (drink submit slot and hot dog submit slot)
	var dataInSubmitSlots = get_tree().get_nodes_in_group("submitSlot")
	
	# here, the 0th dataInSubmitSlots is HotDog slot
	# 1st dataInSubmitSlots is drink slot
	# gets texture nodes
	var foodSlotNode = dataInSubmitSlots[0]
	var drinkSlotNode = dataInSubmitSlots[1]
	
	# TODO : check if there is a textureRect child in foodSlotNode
	var foodSubmission = get_node("orderSubmit/hotDogSubmitSlot/TextureRect")
	if foodSubmission.texture == null:
		print("there are NO foods in the food submission slot")
	else:
		print("there is food in the food submission slot")


	# TODO : check if there is a textureRect child in drinkSlotNode
	var drinkSubmitted = get_node("orderSubmit/drinkSubmitSlot/TextureRect")
	if drinkSubmitted.texture == null:
		print("there are NO drinks in the drink submission slot")
	else:
		print("there is a drink in the drink submission slot")
	
	
	
	# check if all orders are done and end level if true
	customersServed += 1
	print(str(customersServed) + " customers have been served")
	emit_signal("checkIfAllOrdersDone", customersServed)
	if(customersServed == numOfCustomers):
		levelComplete.emit()
