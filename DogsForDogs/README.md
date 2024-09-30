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

## How to Contribute
* Make sure you have git installed on your computer before starting. [Please read this tutorial](https://www.freecodecamp.org/news/how-to-use-git-and-github-in-a-team-like-a-pro/) so you have an idea of how git works.
### Importing Code to Your Computer
* On your command line, use git clone (repo url). This should create a folder with this repo's content on your computer. 
* Go to Godot and select Import button on top of screen.
* Select the repo folder on your computer and select the .godot file to import.
### Pushing Code Back to Github 
* If you haven't already, create your own branch by going to the github repository, clicking on the main/branches button, typing a new branch name, and clicking "Create Branch: (your branch name)"
* Go to your project in your command line (for example you can use command "cd (path to project)).
* Use "git pull" to ensure that your remote repository branch and your local computer's repository are up to date.
* Use "git checkout (your branch name)" to switch to your branch. Use "git branch" to make sure you are working on your own branch.
* Edit your Godot project as normal. 
* When ready, stage the changes with "git add ."
* Commit the changes with "git commit -m "Your commit message here" (be sure to explain your changes via the commit message)
* Push the changes with "git push origin (your branch name)" *NOTE: DO NOT push to main directly and instead push to your own branch. Doing otherwise can cause problems later on*
* Pull requests and changes to main will be done later on. 
