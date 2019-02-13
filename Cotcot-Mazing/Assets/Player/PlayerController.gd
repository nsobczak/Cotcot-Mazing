extends KinematicBody

# class member variables go here, for example:
export var speed = 25
export var direction = Vector3()

func _ready():
	# Called when the node is added to the scene for the first time.
	#set_process_input(true)
	pass


func _input(deltaVal):
	direction = Vector3(0,0,0)
	if Input.is_action_pressed("ui_left"):
		direction.x -=1
	if Input.is_action_pressed("ui_right") :
		direction.x +=1
	if Input.is_action_pressed("ui_up"):
		direction.z -=1
	if Input.is_action_pressed("ui_down"):
		direction.z +=1




func _process(delta):
	# Called every frame. Delta is time since last frame.

	_input(delta)
	pass
