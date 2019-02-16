extends Spatial

enum CELL_NATURE { OBSTACLE = -1, EMPTY, ACTOR, PICKUP}

export(String) var wallPath = "res://Assets/World/BasicCube/BasicCube.tscn"
export(String) var pickupPath = "res://Assets/World/Pickup/Pickup.tscn"
export(CELL_NATURE) var nature = EMPTY

var _actorOnCell = []


#_________________________________________________________________________________________
func isActorOnCell(actorName):
	return (actorName in self._actorOnCell)

func addToActorOnCell(actorName):
	self._actorOnCell.append(actorName)

func removeFromActorOnCell(actorName):
	self._actorOnCell.remove(actorName)

func delete(actor):
	if actor.name in self._actorOnCell:
		removeFromActorOnCell(actor.name)
	print("deleting {0}".format([actor.name]))
	actor.free() #queue_free

func getActorOnCell():
	return self._actorOnCell


#_________________________________________________________________________________________
func _initializeCellChildren():
	match nature:
		OBSTACLE:
			var wallScene = load(self.wallPath)
			var wall_instance = wallScene.instance()
			self.add_child(wall_instance)
			wall_instance.set_name(self.name + "_wall")
			wall_instance.transform.origin = Vector3(0, 0, 0)
			addToActorOnCell(wall_instance.name)
			print("Cell is obstacle - name = " + wall_instance.name)

		EMPTY:
#			print("Cell is empty")
			pass

		ACTOR:
#			print("Cell is actor")
			pass

		PICKUP:
			var pickupScene = load(self.pickupPath)
			var pickup_instance = pickupScene.instance()
			self.add_child(pickup_instance)
			pickup_instance.set_name(self.name + "_pickup")
			pickup_instance.transform.origin = Vector3(0, 0, 0)
			addToActorOnCell(pickup_instance.name)
#			print("Cell is PICKUP")

	
func _ready():
	# Called when the node is added to the scene for the first time.
	_initializeCellChildren()
	pass

func getNature():
	return nature

func setNature(newNature):
	self.nature = newNature
	#TODO: remove before reinitialize
	_initializeCellChildren()


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
