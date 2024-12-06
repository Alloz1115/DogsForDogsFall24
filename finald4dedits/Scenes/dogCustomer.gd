extends CharacterBody2D

var order_card = load("res://Scenes/order_card.tscn")
@onready var inventory: Inventory = preload("res://inventory.tres")
@onready var inventoryGUI = $"../InventoryGUI"
@onready var slots: Array = $"../InventoryGUI/Container".get_children()
@export var entryDelaySeconds: int = 0
var goToXMinimum = 100
var goToXMaximum = 800
# TODO create these export variables:
@export var numHotDogs: int = 0
@export var numKetchup: int = 0
@export var numMayo: int = 0
@export var numRelish: int = 0
@export_enum("NONE", "COLA", "ROOTBEER", "WATER") var drinkType: int
var customerName: String

func _ready():
	var goToX = randi_range(goToXMinimum, goToXMaximum)
	# create tween from current position to random int x value
	# wait for x seconds, then tween to player's view
	await get_tree().create_timer(entryDelaySeconds).timeout
	# play dog bark sfx
	var tween = get_tree().create_tween()
	# move to player's view
	tween.tween_property(self, "position", Vector2(goToX, self.global_position.y), 3).set_ease(Tween.EASE_OUT)

# fix animation
func _on_button_pressed():
	var ticketSlots = get_tree().get_nodes_in_group("Ticket Slot")

	var ticketType = 4
	var availableTicketSlots = ticketSlots.filter(func(slot): return slot.isEmpty())
	if !availableTicketSlots.is_empty():
		# gets first available node
		var firstAvailableNode = availableTicketSlots[0]
		var newOrderTicket = InventorySlot.new()
		newOrderTicket.foodType = ticketType

		# TODO get string customerName with self.get_path()
		customerName = self.get_path()

		newOrderTicket.createNewSlot(numHotDogs, numKetchup, numMayo, numRelish, drinkType)
		newOrderTicket.customerName = self.get_name()
		var firstNodeIndexNumber = slots.find(firstAvailableNode)
		# set customer name to slot
		inventory.slots[firstNodeIndexNumber].customerName = customerName
		
		inventory.insertSlot(firstNodeIndexNumber, newOrderTicket)
		inventoryGUI.updateForSpecificSlot(firstNodeIndexNumber)
		
		# destroy button so it doesn't make duplicate tickets
		print(str(inventory.slots[firstNodeIndexNumber].customerName))
		$Button.queue_free()

# this function should only be called when this customer's order
# is submitted 
# TODO update this to have updated parameters
# (customerName: string) - has absolute path of specific dogCustomer instance
func moveAway():
	var tween = get_tree().create_tween()
	# move to player's view
	tween.tween_property(self, "position", Vector2(-50, self.global_position.y), entryDelaySeconds).set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(entryDelaySeconds).timeout
	queue_free()
