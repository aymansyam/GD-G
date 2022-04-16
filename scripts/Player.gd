extends KinematicBody

# How fast the player moves in meters per second.
export var speed = 14
# The downward acceleration when in the air, in meters per second squared.
export var fall_acceleration = 75
export var jump_impulse = 30

var velocity = Vector3.ZERO 

var camNode = null

func _ready():
	camNode = get_node("ThirdPersonCamera")

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

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	if is_on_floor() and Input.is_action_just_pressed("ui_select"):
		velocity.y = jump_impulse
	
	velocity.y -= fall_acceleration * delta
	velocity = move_and_slide(velocity, Vector3.UP)

func is_forward_pressed():
	return Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_W)
	
func is_left_pressed():
	return Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A)
	
func is_right_pressed():
	return Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D)
	
func is_back_pressed():
	return Input.is_action_pressed("ui_down") or Input.is_key_pressed(KEY_S)
	
func rotate2DRelativeTo(vector, number):
	var new_vec = Vector3.ZERO
	new_vec.x = vector.rotated(deg2rad(number)).x
	new_vec.z = vector.rotated(deg2rad(number)).y
	new_vec.y = vector.y
	return new_vec