extends KinematicBody

# How fast the player moves in meters per second.
export var speed = 14
# The downward acceleration when in the air, in meters per second squared.
export var fall_acceleration = 75
export var jump_impulse = 30

var velocity = Vector3.ZERO 

var camNode = null

func _ready():
	camNode = $ThirdPersonCamera

func _physics_process(delta):
	var direction = Vector3.ZERO
	var camDirection = camNode.translation
	var camDirection2d = Vector2(-1 * camDirection.x, -1 * camDirection.z)
	
	if is_forward_pressed() and is_right_pressed():
		direction = rotate2DRelativeTo(camDirection2d, 45)
	elif is_forward_pressed() and is_left_pressed():
		direction = rotate2DRelativeTo(camDirection2d, 315)
	elif is_back_pressed() and is_left_pressed():
		direction = rotate2DRelativeTo(camDirection2d, 225)
	elif is_back_pressed() and is_right_pressed():
		direction = rotate2DRelativeTo(camDirection2d, 135)
	elif is_right_pressed():
		direction = rotate2DRelativeTo(camDirection2d, 90)
	elif is_left_pressed():
		direction = rotate2DRelativeTo(camDirection2d, 270)
	elif is_forward_pressed():
		direction = rotate2DRelativeTo(camDirection2d, 0)
	elif is_back_pressed():
		direction = rotate2DRelativeTo(camDirection2d, 180)
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()
	if is_nothing_pressed():
		velocity.x = lerp(velocity.x, 0, 0.05)
		velocity.z = lerp(velocity.z, 0, 0.05)
	else:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	
	if is_on_floor() and Input.is_action_just_pressed("ui_select"):
		velocity.y = jump_impulse
	
	velocity.y -= fall_acceleration * delta

	velocity = move_and_slide(velocity, Vector3.UP)

func is_nothing_pressed():
	return (not Input.is_action_pressed("ui_up") and not Input.is_action_pressed("ui_left") 
	and not Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_down"))

func is_forward_pressed():
	return Input.is_action_pressed("ui_up")
	
func is_left_pressed():
	return Input.is_action_pressed("ui_left")
	
func is_right_pressed():
	return Input.is_action_pressed("ui_right")
	
func is_back_pressed():
	return Input.is_action_pressed("ui_down")
	
func rotate2DRelativeTo(vector, number):
	var new_vec = Vector3.ZERO
	new_vec.x = vector.rotated(deg2rad(number)).x
	new_vec.z = vector.rotated(deg2rad(number)).y
	new_vec.y = 0
	
	var un_vec = new_vec.normalized()
	
	$MeshInstance.rotate(Vector3(un_vec.z, un_vec.y, -un_vec.x), deg2rad(8))
	return new_vec