extends Camera


func _ready():
	look_at_from_position(get_parent().translation + Vector3(5, 5, 5), get_parent().translation, Vector3(0, 1, 0))
	
func _physics_process(delta):
	look_at_from_position(get_parent().translation + Vector3(5, 5, 5), get_parent().translation, Vector3(0, 1, 0))
