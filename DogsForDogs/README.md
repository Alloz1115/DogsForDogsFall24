# README - Dogs for Dogs
## Summary (9/30/24) - Please look at comments in the code for more detailed explanations
#### Starting the Game
* When running the game, there are six droppable areas, two draggable items (both are the godot logo), a white box in the lower left corner labeled order card submit slot, and a customer that walks in after 5 seconds. The player can drag and drop the godot textures into the slots, the infinite hot dog draggable being an infinite source and the finite drink slot not. The player has the click the "See order button" on the customer to get the order card for that customer. The player can stack the hot dog textures, and note that the drink textures cannot be dragged to a hot dog slot, and vice versa. Once the order card is dragged to the order card submission slot, the next level menu pops up. 
#### Draggable Objects 
* These are instances of the draggable_object scene. It was made with the help of [this tutorial](https://www.youtube.com/watch?v=8cV-5ByZLOE&t=64s).
#### Droppable Areas
* These are instances of the draggable_object scene. It was made with the help of [this tutorial](https://www.youtube.com/watch?v=8cV-5ByZLOE&t=64s).
* These have two variables visible from the inspector - CanDuplicate (is the droppable area an infinite source) and slot type (Bun, Hot Dog, Toppings, or Drink).
#### Dog Customer 
* These are instances of the dogCustomer scene. It has several variables visible from the inspector that dictate their hot dog order - Bun Amount, Hot Dog Amount, Ketchup Amount, Mustard Amount, Drink Type, and Entry Delay Seconds. When the game starts, the Dog Customer will wait the amount of seconds given in Entry Delay Seconds variable, then tween to the player's view. The Dog Customer has a child order button which creates an instance of an order card when pressed. The button is also deleted once pressed to prevent the creation of duplicate orders. 
#### Order Card
* An instance of an order card is created when the player clicks on a Dog Customer's order button. It has a child Item List that is meant to show the order. Whenever the order card is dragged around, it goes back up to the top of the screen unless it is in the submission slot. If the card is in the submission slot, the slot should read the order card's data and compare it with the hot dog submission slot and drink submission slot to make sure order is correct. 
#### Current Issues
* The menu with buttons "Next Level" and "Exit Game" do not work at the moment.
* The drag and drop for the items may occasionally break. 

## Plugins 
#### TODO Manager
* Adds a To-Do list to the editor dock. Comment keywords such as # TODO or # FIXME to add entries. [See here](https://www.youtube.com/watch?v=1AECMiOOyX0) for a video explaining the plugin. 
#### Dialogic 
* Plugin for creating and managing dialogue. [See here](https://www.youtube.com/watch?v=7PuPU0Mrl_g) for a video on how to use it. 
