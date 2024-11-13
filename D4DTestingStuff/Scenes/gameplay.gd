extends Node2D
var numOfCustomers : int = 0
var customersServed : int = 0
#var numberOfCustomers: int = get_tree().get_nodes_in_group("customers").size()
signal checkIfAllOrdersDone(customers_served)
signal levelComplete


# this function runs whenever the orderSubmitted signal from 
# inventory_gui.gd is emitted
# TODO update parameters to have ticketSlot 
# orderSubmitted(ticket: Button)
func orderSubmitted():
	customersServed += 1
	
	# TODO get ticket's customerName with ticket.customerName
	# get dogCustomer with customerName with get_node(customerName)
	# run node's moveAway function to dismiss customer
	emit_signal("checkIfAllOrdersDone", customersServed)
	if(customersServed == numOfCustomers):
		levelComplete.emit()
		return

# Called when the node enters the scene tree for the first time.
func _ready():
	# hide level menu
	$levelMenu.hide()
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
