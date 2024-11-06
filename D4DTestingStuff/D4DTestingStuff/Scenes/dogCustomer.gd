extends CharacterBody2D

#@onready var state_machine = $AnimationTree["parameters/playback"]
var order_card = load("res://Scenes/order_card.tscn")
@onready var inventory: Inventory = preload("res://inventory.tres")
@onready var inventoryGUI = $"../InventoryGUI"
@onready var slots: Array = $"../InventoryGUI/Container".get_children()
@export var entryDelaySeconds: int = 0
var goToXMinimum = 100
var goToXMaximum = 800

func _ready():
	var goToX = randi_range(goToXMinimum, goToXMaximum)
	# create tween from current position to random int x value
	# wait for x seconds, then tween to player's view
	await get_tree().create_timer(entryDelaySeconds).timeout
	var tween = get_tree().create_tween()
	# move to player's view
	tween.tween_property(self, "position", Vector2(goToX, self.global_position.y), 3).set_ease(Tween.EASE_OUT)

func _physics_process(_delta):
	pass

# fix animation
func _on_button_pressed():
	var ticketSlots = get_tree().get_nodes_in_group("Ticket Slot")

	var ticketType = 4
	# gets nodes that are part of 
	var availableTicketSlots = ticketSlots.filter(func(slot): return slot.isEmpty())
	#var availableTicketSlots = ticketSlots
	if !availableTicketSlots.is_empty():
		# gets first available node
		var firstAvailableNode = availableTicketSlots[0]
		var newOrderTicket = InventorySlot.new()
		newOrderTicket.foodType = ticketType

		newOrderTicket.createNewSlot()
		var firstNodeIndexNumber = slots.find(firstAvailableNode)
		# TODO this is not finding nodes correctly, 
		# it finds the 
		
		inventory.insertSlot(firstNodeIndexNumber, newOrderTicket)
		inventoryGUI.updateForSpecificSlot(firstNodeIndexNumber)
		
		# destroy button so it doesn't make duplicate tickets
		$Button.queue_free()
		print("BUTTON HAS BEEN ERASED")

# this function should only be called when this customer's order
# is submitted 
func moveAway():
	pass
	# create a tween here that moves customer off screen
	# when the tween is finished, delete this instance
