extends Spatial

enum CELL_NATURE { VOID = -2, OBSTACLE, EMPTY, ACTOR, PICKUP, EGG = 10}

# class member variables
export(bool) var DEBUG = false

export(String) var screenGameOverPath = "res://Assets/UI/Screens/ScreenGameOver.tscn"
export(String) var screenLevelResultPath = "res://Assets/UI/Screens/ScreenLevelResult.tscn"

export(String) var gridName = "Level"
export(String) var cellScenePath = "res://Assets/GridSystem/Cell/Cell.tscn"
export(String) var tailElementPath = "res://Assets/Characters/Egg/Egg.tscn"

export(String) var wavPickupFPath = "res://Assets/Audio/S_PickupF.wav"
export(String) var wavPickupGPath = "res://Assets/Audio/S_PickupG.wav"
export(String) var wavPickupAPath = "res://Assets/Audio/S_PickupA.wav"
export(String) var wavPickupBPath = "res://Assets/Audio/S_PickupB.wav"

export(Vector2) var gSize = Vector2(20, 20)
export(Vector2) var cellSize = Vector2(24, 24)
export(float) var cellMargin = 3
export(Vector2) var playerStartCell = Vector2(0, 0)

var _pickupTotal = 0

var _jsonGrid = {}
var _realGridSize
var _gridPositionToReal = {}
var _gridPositionCell = {}
var _gridActorNameToGridPositions = {}
var _eggScene


#_________________________________________________________________________________________
func _readJsonLevel():
	var file = File.new()
	var pathToFile = Global.getLevelsPath() + "/" + Global.getLevelFileName()
	file.open(pathToFile, file.READ)
	var tmp_text = file.get_as_text()
	file.close()

	self._jsonGrid = parse_json(tmp_text)
	if (self._jsonGrid != null):
		self.gridName = self._jsonGrid["Level"]["name"]
		print("loading "+ self.gridName + " from " + pathToFile)
		
		self.gSize = Vector2(self._jsonGrid["Level"]["grid"]["size"][0],\
			self._jsonGrid["Level"]["grid"]["size"][1])
		self.cellSize = Vector2(self._jsonGrid["Level"]["grid"]["cellSize"][0],\
			self._jsonGrid["Level"]["grid"]["cellSize"][1])
		self.cellMargin = self._jsonGrid["Level"]["grid"]["cellMargin"]
		
		Global.groundSceneName = self._jsonGrid["Level"]["grid"]["groundSceneName"]
		Global.wallSceneName = self._jsonGrid["Level"]["grid"]["wallSceneName"]
		Global.pickupSceneName = self._jsonGrid["Level"]["grid"]["pickupSceneName"]
	
	else:
		print("error: data is null")


#_________________________________________________________________________________________
func _computeRealGridSize():
	self._realGridSize = Vector2( \
		self.gSize.x * self.cellSize.x + (self.gSize.x - 1) * self.cellMargin, \
		self.gSize.y * self.cellSize.y + (self.gSize.y - 1) * self.cellMargin)

func getRealGridSize():
	if self._realGridSize == null:
		_computeRealGridSize()
	return self._realGridSize
	
func _generate():
	var cellScene = load(self.cellScenePath)
	var jsonCells = self._jsonGrid["Level"]["grid"]["cells"]
	for i in range(0, self.gSize.x):
		for j in range(0, self.gSize.y):
			var cellPosition = Vector2((i+1) * (self.cellSize.x + cellMargin), (j+1) * (self.cellSize.y + cellMargin))
			if DEBUG:
				print("cell ({0}, {1}) position is: ({2}, {3})" \
					.format([i, j, cellPosition.x, cellPosition.y]))
			self._gridPositionToReal[Vector2(i, j)] = cellPosition
			
			# instantiate cell
			var cellScene_instance = cellScene.instance()
			self._gridPositionCell[Vector2(i, j)] = cellScene_instance
			cellScene_instance.set_name("cellScene_({0}.0,{1}.0)".format([i, j]))
			self._gridActorNameToGridPositions[cellScene_instance.name] = Vector2(i, j)
			cellScene_instance.transform.origin = Vector3(cellPosition.y, 0, cellPosition.x)
			
			# set nature depending on where walls should be
			var nature = int(jsonCells[len(jsonCells) -1 -j][i])
			match nature:
				-2:
					cellScene_instance.setNature(VOID)
				-1:
					cellScene_instance.setNature(OBSTACLE)
				1:
					cellScene_instance.setNature(ACTOR)
					self.playerStartCell = Vector2(i, j)
				2:
					cellScene_instance.setNature(PICKUP)
					_pickupTotal += 1
				_:#default
					cellScene_instance.setNature(EMPTY)
			add_child(cellScene_instance)
			if DEBUG:
				print(has_node("cellScene_({0},{1})".format([i, j]))) #prints True


