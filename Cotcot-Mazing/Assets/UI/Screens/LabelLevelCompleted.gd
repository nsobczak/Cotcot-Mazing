extends Label

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	var lName = LevelSelection.getLevelName()
	
	if lName and (self.text != lName):
		lName = lName.left(5) + " " + lName.right(5) + " completed"
		self.text = lName