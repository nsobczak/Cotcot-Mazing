extends Spatial

enum CELL_NATURE { OBSTACLE = -1, EMPTY, ACTOR, OBJECT}

# class member variables go here, for example:
export(CELL_NATURE) var nature = EMPTY

func _initializeMeshVisibility():
	$BasicCube.visible = false
	
	
func _ready():
	# Called when the node is added to the scene for the first time.
	_initializeMeshVisibility()
	pass

func getNature():
	# Called when the node is added to the scene for the first time.
	return nature


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
