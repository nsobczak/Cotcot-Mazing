extends Spatial

enum CELL_NATURE { OBSTACLE = -1, EMPTY, ACTOR, OBJECT}

# class member variables go here, for example:
export(Vector2) var size = Vector2(20, 20)
export(String) var cellScenePath = "res://Assets/GridSystem/Cell/Cell.tscn"
export(Vector2) var cellSize = Vector2(24, 24)
export(float) var cellMargin = 4

var _gridDic = {}


func _generate():
	var cellScene = load(self.cellScenePath)
	
	for i in range(0, self.size.x):
		for j in range(0, self.size.y):
			var cellPosition = Vector2((i+1) * self.cellSize.x, (j+1) * self.cellSize.y)
#			print("cell ({0}, {1}) position is: ({2}, {3})" \
#			.format([i, j, cellPosition.x, cellPosition.y]))
			self._gridDic[Vector2(i, j)] = cellPosition
			
			var cellScene_instance = cellScene.instance()
			cellScene_instance.set_name("cellScene_({0},{1})".format([i, j]))
			cellScene_instance.transform.origin = Vector3(cellPosition.x, 0, cellPosition.y)
			cellScene_instance.setNature(EMPTY)
			add_child(cellScene_instance)
#			print(has_node("cellScene_({0},{1})".format([i, j]))) #prints True
			

func _ready():
	# Called when the node is added to the scene for the first time.	
	print("grid bottom left corner position: ", self.transform.origin)

	# add cells instances from prefabs
	_generate()

func getCellNature(coordinates):	
	# get cell at those coordinates and use its getNature function
	return self._gridDic[Vector2(coordinates.x, coordinates.y)].getNature()


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	pass
