extends Node2D
# 1. Grab references to your three reel nodes in the tree
onready var reel1 = $Reel1
onready var reel2 = $Reel2
onready var reel3 = $Reel3
onready var roll_button = $Button # Change "$Button" to whatever your button's exact name is!
onready var result_popup = $ResultLayer/ResultPopup
var loss_messages = [
	"Try again!",
	"Not today!",
	"No luck here...",
	"Sorry!",
	"At least it's free!"
]

func _on_Button_pressed():
	roll_button.disabled = true

	# Start all 3 reels zooming at the same time
	reel1.start_spinning()
	reel2.start_spinning()
	reel3.start_spinning()
	
	# --- THE AUTOMATIC CASCADE TIMERS ---
	
	# Let them spin for 2 seconds, then kill Reel 1
	yield(get_tree().create_timer(2.0), "timeout")
	reel1.stop_spinning()
	
	# Wait 0.8 more seconds, then kill Reel 2
	yield(get_tree().create_timer(0.8), "timeout")
	reel2.stop_spinning()
	
	# Wait a final 0.8 seconds, then kill Reel 3
	yield(get_tree().create_timer(0.8), "timeout")
	reel3.stop_spinning()
	
	# Wait a tiny moment after the final stop, then reset the button
	yield(get_tree().create_timer(0.4), "timeout")
	
	# *** THIS IS THE KEY FIX - Call the function! ***
	check_winning_row()
	
	roll_button.disabled = false 
	
func _ready():
	# Make sure popup exists and is hidden
	if result_popup == null:
		print("ERROR: Popup not found at path: $ResultLayer/ResultPopup")
	else:
		print("Popup found: ", result_popup)
		result_popup.visible = false  # Hide it at start

func check_winning_row():
	# Use the same path as in onready!
	if result_popup == null:
		print("ERROR: result_popup is null!")
		return
	
	# Get the symbols from the middle row of each reel
	var symbol1 = reel1.get_middle_symbol_texture()
	var symbol2 = reel2.get_middle_symbol_texture()
	var symbol3 = reel3.get_middle_symbol_texture()
	
	print("Symbols: ", symbol1, " ", symbol2, " ", symbol3)  # Debug
	
	# Check if all three match
	if symbol1 == symbol2 and symbol2 == symbol3:
		result_popup.dialog_text = "JACKPOT! 🎉"
		print("JACKPOT!")  # Debug
	else:
		var random_index = randi() % loss_messages.size()
		result_popup.dialog_text = loss_messages[random_index]
		print("Loss message: ", loss_messages[random_index])  # Debug
	
	# Show the popup
	result_popup.popup_centered(Vector2(300, 150))
	print("Popup should be visible now!")
