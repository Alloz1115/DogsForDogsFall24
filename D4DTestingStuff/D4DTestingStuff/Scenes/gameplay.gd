extends Node2D
var numOfCustomers : int = 0
var customersServed : int = 0
signal checkIfAllOrdersDone(customers_served)
signal levelComplete


# run this function whenever an order is submitted
func orderSubmitted():
	customersServed += 1
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

# hide()
# when all groups are affected, pause game and put up menu to next level
# when a card is deleted, 
func checkStuff():
	# var customerArr = get_nodes_in_group("customers")
	# if customerArr == null OR customerArr.empty()
	# pause game, put up menu to next level
	pass
