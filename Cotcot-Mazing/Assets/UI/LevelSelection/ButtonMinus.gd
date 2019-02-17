extends Button


func _ready():
	# Called when the node is added to the scene for the first time.
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _pressed ():
	LevelSelection.changeLevelFileName(false)