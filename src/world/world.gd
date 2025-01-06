ext"res://src/world/world.tscn"ends Node3D

@export var zoom_speed: float = 0.5
@export var rotation_speed: float = 0.01
@export var pan_speed: float = 0.1

var drag_active: bool = false
var last_mouse_position: Vector2 = Vector2.ZERO

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.is_action_pressed("mouse_drag):
		rotate_model(event.relative)

	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_camera(-zoom_speed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_camera(zoom_speed)

	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		drag_active = event.is_pressed()

func rotate_model(mouse_delta: Vector2):
	var rotation_y = -mouse_delta.x * rotation_speed
	var rotation_x = -mouse_delta.y * rotation_speed
	rotate_object_local(Vector3(0, 1, 0), rotation_y)
	rotate_object_local(Vector3(1, 0, 0), rotation_x)

func zoom_camera(amount: float):
	var camera = $Camera3D
	camera.translation += camera.basis.z * amount
