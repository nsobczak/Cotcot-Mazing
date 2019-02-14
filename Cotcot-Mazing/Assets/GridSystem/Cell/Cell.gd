extends Spatial

enum CELL_NATURE { OBSTACLE = -1, EMPTY, ACTOR, OBJECT}

# class member variables go here, for example:
export(CELL_NATURE) var nature = EMPTY

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


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
