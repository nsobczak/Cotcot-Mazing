extends "Character.gd"

var _tailHead
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
		self._grid.moveLeft(self.name)
		self.rotation_degrees = Vector3(0, 90, 0)
		_timer = 0
	if Input.is_action_just_pressed("ui_right") :
		self._grid.moveRight(self.name)
		self.rotation_degrees = Vector3(0, -90, 0)
		_timer = 0
	if Input.is_action_just_pressed("ui_up"):
		self.rotation_degrees = Vector3(0, 0, 0)
		self._grid.moveUp(self.name)
		_timer = 0
	if Input.is_action_just_pressed("ui_down"):
		self.rotation_degrees = Vector3(0, 180, 0)
		self._grid.moveDown(self.name)
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

func getTailHead():
	return self._tailHead

func setTailHead(newElement):
	self._tailHead = newElement