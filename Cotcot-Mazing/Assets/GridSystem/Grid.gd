extends Spatial

enum CELL_NATURE { OBSTACLE = -1, EMPTY, ACTOR, OBJECT}

# class member variables go here, for example:
export(Vector2) var size = Vector2(20, 20)

func _ready():
	# Called when the node is added to the scene for the first time.
	
	# TODO: scale ground 
	# TODO: add cells instances from prefabs
	pass

# TODO: create cell object

func getCellNature(coordinates):
	# Called when the node is added to the scene for the first time.
	
	# TODO: get cell at those coordinates and use its getNature function
	pass


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	pass
