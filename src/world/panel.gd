extends Panel  # This should be the parent node (Panel) in the scene

# Declare the Button and FileDialog variables
onready var import_button := $Button
onready var file_dialog := $FileDialog

# _ready() function that runs when the scene is loaded
func _ready():
	# Connect the "pressed" signal of the button to the _on_ImportButton_pressed function
	import_button.connect("pressed", self, "_on_ImportButton_pressed")
	
	# Connect the "file_selected" signal of the FileDialog to the _on_FileSelected function
	file_dialog.connect("file_selected", self, "_on_FileSelected")

# This function opens the FileDialog when the button is pressed
func _on_ImportButton_pressed():
	file_dialog.popup_centered()

# This function handles the file selection from the FileDialog
func _on_FileSelected(path: String):
	# Try to load the 3D model from the selected path
	var model = load(path)
	
	# Check if the model was loaded correctly
	if model:
		# Create an instance of the loaded model
		var instance = model.instance()
		
		# Optionally set position, scale, or other properties
		instance.translation = Vector3(0, 0, 0)  # Position the model at the origin
		
		# Add the model instance to the current scene
		get_parent().add_child(instance)
		
		print("Model imported successfully")
	else:
		print("Failed to load the model")