func _initActorPositions():
	for childNode in self.get_children():
		if (childNode.name == "Player"):
			if DEBUG:
				print("init player position")
			updateActorGridPosition(childNode.name, ACTOR, self.playerStartCell)


func _initAudio():
	var wavPickup
	
	wavPickup = load(self.wavPickupFPath)
	$ASP_pickupF.stream = wavPickup
	wavPickup = load(self.wavPickupGPath)
	$ASP_pickupG.stream = wavPickup
	wavPickup = load(self.wavPickupAPath)
	$ASP_pickupA.stream = wavPickup
	wavPickup = load(self.wavPickupBPath)
	$ASP_pickupB.stream = wavPickup
	
	if $ASP_pickupF.stream == null or $ASP_pickupG.stream == null or \
		$ASP_pickupA.stream == null or $ASP_pickupB.stream == null:
		print("a pickupStream is null")


func _ready():
	_readJsonLevel()

	# add cells instances
	_generate()
	_initActorPositions()
	
	_initAudio()
	
	self._eggScene = load(self.tailElementPath)
	if self._eggScene == null:
		print ("error: eggScene couldn't be loaded")


#_________________________________________________________________________________________
func gameOver():
	print("game over")
	get_tree().change_scene(screenGameOverPath)

func levelCompleted():
	print("level completed: {0}".format([Global.getLevelFileName()]))
	get_tree().change_scene(screenLevelResultPath)


func findActorByName(actorName):
	for childNode in self.get_children():
		if (childNode.name == actorName):
			return childNode
	print("{0} wasn't found".format([actorName]))
	return null


func findCellWithActorName(actorName):
	for cellCoord in self._gridPositionCell:
		if self._gridPositionCell[cellCoord].isActorOnCell(actorName):
			return self._gridPositionCell[cellCoord]
	return null


func getCellNature(gridCoordinates):
	# get cell at those coordinates and use its getNature function
	var cellName = "cellScene_({0},{1})".format([gridCoordinates.x, gridCoordinates.y])
	var cell = findActorByName(cellName)
	
	if cell != null:
		return cell.getNature()
	else:
		return null


func canMoveToCell(gridCoordinates):
	if (gridCoordinates in self._gridPositionToReal):
		return (getCellNature(gridCoordinates) >= 0)
	else:
		return false


func playPickupSound():
	var i = randi()%7
	var sound
	match i:
		3, 4:
			sound = $ASP_pickupG
		5:
			sound = $ASP_pickupA
		6:
			sound = $ASP_pickupB
		_:
			sound = $ASP_pickupF
	
	var pitchVariation = randi()%3
	match pitchVariation:
		0:
			sound.pitch_scale = 0.8
		1:
			sound.pitch_scale = 1.2
		_:
			sound.pitch_scale = 1.0

	if DEBUG:
		print("pickup i value = {0} | pitch_scale = {1}".format([i, sound.pitch_scale]))
	sound.play()


