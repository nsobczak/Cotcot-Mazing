extends Spatial

enum CELL_NATURE { VOID = -2, OBSTACLE, EMPTY, ACTOR, PICKUP}

# class member variables
export(String) var jsonLevelsPath = "res://Assets/Levels/JsonLevels"
export(String) var jsonLevelFileName = "Level001.json"
export(String) var gridName = "Level"
export(Vector2) var gSize = Vector2(20, 20)
export(String) var cellScenePath = "res://Assets/GridSystem/Cell/Cell.tscn"
export(Vector2) var cellSize = Vector2(24, 24)
export(float) var cellMargin = 3
export(Vector2) var playerStartCell = Vector2(0, 0)
#export var obstaclesArray = [Vector2(0, 1), Vector2(0, 2), Vector2(0, 3), Vector2(5, 5), Vector2(8, 4)]
#export var pickupsArray = [Vector2(1, 0), Vector2(2, 0), Vector2(3, 0), Vector2(5, 4), Vector2(7, 4)]

var _jsonGrid = {}
var _realGridSize
var _gridPositionToReal = {}
var _gridPositionCell = {}
var _gridActorNameToGridPositions = {}


#_________________________________________________________________________________________
func _readJsonLevel():
	var file = File.new()
	var pathToFile = jsonLevelsPath + "/" + jsonLevelFileName
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
#			print("cell ({0}, {1}) position is: ({2}, {3})" \
#			.format([i, j, cellPosition.x, cellPosition.y]))
			self._gridPositionToReal[Vector2(i, j)] = cellPosition
			
			# instantiate cell
			var cellScene_instance = cellScene.instance()
			self._gridPositionCell[Vector2(i, j)] = cellScene_instance
			cellScene_instance.set_name("cellScene_({0}.0,{1}.0)".format([i, j]))
#			print("cellScene_({0}.0,{1}.0)".format([i, j]))
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
				_:#default
					cellScene_instance.setNature(EMPTY)
			add_child(cellScene_instance)
#			print(has_node("cellScene_({0},{1})".format([i, j]))) #prints True


func _initActorPositions():
	for childNode in self.get_children():
		if (childNode.name == "Player"):
#			print("init player position")
			updateActorGridPosition(childNode.name, self.playerStartCell)
			self._gridPositionCell[self.playerStartCell].addToActorOnCell(childNode.name)


func _ready():
	_readJsonLevel()

	var gridSize = getRealGridSize()
	print("real grid size = ", gridSize)
	
	# add cells instances
	_generate()
	_initActorPositions()


#_________________________________________________________________________________________
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


func updateActorGridPosition(actorName, newGridPosition):
	var actor = findActorByName(actorName)
	var oldCell = findCellWithActorName(actorName)
	var newCell = self._gridPositionCell[newGridPosition]
	
	if (actor != null):
		# update actor position in grid
		self._gridActorNameToGridPositions[actorName] = newGridPosition #Vector2()
		
		# update actual actor position
		var gridPosition = self._gridActorNameToGridPositions[actorName]
		var worldPosition = self._gridPositionToReal[gridPosition]
		actor.transform.origin = Vector3(worldPosition.y, 0, worldPosition.x)
		
		if (newCell != null):
			# update cell _actorNameOnCell
			if (oldCell != null):
				oldCell.removeFromActorOnCell(actorName)
				newCell.addToActorOnCell(actorName)
	
			# if pickup is in newCell => delete it and add it to player
			if (newCell.getNature() == PICKUP):
				var pickup = newCell.findActorByName(newCell.name + "_pickup") #TODO: here
				if (pickup != null):
					$Player.updatePickupNumber(pickup.getValue())
					newCell.delete(pickup)
					newCell.setNature(EMPTY)
				else:
					print("error: pickup is null")
				pass


#_________________________________________________________________________________________
func moveActor(actorNameToMove, gridCoordinates):
	if canMoveToCell(gridCoordinates):
		updateActorGridPosition(actorNameToMove, gridCoordinates)
#	else:
#		print("can't move to that cell")


func moveUp(actorNameToMove):
	var currentCellPos = self._gridActorNameToGridPositions[actorNameToMove]
	var newCell = Vector2(currentCellPos.x, currentCellPos.y + 1)
	moveActor(actorNameToMove, newCell)
#	else:
#		print("can't move to cell above")


func moveRight(actorNameToMove):
	var currentCellPos = self._gridActorNameToGridPositions[actorNameToMove]
	var newCell = Vector2(currentCellPos.x + 1, currentCellPos.y)
	moveActor(actorNameToMove, newCell)
#	else:
#		print("can't move to right cell")


func moveDown(actorNameToMove):
	var currentCellPos = self._gridActorNameToGridPositions[actorNameToMove]
	var newCell = Vector2(currentCellPos.x, currentCellPos.y - 1)
	moveActor(actorNameToMove, newCell)
#	else:
#		print("can't move to cell underneath")


func moveLeft(actorNameToMove):
	var currentCellPos = self._gridActorNameToGridPositions[actorNameToMove]
	var newCell = Vector2(currentCellPos.x - 1, currentCellPos.y)
	moveActor(actorNameToMove, newCell)
#	else:
#		print("can't move to left cell")


#_________________________________________________________________________________________
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	pass
