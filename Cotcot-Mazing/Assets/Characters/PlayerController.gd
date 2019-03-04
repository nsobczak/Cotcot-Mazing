extends "Character.gd"

export(String) var wavMovementPath = "res://Assets/Audio/S_Movement.wav"
export(float) var autoInputDelay = 0.4

var _tailHead
var _pickupNumber = 0
var _checkInputCheckRate = 0.25
var _timer = 0

var _lastInput = ""

#_________________________________________________________________________________________
func _ready():
	# Called when the node is added to the scene for the first time.
	var wavMovement = load(self.wavMovementPath)
	$ASP_movement.stream = wavMovement

func _moveLeft():
	_lastInput = "ui_left"
	self.rotation_degrees = Vector3(0, 90, 0)
	self._grid.moveLeft(self.name, _grid.ACTOR)

func _moveRight():
	_lastInput = "ui_right"
	self.rotation_degrees = Vector3(0, -90, 0)
	self._grid.moveRight(self.name, _grid.ACTOR)

func _moveUp():
	_lastInput = "ui_up"
	self.rotation_degrees = Vector3(0, 0, 0)
	self._grid.moveUp(self.name, _grid.ACTOR)

func _moveDown():
	_lastInput = "ui_down"
	self.rotation_degrees = Vector3(0, 180, 0)
	self._grid.moveDown(self.name, _grid.ACTOR)

func _moved():
	$ASP_movement.play()
	_timer = 0

func _checkInput(autoMove):
	if not(autoMove):
		if Input.is_action_pressed("ui_left"):
			_moveLeft()
			_moved()
			
		elif Input.is_action_pressed("ui_right"):
			_moveRight()
			_moved()
			
		elif Input.is_action_pressed("ui_up"):
			_moveUp()
			_moved()
			
		elif Input.is_action_pressed("ui_down"):
			_moveDown()
			_moved()
	
	else:
		autoMove = false
		
		if _lastInput == "ui_left":
			_moveLeft()
			_moved()
			
		elif _lastInput == "ui_right":
			_moveRight()
			_moved()
			
		elif _lastInput == "ui_up":
			_moveUp()
			_moved()
			
		elif _lastInput == "ui_down":
			_moveDown()
			_moved()


func _process(delta):
	# Called every frame. Delta is time since last frame.
	_timer += delta
	
	if _timer >= autoInputDelay and _lastInput != "":
		_checkInput(true)
		
	elif _timer >= _checkInputCheckRate:
		_checkInput(false)

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