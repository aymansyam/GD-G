extends Camera

var current_camera_loc = get_parent().translation + Vector3(5, 5, 5)

func _ready():
	look_at_from_position(current_camera_loc, get_parent().translation, Vector3(0, 1, 0))
	
func _physics_process(delta):
	look_at_from_position(current_camera_loc, get_parent().translation, Vector3(0, 1, 0))
	
func _input(event):
   # Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		print("Mouse Click/Unclick at: ", event.position)
	elif event is InputEventMouseMotion:
		print("Mouse Motion at: ", event.position)
		current_camera_loc = 
		
		

   # Print the size of the viewport.
	print("Viewport Resolution is: ", get_viewport().size)
