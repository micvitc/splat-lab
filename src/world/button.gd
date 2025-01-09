extends Panel

# Declare variables for the Button and FileDialog nodes
onready var import_button = $Button
onready var file_dialog = $FileDialog

# This function is called when the scene is ready
func _ready():
	# Connect the button's pressed signal to the import function
	import_button.connect("pressed", self, "_on_ImportButton_pressed")
	
	# Connect the file dialog's file selected signal
	file_dialog.connect("file_selected", self, "_on_FileSelected")

# Function to open the file dialog when the button is pressed
func _on_ImportButton_pressed():
	file_dialog.popup_centered()

# Function that handles the file selection
func _on_FileSelected(path: String):
	# Try loading the model from the selected path
	var model = load(path)
	
	# Check if the model was loaded correctly
	if model:
		# Create an instance of the model
		var instance = model.instance()
		
		# Optionally set position, scale, or other properties
		instance.translation = Vector3(0, 0, 0)  # Position the model at the origin
		
		# Add the model to the scene
		get_parent().add_child(instance)
		
		print("Model imported successfully")
	else:
		print("Failed to load the model")