func growTail(oldCell):
	# instantiate egg
	var eggScene_instance = self._eggScene.instance()
	add_child(eggScene_instance)
	var eggGridPosition
	var eggRealPosition
	
	if $Player.getTailHead() == null:
		# cell at gridCoord is empty => spawn here
		eggGridPosition = self._gridActorNameToGridPositions[oldCell.name]
		eggRealPosition = self._gridPositionToReal[eggGridPosition]
		$Player.setTailHead(eggScene_instance)
		oldCell.setNature(EGG)

	else:
		#(cell at gridCoord has a tail element) => spawn at end of tail
		var lastTailElement = $Player.getTailHead().getLastElement()
		lastTailElement.addLastElement(eggScene_instance)
		var lastEltOldCellCoord = lastTailElement.oldGridCellCoord

		eggGridPosition = lastEltOldCellCoord
		eggRealPosition = self._gridPositionToReal[eggGridPosition]
		
		var lastEltOldCell = self._gridPositionCell[lastEltOldCellCoord]
		lastEltOldCell.setNature(EGG)

	self._gridActorNameToGridPositions[eggScene_instance.name] = eggGridPosition
	eggScene_instance.updateCurrentCell(eggGridPosition)
	
	eggScene_instance.transform.origin = Vector3(eggRealPosition.y, 0, eggRealPosition.x)


func updateActorGridPosition(actorName, currentCellNature, newGridPosition):
	var actor = findActorByName(actorName)
	if (actor == null):
		return

	var oldCell = findCellWithActorName(actorName)
	if (oldCell != null):
		oldCell.removeFromActorOnCell(actorName)
	
	var newCell = self._gridPositionCell[newGridPosition]
	if (newCell == null):
		return
	newCell.addToActorOnCell(actorName)

	# update actor position in grid
	self._gridActorNameToGridPositions[actorName] = newGridPosition #Vector2()
	
	# update actual actor position
	var gridPosition = self._gridActorNameToGridPositions[actorName]
	var worldPosition = self._gridPositionToReal[gridPosition]
	actor.transform.origin = Vector3(worldPosition.y, 0, worldPosition.x)
	actor.updateCurrentCell(newGridPosition)
	
	if (currentCellNature == ACTOR) and  ($Player.getTailHead() != null):
		$Player.getTailHead().moveTail(oldCell)
		if DEBUG:
			print("move tail, last elt = {0}".format([$Player.getTailHead().getLastElement().name]))
	
	# if pickup is in newCell => delete it and add it to player
	if (newCell.getNature() == PICKUP):
		var pickup = newCell.findActorByName(newCell.name + "_pickup")
		if (pickup != null):
			playPickupSound()
			
			$Player.updatePickupNumber(pickup.getValue())
			if $Player.getPickupNumber() >= _pickupTotal:
				levelCompleted()
			
			newCell.delete(pickup)
			newCell.setNature(EMPTY)

			growTail(oldCell)
			
		else:
			print("error: pickup is null")
	
	elif (newCell.getNature() == EGG):
		gameOver()
	
	# update cell data
	newCell.setNature(currentCellNature)
	if (oldCell != null):
		oldCell.setNature(EMPTY)


#_________________________________________________________________________________________
func moveActor(actorNameToMove, currentCellNature, gridCoordinates):
	if canMoveToCell(gridCoordinates):
		updateActorGridPosition(actorNameToMove, currentCellNature, gridCoordinates)
	elif DEBUG:
		print("can't move to that cell")


func moveUp(actorNameToMove, currentCellNature):
	var currentCellPos = self._gridActorNameToGridPositions[actorNameToMove]
	var newCell = Vector2(currentCellPos.x, currentCellPos.y + 1)
	moveActor(actorNameToMove, currentCellNature, newCell)
#	else:
#		print("can't move to cell above")


func moveRight(actorNameToMove, currentCellNature):
	var currentCellPos = self._gridActorNameToGridPositions[actorNameToMove]
	var newCell = Vector2(currentCellPos.x + 1, currentCellPos.y)
	moveActor(actorNameToMove, currentCellNature, newCell)
#	else:
#		print("can't move to right cell")


func moveDown(actorNameToMove, currentCellNature):
	var currentCellPos = self._gridActorNameToGridPositions[actorNameToMove]
	var newCell = Vector2(currentCellPos.x, currentCellPos.y - 1)
	moveActor(actorNameToMove, currentCellNature, newCell)
#	else:
#		print("can't move to cell underneath")


func moveLeft(actorNameToMove, currentCellNature):
	var currentCellPos = self._gridActorNameToGridPositions[actorNameToMove]
	var newCell = Vector2(currentCellPos.x - 1, currentCellPos.y)
	moveActor(actorNameToMove, currentCellNature, newCell)
#	else:
#		print("can't move to left cell")


#_________________________________________________________________________________________
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	pass
