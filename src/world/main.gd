extends Node3D

var pressed := false
var zoom_speed := 1.5
var pan_speed := 0.1
var rotation_speed := 0.005

var original_rotation: Vector3
var original_position: Vector3
var original_camera_position: Vector3

var mesh_instance: MeshInstance3D
var camera: Camera3D

func _ready() -> void:
	# Find the mesh and camera nodes
	mesh_instance = $MeshInstance3D
	camera = $Camera3D

	if mesh_instance == null or camera == null:
		print("Error: Required nodes not found!")
		print_tree_pretty()  # Debug the scene tree
		return

	# Save the original states
	original_rotation = mesh_instance.rotation
	original_position = mesh_instance.transform.origin
	original_camera_position = camera.transform.origin

func _input(event: InputEvent) -> void:
	if pressed and event is InputEventMouseMotion:
		# Rotate the model using the mouse motion
		var rotation_delta = Vector3(-event.relative.y * rotation_speed, -event.relative.x * rotation_speed, 0)
		mesh_instance.transform.basis = mesh_instance.transform.basis.rotated(Vector3(0, 1, 0), rotation_delta.y)
		mesh_instance.transform.basis = mesh_instance.transform.basis.rotated(Vector3(1, 0, 0), rotation_delta.x)

	elif event is InputEventMouseButton:
		# Zoom in and out using the mouse wheel
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_camera(-zoom_speed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_camera(zoom_speed)

	elif event is InputEventMouseMotion and Input.is_action_pressed("pan"):
		# Pan the camera
		var camera_position = camera.transform.origin
		camera_position.x -= event.relative.x * pan_speed
		camera_position.y += event.relative.y * pan_speed
		camera.transform.origin = camera_position

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		pressed = true
	elif Input.is_action_just_released("click"):
		pressed = false

	if Input.is_action_just_pressed("reset_view"):
		reset_view()

func zoom_camera(amount: float) -> void:
	# Zoom the camera along its local Z-axis
	if camera != null:
		var camera_position = camera.transform.origin
		camera_position += camera.basis.z * amount
		camera.transform.origin = camera_position

func reset_view() -> void:
	if mesh_instance != null and camera != null:
		# Reset model rotation and position
		mesh_instance.rotation = original_rotation
		var transform = mesh_instance.transform
		transform.origin = original_position
		mesh_instance.transform = transform

		# Reset camera position
		var camera_transform = camera.transform
		camera_transform.origin = original_camera_position
		camera.transform = camera_transform


func _on_file_dialog_file_selected(path: String) -> void:
	# Load the 3D model (e.g., .obj, .fbx, or .glb)
	var model = load(path)  # Load the model at the specified path

	if model:
		# If the loaded file is a Mesh, we need to create a MeshInstance3D
		if model is Mesh:
			var mesh_instance = MeshInstance3D.new()
			mesh_instance.mesh = model  # Set the loaded model as the mesh
			# Optionally set the position of the model
			mesh_instance.transform.origin = Vector3(0, 0, 0)
			# Add the mesh instance to the current scene
			$MeshInstance3D.add_child(mesh_instance)  # Or add it to a specific node

		elif model is PackedScene:
			# If the model is a scene (like .glb or .fbx), instance the scene
			var instance = model.instantiate()  # Use 'instantiate' instead of 'instance' in Godot 4.x
			# Optionally set the position of the instance
			instance.transform.origin = Vector3(0, 0, 0)
			# Add the instance to the current scene
			get_parent().add_child(instance)  # Add it to the parent node

		print("Model loaded successfully!")
	else:
		print("Failed to load the model.")

	


func _on_button_pressed() -> void:
	$FileDialog.popup()
