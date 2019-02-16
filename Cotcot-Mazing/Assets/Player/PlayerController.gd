extends KinematicBody

onready var grid = get_parent()

var _pickupNumber = 0
var _checkInputCheckRate = 0.25
var _timer = 0


#_________________________________________________________________________________________
func _ready():
	# Called when the node is added to the scene for the first time.
	#set_process_input(true)
	pass


func _checkInput():
	if Input.is_action_just_pressed("ui_left"):
		self.grid.moveLeft(self.name)
		_timer = 0
	if Input.is_action_just_pressed("ui_right") :
		self.grid.moveRight(self.name)
		_timer = 0
	if Input.is_action_just_pressed("ui_up"):
		self.grid.moveUp(self.name)
		_timer = 0
	if Input.is_action_just_pressed("ui_down"):
		self.grid.moveDown(self.name)
		_timer = 0


func _process(delta):
	# Called every frame. Delta is time since last frame.
	_timer += delta
	if _timer >= _checkInputCheckRate:
		_checkInput()
	pass
	

#_________________________________________________________________________________________
func getPickupNumber():
	return self._pickupNumber

func setPickupNumber(newValue):
	self._pickupNumber = newValue

func updatePickupNumber(amount):
	self._pickupNumber += amount
	return self._pickupNumber
