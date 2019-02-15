extends Spatial

enum CELL_NATURE { OBSTACLE = -1, EMPTY, ACTOR, OBJECT}

# class member variables go here, for example:
export(Vector2) var size = Vector2(20, 20)
export(String) var cellScenePath = "res://Assets/GridSystem/Cell/Cell.tscn"
export(Vector2) var cellSize = Vector2(24, 24)
export(float) var cellMargin = 3
export(Vector2) var playerStartCell = Vector2(0, 0)
export var obstaclesArray = [Vector2(0, 1), Vector2(0, 2), Vector2(0, 3), Vector2(5, 5), Vector2(8, 4)]

var _gridPositionToReal = {}
var _gridPositionCell = {}
var _gridActorNameToGridPositions = {}


#_________________________________________________________________________________________
func _generate():
	var cellScene = load(self.cellScenePath)
	
	for i in range(0, self.size.x):
		for j in range(0, self.size.y):
			var cellPosition = Vector2((i+1) * (self.cellSize.x + cellMargin), (j+1) * (self.cellSize.y + cellMargin))
#			print("cell ({0}, {1}) position is: ({2}, {3})" \
#			.format([i, j, cellPosition.x, cellPosition.y]))
			self._gridPositionToReal[Vector2(i, j)] = cellPosition
			
			var cellScene_instance = cellScene.instance()
			self._gridPositionCell[Vector2(i, j)] = cellScene_instance
			cellScene_instance.set_name("cellScene_({0}.0,{1}.0)".format([i, j]))
#			print("cellScene_({0}.0,{1}.0)".format([i, j]))
			cellScene_instance.transform.origin = Vector3(cellPosition.y, 0, cellPosition.x)
			#TODO: set nature depending on where walls should be
			if (Vector2(i, j) in self.obstaclesArray):
				cellScene_instance.setNature(OBSTACLE)
			else:
				cellScene_instance.setNature(EMPTY)
			add_child(cellScene_instance)
#			print(has_node("cellScene_({0},{1})".format([i, j]))) #prints True

func _initActorPositions():
	for childNode in self.get_children():
		if (childNode.name == "Player"):
#			print("init player position")
			updateActorGridPosition(childNode.name, self.playerStartCell)
			self._gridPositionCell[self.playerStartCell].addToActorOnCell(childNode.name)
		#TODO: else place pickups

func _ready():
	# Called when the node is added to the scene for the first time.	
	print("grid bottom left corner position: ", self.transform.origin)

	# add cells instances from prefabs
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
	
	if (actor != null):
		# update actor position in grid
		self._gridActorNameToGridPositions[actorName] = newGridPosition #Vector2()
		# update actual actor position
		var gridPosition = self._gridActorNameToGridPositions[actorName]
		var worldPosition = self._gridPositionToReal[gridPosition]
		actor.transform.origin = Vector3(worldPosition.y, 0, worldPosition.x)
		# update cell _actorNameOnCell
		if (oldCell != null):
			oldCell.removeToActorOnCell(actorName)
			self._gridPositionCell[newGridPosition].addToActorOnCell(actorName)

#_________________________________________________________________________________________
func moveActor(actorNameToMove, gridCoordinates):
	if canMoveToCell(gridCoordinates):
		updateActorGridPosition(actorNameToMove, gridCoordinates)
	else:
		print("can't move to that cell")

func moveUp(actorNameToMove):
	var currentCellPos = self._gridActorNameToGridPositions[actorNameToMove]
	var newCell = Vector2(currentCellPos.x, currentCellPos.y + 1)
	if canMoveToCell(newCell):
		updateActorGridPosition(actorNameToMove, newCell)
	else:
		print("can't move to cell above")
		
func moveRight(actorNameToMove):
	var currentCellPos = self._gridActorNameToGridPositions[actorNameToMove]
	var newCell = Vector2(currentCellPos.x + 1, currentCellPos.y)
	if canMoveToCell(newCell):
		updateActorGridPosition(actorNameToMove, newCell)
	else:
		print("can't move to right cell")
		
func moveDown(actorNameToMove):
	var currentCellPos = self._gridActorNameToGridPositions[actorNameToMove]
	var newCell = Vector2(currentCellPos.x, currentCellPos.y - 1)
	if canMoveToCell(newCell):
		updateActorGridPosition(actorNameToMove, newCell)
	else:
		print("can't move to cell underneath")

func moveLeft(actorNameToMove):
	var currentCellPos = self._gridActorNameToGridPositions[actorNameToMove]
	var newCell = Vector2(currentCellPos.x - 1, currentCellPos.y)
	if canMoveToCell(newCell):
		updateActorGridPosition(actorNameToMove, newCell)
	else:
		print("can't move to left cell")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	pass
