extends KinematicBody

onready var grid = get_parent()


func _ready():
	# Called when the node is added to the scene for the first time.
	#set_process_input(true)
	pass


func _input(deltaVal):
	if Input.is_action_just_pressed("ui_left"):
		self.grid.moveLeft(self.name)
	if Input.is_action_just_pressed("ui_right") :
		self.grid.moveRight(self.name)
	if Input.is_action_just_pressed("ui_up"):
		self.grid.moveUp(self.name)
	if Input.is_action_just_pressed("ui_down"):
		self.grid.moveDown(self.name)


func _process(delta):
	# Called every frame. Delta is time since last frame.
	_input(delta)
	pass
