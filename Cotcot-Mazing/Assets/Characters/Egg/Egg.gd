extends "res://Assets/Characters/Character.gd"

# class member variables go here, for example:
export(Vector3) var rotationAngles = Vector3(0, 50, 0)

var _nextElement

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func addNextElement(newElt):
	self._nextElement = newElt
	
func getNextElement():
	return self._nextElement

func getLastElement():
	if self._nextElement == null:
		return self
	else:
		return self._nextElement.getLastElement()

func isLastElement():
	return (self._nextElement == null)

func addLastElement(newElt):
	var currentLastElt = getLastElement()
	currentLastElt.addNextElement(newElt)

func moveTail(newCell):
#	print("called moveTail({0})".format([newCell.name]))
	var newGridPos = _grid._gridActorNameToGridPositions[newCell.name]
	updateCurrentCell(newGridPos)
	
	var oldCell = _grid._gridPositionCell[self.oldGridCellCoord]
	var realPos = _grid._gridPositionToReal[newGridPos]
	self.transform.origin = Vector3(realPos.y, 0, realPos.x)
	newCell.setNature(_grid.EGG)
	newCell.addToActorOnCell(newCell.name)
	
	if(isLastElement()):
		if oldCell != null:
			oldCell.setNature(_grid.EMPTY)
			oldCell.removeFromActorOnCell(oldCell.name)

	else:
		getNextElement().moveTail(oldCell)


func _process(delta):
	# Called every frame. Delta is time since last frame.
	rotate_x(deg2rad(rotationAngles.x * delta))
	rotate_y(deg2rad(rotationAngles.y * delta))
	rotate_z(deg2rad(rotationAngles.z * delta))
