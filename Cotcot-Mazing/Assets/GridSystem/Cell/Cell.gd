extends Spatial

enum CELL_NATURE { OBSTACLE = -1, EMPTY, ACTOR, OBJECT}

export(CELL_NATURE) var nature = EMPTY

var _actorNameOnCell = []

func _controlMeshVisibility(cubeVisibilty):
	$EmptyCell/BasicCube.visible = cubeVisibilty

func _initializeMeshVisibility():
	match nature:
		OBSTACLE:
			_controlMeshVisibility(true)
#			print("Cell is obstacle")
		EMPTY:
			_controlMeshVisibility(false)
#			print("Cell is empty")
		ACTOR:
			_controlMeshVisibility(false)
#			print("Cell is actor")
		OBJECT:
			_controlMeshVisibility(false)
#			print("Cell is object")

	
func _ready():
	# Called when the node is added to the scene for the first time.
	_initializeMeshVisibility()
	pass

func getNature():
	# Called when the node is added to the scene for the first time.
	return nature

func setNature(newNature):
	# Called when the node is added to the scene for the first time.
	self.nature = newNature
	_initializeMeshVisibility()

func getActorsOnCell():
	return self._actorNameOnCell
	
#func findIdxActorOnCell(actorName):
#	for i in range(0, len(self._actorNameOnCell)):
#		actor = self._actorNameOnCell[i]
#		if actor == actorName:
#			return i
#	return -1

func isActorOnCell(actorName):
	return (actorName in self._actorNameOnCell)

func addToActorOnCell(actorName):
	self._actorNameOnCell.append(actorName)

func removeToActorOnCell(actorName):
	self._actorNameOnCell.remove(actorName)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
