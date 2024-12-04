extends Node2D
var numOfCustomers : int = 0
var customersServed : int = 0
signal checkIfAllOrdersDone(customers_served)
signal levelComplete
@onready var inventory_gui = $InventoryGUI

# this function runs whenever the orderSubmitted signal from 
# inventory_gui.gd is emitted
func orderSubmitted(accuracy, customerName):
	customersServed += 1
	print("THIS IS A TEST FOR ORDER SUBMISSION")
	# TODO get ticket's customerName with ticket.customerName
	# run node's moveAway function to dismiss customer
	print("CUSTOMER TO BISMISS IS " + customerName)
	var customerToDismiss = get_node(customerName)
	customerToDismiss.moveAway()
	
	if(customersServed == numOfCustomers):
		$"levelMenu/CenterContainer/VBoxContainer/score".text = str(accuracy)
		_on_level_complete()
		# update score to $levelMenu.label
		return

# Called when the node enters the scene tree for the first time.
func _ready():
	# hide level menu
	$levelMenu.hide()
	inventory_gui.orderSubmitted.connect(orderSubmitted)
	# prints the amount of customers in current scene
	levelComplete.connect(_on_level_complete)
	var array = get_tree().get_nodes_in_group("customers")
	if array.is_empty():
		print("There are no customers")
	else:
		print("There are " + str(array.size()) + " customers.")
		numOfCustomers = array.size()

func _on_level_complete():
	get_tree().paused = true
	$levelMenu.show()
