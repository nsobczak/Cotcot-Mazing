extends Spatial

enum CELL_NATURE { VOID = -2, OBSTACLE, EMPTY, ACTOR, PICKUP, EGG = 10}

export(CELL_NATURE) var nature = EMPTY

var _wallScene
var _pickupScene 
var _actorOnCell = []


#_________________________________________________________________________________________
func isActorOnCell(actorName):
	return (actorName in self._actorOnCell)

func addToActorOnCell(actorName):
	self._actorOnCell.append(actorName)

func removeFromActorOnCell(actorName):
#	print("removing {0} from actor on cell {1} | new array size = {2}".format([actorName, self.name, len(self._actorOnCell)]))
	self._actorOnCell.erase(actorName)

func delete(actor):
	if actor.name in self._actorOnCell:
		removeFromActorOnCell(actor.name)
#	print("deleting {0}".format([actor.name]))
	actor.queue_free() #queue_free

func getActorOnCell():
	return self._actorOnCell


#_________________________________________________________________________________________
func _initializeCellChildren():
	match nature:
		OBSTACLE:
			var wall_instance = _wallScene.instance()
			self.add_child(wall_instance)
			wall_instance.set_name(self.name + "_wall")
			wall_instance.transform.origin = Vector3(0, 0, 0)
			addToActorOnCell(wall_instance.name)
#			print("Cell is obstacle - name = " + wall_instance.name)

		EMPTY:
			pass
			
		VOID:
			find_node("EmptyCell").visible = false
			pass

		ACTOR:
#			print("Cell is actor")
			pass

		PICKUP:
			var pickup_instance = _pickupScene.instance()
			self.add_child(pickup_instance)
			pickup_instance.set_name(self.name + "_pickup")
			pickup_instance.transform.origin = Vector3(0, 0, 0)
			addToActorOnCell(pickup_instance.name)
#			print("Cell is PICKUP")

		_:
			pass

	
func _ready():
	# Called when the node is added to the scene for the first time.
	_wallScene = load(Global.wallScenePath + "/" + Global.wallSceneName)
	_pickupScene = load(Global.pickupScenePath + "/" + Global.pickupSceneName)
	
	_initializeCellChildren()
	pass

func getNature():
	return nature

func setNature(newNature):
	self.nature = newNature
	#TODO: remove before reinitialize?
#	_initializeCellChildren()

func isEmpty():
	return (self.nature == EMPTY)

func findActorByName(actorName):
	for childNode in self.get_children():
		if (childNode.name == actorName):
			return childNode
	print("{0} wasn't found".format([actorName]))
	return null


#func findInActorOnCell(actorName):
#	for i in range(0, len(self._actorOnCell)):
#		actor = self._actorOnCell[i]
#		if actor == actorName:
#			return true


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
