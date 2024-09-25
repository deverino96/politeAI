extends Node2D  # or Control if you are using UI components

# Variable to store the amount of gold
var goldAmmount = 0

# Reference to the label node
onready var label = $Label  # Make sure the node name matches the label

# Function to handle button clicks
func _on_Button_pressed():
	# Increase the gold amount by 1 on each click
	gold += 1
	# Update the label to display the new amount of gold
	label.text = "Gold: %d" % gold
