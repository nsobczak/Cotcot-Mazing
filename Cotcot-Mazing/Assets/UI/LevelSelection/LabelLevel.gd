extends Label

# class member variables go here, for example:

func _ready():
	pass

func _process(delta):
	var lName = LevelSelection.getLevelName()
	
	if lName and (self.text != lName):
		lName = lName.left(5) + " " + lName.right(5)
		self.text = lName
