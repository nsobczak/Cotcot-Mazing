extends Spatial

enum CELL_NATURE { OBSTACLE = -1, EMPTY, ACTOR, OBJECT}

# class member variables go here, for example:
export(Vector2) var size = Vector2(20, 20)
export(String) var cellScenePath = "res://Assets/GridSystem/Cell/Cell.tscn"
export(Vector2) var cellSize = Vector2(24, 24)
export(float) var cellMargin = 4

var _gridPositionToReal = {}
var _gridActorNamePositions = {}


#_________________________________________________________________________________________
func _generate():
	var cellScene = load(self.cellScenePath)
	
	for i in range(0, self.size.x):
		for j in range(0, self.size.y):
			var cellPosition = Vector2((i+1) * self.cellSize.x, (j+1) * self.cellSize.y)
#			print("cell ({0}, {1}) position is: ({2}, {3})" \
#			.format([i, j, cellPosition.x, cellPosition.y]))
			self._gridPositionToReal[Vector2(i, j)] = cellPosition
			
			var cellScene_instance = cellScene.instance()
			cellScene_instance.set_name("cellScene_({0}.0,{1}.0)".format([i, j]))
#			print("cellScene_({0}.0,{1}.0)".format([i, j]))
			cellScene_instance.transform.origin = Vector3(cellPosition.x, 0, cellPosition.y)
			cellScene_instance.setNature(EMPTY)
			add_child(cellScene_instance)
#			print(has_node("cellScene_({0},{1})".format([i, j]))) #prints True

func _initActorPositions():
	for childNode in self.get_children():
 		self._gridActorNamePositions[childNode.name] = Vector2(0, 0)

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
	if actor != null:
		# update actor position in grid
		self._gridActorNamePositions[actorName] = newGridPosition #Vector2()
		# update actual actor position
		var gridPosition = self._gridActorNamePositions[actorName]
		var worldPosition = self._gridPositionToReal[gridPosition]
		actor.transform.origin = Vector3(worldPosition.y, 0, worldPosition.x)


#_________________________________________________________________________________________
func moveActor(actorNameToMove, gridCoordinates):
	if canMoveToCell(gridCoordinates):
		updateActorGridPosition(actorNameToMove, gridCoordinates)
	else:
		print("can't move to that cell")

func moveUp(actorNameToMove):
	var currentCell = self._gridActorNamePositions[actorNameToMove]
	var newCell = Vector2(currentCell.x, currentCell.y + 1)
	if canMoveToCell(newCell):
		updateActorGridPosition(actorNameToMove, newCell)
	else:
		print("can't move to cell above")
		
func moveRight(actorNameToMove):
	var currentCell = self._gridActorNamePositions[actorNameToMove]
	var newCell = Vector2(currentCell.x + 1, currentCell.y)
	if canMoveToCell(newCell):
		updateActorGridPosition(actorNameToMove, newCell)
	else:
		print("can't move to right cell")
		
func moveDown(actorNameToMove):
	var currentCell = self._gridActorNamePositions[actorNameToMove]
	var newCell = Vector2(currentCell.x, currentCell.y - 1)
	if canMoveToCell(newCell):
		updateActorGridPosition(actorNameToMove, newCell)
	else:
		print("can't move to cell underneath")

func moveLeft(actorNameToMove):
	var currentCell = self._gridActorNamePositions[actorNameToMove]
	var newCell = Vector2(currentCell.x - 1, currentCell.y)
	if canMoveToCell(newCell):
		updateActorGridPosition(actorNameToMove, newCell)
	else:
		print("can't move to left cell")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	pass
