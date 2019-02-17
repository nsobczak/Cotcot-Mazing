extends "res://Assets/Characters/Character.gd"

# class member variables go here, for example:
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
	if self._nextElement != null:
		return self
	else:
		return self._nextElement

func isLastElement():
	return (self._nextElement == null)

func moveTail(newCell):
	var newGridPos = self._grid._gridActorNameToGridPositions[newCell.name]
	self.oldGridCellCoord = self.currentGridCellCoord
	self.currentGridCellCoord = newGridPos
	self.transform.origin = self._grid._gridPositionToReal[newGridPos]
	
	if(isLastElement()):
		#TODO:here change old cell (with no egg) to EMPTY
		pass
	else:
		getNextElement().moveTail(self.oldGridCellCoord)
		pass
	

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
